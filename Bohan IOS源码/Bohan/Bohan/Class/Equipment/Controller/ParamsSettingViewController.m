//
//  ParamsSettingViewController.m
//  Bohan
//
//  Created by Yang Lin on 2018/1/20.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import "ParamsSettingViewController.h"
#import "UIViewController+NavigationBar.h"
#import "SGActionView.h"
#import "DebuggingANDPublishing.pch"
@interface ParamsSettingViewController ()
{
NSDateFormatter *formatter;
NSMutableArray *muniteArr;
NSMutableArray *powerArr;

}
@end

@implementation ParamsSettingViewController

- (void)viewDidLoad {
[super viewDidLoad];
//    [self ButStatusAttribute];
self.title = Localize(@"增值服务");
[self rightBarTitle:Localize(@"刷新") color:[UIColor whiteColor] action:@selector(deviceParams)];

muniteArr = [NSMutableArray array];
powerArr = [NSMutableArray array];

for (int i = 0; i<60; i++) {
    
    [muniteArr addObject:[NSString stringWithFormat:@"%d",i]];
}
for (int i = 0; i<100; i++) {
    
    [powerArr addObject:[NSString stringWithFormat:@"%d",i]];
}


[deviceId setText:[NSString stringWithFormat:@"ID:%@",self.dNo]];
[self deviceParams];
[self getStatus];
[self getPower];
[self getDelayTime];


}

- (void)deviceParams
{
WebSocket *socket = [WebSocket socketManager];
CommandModel *model = [[CommandModel alloc] init];
model.command = @"0003";
model.deviceNo = self.dNo;
[self.view startLoading];

MyWeakSelf
[socket sendSingleDataWithModel:model resultBlock:^(id response, NSError *error) {
    [weakSelf.view stopLoading];
    
    if (!error) {
        
        NSString *priceStr = [response substringWithRange:NSMakeRange(24, 4)];
        NSString *powerStr = [response substringWithRange:NSMakeRange(28, 6)];
        
        [price setText:[NSString stringWithFormat:@"%d.%02d",[[priceStr substringToIndex:2] intValue],[[priceStr substringFromIndex:2] intValue]]];
        
        [limit setText:[NSString stringWithFormat:@"%d.%02d",[[powerStr substringToIndex:4] intValue],[[powerStr substringFromIndex:4] intValue]]];
        
        
        //            [weakSelf updateViewWithData:response];
        
    }else
    {
        [HintView showHint:error.localizedDescription];
    }
    
    ZPLog(@"--------%@",response);
}];

}


- (void)getStatus
{
WebSocket *socket = [WebSocket socketManager];
CommandModel *model = [[CommandModel alloc] init];
model.command = @"0018";
model.deviceNo = self.dNo;
[self.view startLoading];

MyWeakSelf
[socket sendSingleDataWithModel:model resultBlock:^(id response, NSError *error) {
    [weakSelf.view stopLoading];
    
    if (!error) {
        
        if (((NSString *)response).length>26) {
            
            NSString *status = [response substringWithRange:NSMakeRange(24, 2)];
            NSString *binary = [Utils getBinaryByHex:status];
            NSString *left = [binary substringWithRange:NSMakeRange(binary.length - 3, 1)];
            NSString *center = [binary substringWithRange:NSMakeRange(binary.length - 2, 1)];
            NSString *right = [binary substringFromIndex:binary.length - 1];
            
            BOOL open = NO;
            //一位插座
            if ([self.dNo hasPrefix:@"61"]) {
                if ([center isEqualToString:@"0"]) {
                    open = NO;
                }else
                {
                    open = YES;
                }
                //二位插座
            }else if ([self.dNo hasPrefix:@"62"])
            {
                if ([left isEqualToString:@"0"] || [right isEqualToString:@"0"]) {
                    open = NO;
                }else
                {
                    open = YES;
                }
                //三位插座
            }else if ([self.dNo hasPrefix:@"63"])
            {
                if ([left isEqualToString:@"0"] || [right isEqualToString:@"0"] || [center isEqualToString:@"0"]) {
                    open = NO;
                }else
                {
                    open = YES;
                }
            }else
            {
                if ([status isEqualToString:@"00"]) {
                    open = NO;
                }else
                {
                    open = YES;
                }
            }
            if (open) {
                closeBtn.selected = YES;
                openBtn.selected = NO;
            }else
            {
                closeBtn.selected = NO;
                openBtn.selected = YES;
            }
            
        }
        
    }
    
}];

}

- (void)getPower
{
WebSocket *socket = [WebSocket socketManager];
CommandModel *model = [[CommandModel alloc] init];
model.command = @"0022";
model.deviceNo = self.dNo;
[self.view startLoading];

MyWeakSelf
[socket sendSingleDataWithModel:model resultBlock:^(id response, NSError *error) {
    [weakSelf.view stopLoading];
    
    if (!error) {
        
        if (((NSString *)response).length>26) {
            
            NSString *status = [response substringWithRange:NSMakeRange(24, 2)];
            [power setText:[NSString stringWithFormat:@"%dW",[status intValue]]];
            
        }
    }
    
}];

}

- (void)getDelayTime
{
WebSocket *socket = [WebSocket socketManager];
CommandModel *model = [[CommandModel alloc] init];
model.command = @"0017";
model.deviceNo = self.dNo;
[self.view startLoading];

MyWeakSelf
[socket sendSingleDataWithModel:model resultBlock:^(id response, NSError *error) {
    [weakSelf.view stopLoading];
    
    if (!error) {
        if (((NSString *)response).length>26) {
            NSString *status = [response substringWithRange:NSMakeRange(24, 2)];
            [time setText:[NSString stringWithFormat:@"%d%@",[status intValue], Localize(@"分钟")]];
            
        }
    }
    
}];

}

- (void)checkClose:(BOOL)close
{
WebSocket *socket = [WebSocket socketManager];
CommandModel *model = [[CommandModel alloc] init];
model.command = @"0015";
model.deviceNo = self.dNo;
model.content = close?@"01":@"00";
[self.view startLoading];

MyWeakSelf
[socket sendSingleDataWithModel:model resultBlock:^(id response, NSError *error) {
    [weakSelf.view stopLoading];
    
    if (!error) {
        
        [HintView showHint:Localize(@"设置成功")];
    }else
    {
        [HintView showHint:error.localizedDescription];
    }
    
}];

}


- (void)changeTime
{
WebSocket *socket = [WebSocket socketManager];
CommandModel *model = [[CommandModel alloc] init];
model.command = @"0016";
model.deviceNo = self.dNo;
model.content = [NSString stringWithFormat:@"%02d",[[time.text substringToIndex:time.text.length - 2] intValue]];
[self.view startLoading];

MyWeakSelf
[socket sendSingleDataWithModel:model resultBlock:^(id response, NSError *error) {
    [weakSelf.view stopLoading];
    
    if (!error) {
        
        [HintView showHint:Localize(@"设置成功")];
    }else
    {
        [HintView showHint:error.localizedDescription];
    }
    
}];

}

- (void)changePower
{
WebSocket *socket = [WebSocket socketManager];
CommandModel *model = [[CommandModel alloc] init];
model.command = @"0021";
model.deviceNo = self.dNo;
model.content = [NSString stringWithFormat:@"%02d",[[power.text substringToIndex:power.text.length - 1] intValue]];
[self.view startLoading];

MyWeakSelf
[socket sendSingleDataWithModel:model resultBlock:^(id response, NSError *error) {
    [weakSelf.view stopLoading];
    
    if (!error) {
        
        [HintView showHint:Localize(@"设置成功")];
    }else
    {
        [HintView showHint:error.localizedDescription];
    }
    
}];

}
// 单价BUt
- (IBAction)priceBut:(UIButton *)sender {
if (priceTF.text == nil || priceTF.text.length <= 0) {
    ZPLog(@"没有输入文字");
    [HintView showHint:Localize(@"请输入单价")];
}else {
    [self AllDtaPrice];
}
}

// 负荷门限BUt
- (IBAction)saveAction:(UIButton *)sender {
if (limitTF.text == nil || limitTF.text.length <= 1) {
    ZPLog(@"没有输入文字");
    [HintView showHint:Localize(@"请输入负荷门限")];
}else{
    [self AllDataload];
    
}
    }

//  单价数据
- (void)AllDtaPrice {
WebSocket *socket = [WebSocket socketManager];
CommandModel *model = [[CommandModel alloc] init];
model.deviceNo = self.dNo;

NSArray *contents;
NSString *content;
    if (price.text.length == 0) {
        
        [HintView showHint:Localize(@"请输入单价")];
        return;
    }
    model.command = @"0019";
    contents = [priceTF.text componentsSeparatedByString:@"."];
    
    //    ******注意：此处1.5元会发送0105，不对，需要调整*******
    
    NSString *decimal = contents.count == 1?@"00":contents[1];
    if (decimal.length == 1) {
        decimal = [NSString stringWithFormat:@"%@0",decimal];
    }
    content = [NSString stringWithFormat:@"%02d%02d",[[contents firstObject] intValue],[decimal intValue]];

model.content = content;
[self.view startLoading];

MyWeakSelf
[socket sendSingleDataWithModel:model resultBlock:^(id response, NSError *error) {
    [weakSelf.view stopLoading];
    if (!error) {
            [HintView showHint:Localize(@"保存成功")];
            [price setText:[NSString stringWithFormat:@"%d.%02d",[[content substringToIndex:2] intValue],[[content substringFromIndex:2] intValue]]];
    }else {
        [HintView showHint:error.localizedDescription];
    }
}];
}

// 负荷门限数据
- (void)AllDataload {
WebSocket *socket = [WebSocket socketManager];
CommandModel *model = [[CommandModel alloc] init];
model.deviceNo = self.dNo;

NSArray *contents;
NSString *content;

    if (power.text.length == 0)
    {
        [HintView showHint:Localize(@"请输入负荷门限")];
        
        return;
    }
    model.command = @"0020";
    contents = [limitTF.text componentsSeparatedByString:@"."];
    content = [NSString stringWithFormat:@"%04d%02d",[[contents firstObject] intValue],contents.count == 1?0:[contents[1] intValue]];
model.content = content;
[self.view startLoading];
MyWeakSelf
[socket sendSingleDataWithModel:model resultBlock:^(id response, NSError *error) {
    [weakSelf.view stopLoading];
    
    if (!error) {
        [HintView showHint:Localize(@"保存成功")];
            [limit setText:[NSString stringWithFormat:@"%d.%02d",[[content substringToIndex:4] intValue],[[content substringFromIndex:4] intValue]]];
        
    }else {
        
        [HintView showHint:error.localizedDescription];
    }
    
}];
}



- (IBAction)selectAction:(UIButton *)sender {

if (sender.selected) {
    return;
}
sender.selected = YES;

if (sender == closeBtn) {
    openBtn.selected = NO;
}else
{
    closeBtn.selected = NO;
}

[self checkClose:closeBtn.selected];
}

- (IBAction)timeEditAction {

[SGActionView showSheetWithTitle:nil itemTitles:muniteArr itemSubTitles:nil selectedIndex:[[time.text substringToIndex:time.text.length - Localize(@"分钟").length] integerValue] selectedHandle:^(NSInteger index) {
    [time setText:[NSString stringWithFormat:@"%ld%@",(long)index, Localize(@"分钟")]];
    [self changeTime];
    
}];
}

- (IBAction)powerEditAction {

[SGActionView showSheetWithTitle:nil itemTitles:powerArr itemSubTitles:nil selectedIndex:[[power.text substringToIndex:power.text.length - 1] integerValue] selectedHandle:^(NSInteger index) {
    
    [power setText:[NSString stringWithFormat:@"%ldW",(long)index]];
    [self changePower];
}];
}
@end
