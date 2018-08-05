//
//  MultipleSwitchViewController.m
//  Bohan
//
//  Created by summer on 2018/7/18.
//  Copyright © 2018年 Bohan. All rights reserved.
//


#import "MultipleSwitchViewController.h"
#import "DebuggingANDPublishing.pch"
#import "UIViewController+NavigationBar.h"
@interface MultipleSwitchViewController (){
    //    BOOL openg;
    //    NSInteger totalSecend;//总秒数
    //    NSInteger lastSecend;//剩余秒数点进去
    NSDateFormatter *formatter;
    NSDateFormatter * formatters;
    NSDateFormatter * formatterd;
    //    NSString *start;
    //    NSString *end;
}

@end

@implementation MultipleSwitchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"定时开关", nil);
    [self TimeDisplay];
    [self yyyyMMddHHmm];
    [self StateQuery];
    [self rightBarTitle:Localize(@"刷新") color:[UIColor whiteColor] action:@selector(StateQuery)];
}

// 状态查询
- (void)StateQuery {
    WebSocket *socket = [WebSocket socketManager];
    CommandModel *model = [[CommandModel alloc] init];
    model.command = @"002D";
    model.deviceNo = self.deviceNo;
    [self.view startLoading];
    MyWeakSelf
    [socket sendSingleDataWithModel:model resultBlock:^(id response, NSError *error) {
        [weakSelf.view stopLoading];
        ZPLog(@"--------%@",response);
        self.SwitchStateStr = response;
        [self SwitchStateStrr];
        if (!error) {
        }else {
            [HintView showHint:error.localizedDescription];// 后台返回的提示
        }
    }];
}

// 监测开关状态
- (void)SwitchStateStrr {
    NSString * strin = [_SwitchStateStr substringWithRange:NSMakeRange(34, 2)];
    if ([[self.SwitchStateStr substringWithRange:NSMakeRange(34, 2)] isEqualToString:@"00"]) {
        Open1But.selected = YES;
        Guan1But.selected = NO;
        //        Prompt1Label.text = Localize(@"设置已开启");
    }else
        if ([[self.SwitchStateStr substringWithRange:NSMakeRange(34, 2)] isEqualToString:@"01"]) {
            Guan1But.selected = YES;
            Open1But.selected = NO;
            //            Prompt1Label.text = Localize(@"设置已关闭");
        }
    
    NSString * string = [self.SwitchStateStr substringWithRange:NSMakeRange(46, 2)];
    if ([[self.SwitchStateStr substringWithRange:NSMakeRange(46, 2)] isEqualToString:@"00"]) {
        Open2But.selected = YES;
        Guan2But.selected = NO;
    }else
        if ([[self.SwitchStateStr substringWithRange:NSMakeRange(46, 2)] isEqualToString:@"01"]) {
            Guan2But.selected = YES;
            Open2But.selected = NO;
        }
    
    NSString * stringg = [self.SwitchStateStr substringWithRange:NSMakeRange(58, 2)];
    if ([[self.SwitchStateStr substringWithRange:NSMakeRange(58, 2)] isEqualToString:@"00"]) {
        Open3But.selected = YES;
        Guan3But.selected = NO;
    }else
        if ([[self.SwitchStateStr substringWithRange:NSMakeRange(58, 2)] isEqualToString:@"01"]) {
            Guan3But.selected = YES;
            Open3But.selected = NO;
        }
    ZPLog(@"截取的值为: %@=%@=%@",strin,string,stringg);
}

// 是否显示2-3号开关
- (void)TimeDisplay {
    if ([self.deviceNo containsString:@"61"]) {
        ZPLog(@"%@1个开关",self.deviceNo);
        Switch2view.hidden = YES;
        Switch3view.hidden = YES;
        DividerView.hidden = YES;
        Divider2View.hidden = YES;
    }else
        if ([self.deviceNo containsString:@"62"]) {
            Switch3view.hidden = YES;
            Divider2View.hidden = YES;
        }else
            if ([self.deviceNo containsString:@"63"]) {
                Switch2view.hidden = NO;
                Switch3view.hidden = NO;
                DividerView.hidden = NO;
                Divider2View.hidden = NO;
            }
}

// 开关一
// 开
- (IBAction)Switch1OpenBut:(UIButton *)sender {
    NSString * stringg1 = [NSString stringWithFormat:@"%@%@%@%@%@",self.string1,self.string2,self.string3,self.string4,self.string5];
    NSString * stringg2 = [NSString stringWithFormat:@"%@%@%@%@%@",self.stringg1,self.stringg2,self.stringg3,self.stringg4,self.stringg5];
    ZPLog(@"%@--%@",stringg1,stringg2);
    if (sender.selected) {
        return;
    }else {
        sender.selected =!sender.selected;
        Guan1But.selected = NO;
        if ([stringg2 isEqualToString:@"(null)(null)(null)(null)(null)"]) {
            Open1But.selected = NO;
            Guan1But.selected = YES;
            ZPLog(@"请修改单前时间");
            [HintView showHint:Localize(@"设定时间必须大于当前时间")];
            return;
        }else
            if (stringg1.integerValue > stringg2.integerValue) {
                // string1系统时间 大于 string2修改时间
                Open1But.selected = NO;
                Guan1But.selected = YES;
                ZPLog(@"不能小于当前时间");
                [HintView showHint:Localize(@"设定时间必须大于当前时间")];
                return;
            }else {
                [self Opendatas1];
            }
    }
}

// 开关二
// 开
- (IBAction)Switch2OpenBut:(UIButton *)sender {
    NSString * stringg1 = [NSString stringWithFormat:@"%@%@%@%@%@",self.string1,self.string2,self.string3,self.string4,self.string5];
    NSString * stringg2 = [NSString stringWithFormat:@"%@%@%@%@%@",self.stringg11,self.stringg22,self.stringg33,self.stringg44,self.stringg55];
    ZPLog(@"%@--%@",stringg1,stringg2);
    if (sender.selected) {
        return;
    }else{
        sender.selected = !sender.selected;
        Guan2But.selected = NO;
        if ([stringg2 isEqualToString:@"(null)(null)(null)(null)(null)"]) {
            Open2But.selected = NO;
            Guan2But.selected = YES;
            ZPLog(@"请修改单前时间");
            [HintView showHint:Localize(@"设定时间必须大于当前时间")];
            return;
        }else
            if (stringg1.integerValue > stringg2.integerValue) {
                // string1系统时间 大于 string2修改时间
                Open2But.selected = NO;
                Guan2But.selected = YES;
                ZPLog(@"不能小于当前时间");
                [HintView showHint:Localize(@"设定时间必须大于当前时间")];
                return;
            }else {
                [self Opendatas2];
            }
        ZPLog(@"开2");
    }
}

// 开关三
//开
- (IBAction)Switch3OpenBut:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        Guan3But.selected = NO;
        [self Opendatas3];
        ZPLog(@"选中");
        return;
    }else {
        Guan3But.selected = NO;
        [self CancelTiming1];
        ZPLog(@"取消");
        return;
    }
}

// 关1
- (IBAction)Switch1GuanBut:(UIButton *)sender {
    NSString * stringg1 = [NSString stringWithFormat:@"%@%@%@%@%@",self.string1,self.string2,self.string3,self.string4,self.string5];
    NSString * stringg2 = [NSString stringWithFormat:@"%@%@%@%@%@",self.stringg1,self.stringg2,self.stringg3,self.stringg4,self.stringg5];
    ZPLog(@"%@--%@",stringg1,stringg2);
    if (sender.selected) {
        return;
    }else {
        sender.selected = !sender.selected;
        Open1But.selected = NO;
        if ([stringg2 isEqualToString:@"(null)(null)(null)(null)(null)"]) {
            Open1But.selected = YES;
            Guan1But.selected = NO;
            ZPLog(@"请修改当前时间");
            [HintView showHint:Localize(@"设定时间必须大于当前时间")];
            return;
        }else
            if (stringg1.integerValue > stringg2.integerValue) {
                // string1系统时间 大于 string2修改时间
                Open1But.selected = YES;
                Guan1But.selected = NO;
                ZPLog(@"不能小于当前时间");
                [HintView showHint:Localize(@"设定时间必须大于当前时间")];
                return;
            }else {
                [self Guandatas1];
            }
    }
}

// 关2
- (IBAction)Switch2GuanBut:(UIButton *)sender {
    NSString * stringg1 = [NSString stringWithFormat:@"%@%@%@%@%@",self.string11,self.string22,self.string33,self.string44,self.string55];
    NSString * stringg2 = [NSString stringWithFormat:@"%@%@%@%@%@",self.stringg11,self.stringg22,self.stringg33,self.stringg44,self.stringg55];
    ZPLog(@"%@--%@",stringg1,stringg2);
    if (sender.selected) {
        return;
    }else {
        sender.selected = !sender.selected;
        Open2But.selected = NO;
        if ([stringg2 isEqualToString:@"(null)(null)(null)(null)(null)"]) {
            Open2But.selected = YES;
            Guan2But.selected = NO;
            ZPLog(@"请修改当前时间");
            [HintView showHint:Localize(@"设定时间必须大于当前时间")];
            return;
        }else
            if (stringg1.integerValue > stringg2.integerValue) {
                // string1系统时间 大于 string2修改时间
                Open2But.selected = YES;
                Guan2But.selected = NO;
                ZPLog(@"不能小于当前时间");
                [HintView showHint:Localize(@"设定时间必须大于当前时间")];
                return;
            }else {
                [self Guandatas2];
            }
        ZPLog(@"关2");
    }
}

// 关3
- (IBAction)Switch3GuanBut:(UIButton *)sender {
    if (sender.selected) {
        return;
    }else {
        sender.selected = !sender.selected;
        Open3But.selected = NO;
        [self Guandatas3];
        ZPLog(@"关3");
    }
}

// 定时开（1）
- (void)Opendatas1 {
    NSString * ssting = [[NSString stringWithFormat:@"%@",self.stringg1]substringFromIndex:2];// 获取后两位数字
    _str1 = [NSString stringWithFormat:@"%@%@%@%@%@",ssting,self.stringg2,self.stringg3,self.stringg4,self.stringg5];
    NSString * sstring1 = [[NSString stringWithFormat:@"%@",self.string11]substringFromIndex:2];
    _str2 = [NSString stringWithFormat:@"%@%@%@%@%@",sstring1,self.string22,self.string33,self.string44,self.string55];
    NSString * sstring2 = [[NSString stringWithFormat:@"%@",self.string111]substringFromIndex:2];
    _str3 = [NSString stringWithFormat:@"%@%@%@%@%@",sstring2,self.string222,self.string333,self.string444,self.string555];
    if ([self.deviceNo containsString:@"61"]) {
        NSString * stringg = [NSString stringWithFormat:@"%@FF%@00%@FF",self.str3,self.str2,self.str1];
        //这里的12位其中10位是时间，最后两位是开关“01”或者“”00或者FF，文档上写的
        WebSocket *socket = [WebSocket socketManager];
        CommandModel *command = [[CommandModel alloc] init];
        command.command = @"002C";
        command.deviceNo = self.deviceNo;
        command.content = stringg;
        [self.view startLoading];
        MyWeakSelf
        [socket sendSingleDataWithModel:command resultBlock:^(id response, NSError *error) {
            [weakSelf.view stopLoading];
            ZPLog(@"--------%@",response);
            if (!error) {
                [HintView showHint:Localize(@"开关1定时开启已设置")];
            }else {
                [HintView showHint:error.localizedDescription];// 后台返回的提示
            }
        }];
    }else {
        NSString * stringg = [NSString stringWithFormat:@"%@FF%@FF%@00",self.str3,self.str2,self.str1];
        //这里的12位其中10位是时间，最后两位是开关“01”或者“”00或者FF，文档上写的
        WebSocket *socket = [WebSocket socketManager];
        CommandModel *command = [[CommandModel alloc] init];
        command.command = @"002C";
        command.deviceNo = self.deviceNo;
        command.content = stringg;
        [self.view startLoading];
        MyWeakSelf
        [socket sendSingleDataWithModel:command resultBlock:^(id response, NSError *error) {
            [weakSelf.view stopLoading];
            ZPLog(@"--------%@",response);
            if (!error) {
                [HintView showHint:Localize(@"开关1定时开启已设置")];
            }else {
                [HintView showHint:error.localizedDescription];// 后台返回的提示
            }
        }];
    }
    
}

// 定时开（2）
- (void)Opendatas2 {
    NSString * ssting = [[NSString stringWithFormat:@"%@",self.string1]substringFromIndex:2];// 获取后两位数字
    _str1 = [NSString stringWithFormat:@"%@%@%@%@%@",ssting,self.string2,self.string3,self.string4,self.string5];
    
    NSString * sstring1 = [[NSString stringWithFormat:@"%@",self.stringg11]substringFromIndex:2];
    _str2 = [NSString stringWithFormat:@"%@%@%@%@%@",sstring1,self.stringg22,self.stringg33,self.stringg44,self.stringg55];
    NSString * sstring2 = [[NSString stringWithFormat:@"%@",self.string111]substringFromIndex:2];
    _str3 = [NSString stringWithFormat:@"%@%@%@%@%@",sstring2,self.string222,self.string333,self.string444,self.string555];
    NSString * stringg = [NSString stringWithFormat:@"%@FF%@00%@FF",self.str3,self.str2,self.str1];
    //这里的12位其中10位是时间，最后两位是开关“01”或者“”00或者FF，文档上写的
    WebSocket *socket = [WebSocket socketManager];
    CommandModel *command = [[CommandModel alloc] init];
    command.command = @"002C";
    command.deviceNo = self.deviceNo;
    command.content = stringg;
    [self.view startLoading];
    MyWeakSelf
    [socket sendSingleDataWithModel:command resultBlock:^(id response, NSError *error) {
        [weakSelf.view stopLoading];
        ZPLog(@"--------%@",response);
        if (!error) {
            [HintView showHint:Localize(@"开关2定时开启已设置")];
        }else {
            [HintView showHint:error.localizedDescription];// 后台返回的提示
        }
    }];
}

// 定时开（3）
- (void)Opendatas3 {
    NSString * ssting = [[NSString stringWithFormat:@"%@",self.string1]substringFromIndex:2];// 获取后两位数字
    _str1 = [NSString stringWithFormat:@"%@%@%@%@%@",ssting,self.string2,self.string3,self.string4,self.string5];
    
    NSString * sstring1 = [[NSString stringWithFormat:@"%@",self.string11]substringFromIndex:2];
    _str2 = [NSString stringWithFormat:@"%@%@%@%@%@",sstring1,self.string22,self.string33,self.string44,self.string55];
    
    NSString * sstring2 = [[NSString stringWithFormat:@"%@",self.string111]substringFromIndex:2];
    _str3 = [NSString stringWithFormat:@"%@%@%@%@%@",sstring2,self.string222,self.string333,self.string444,self.string555];
    NSString * stringg = [NSString stringWithFormat:@"%@00%@FF%@FF",self.str3,self.str2,self.str1];
    //这里的12位其中10位是时间，最后两位是开关“01”或者“”00或者FF，文档上写的
    WebSocket *socket = [WebSocket socketManager];
    CommandModel *command = [[CommandModel alloc] init];
    command.command = @"002C";
    command.deviceNo = self.deviceNo;
    command.content = stringg;
    [self.view startLoading];
    MyWeakSelf
    [socket sendSingleDataWithModel:command resultBlock:^(id response, NSError *error) {
        [weakSelf.view stopLoading];
        ZPLog(@"--------%@",response);
        if (!error) {
            [HintView showHint:Localize(@"开关3定时开启已设置")];
        }else {
            [HintView showHint:error.localizedDescription];// 后台返回的提示
        }
    }];
}

// 取消定时开启
- (void)CancelTiming1 {
    NSString * ssting = [[NSString stringWithFormat:@"%@",self.string1]substringFromIndex:2];// 获取后两位数字
    _str1 = [NSString stringWithFormat:@"%@%@%@%@%@",ssting,self.string2,self.string3,self.string4,self.string5];
    NSString * sstring1 = [[NSString stringWithFormat:@"%@",self.string11]substringFromIndex:2];
    _str2 = [NSString stringWithFormat:@"%@%@%@%@%@",sstring1,self.string22,self.string33,self.string44,self.string55];
    NSString * sstring2 = [[NSString stringWithFormat:@"%@",self.string111]substringFromIndex:2];
    _str3 = [NSString stringWithFormat:@"%@%@%@%@%@",sstring2,self.string222,self.string333,self.string444,self.string555];
    NSString * stringg = [NSString stringWithFormat:@"%@FF%@FF%@FF",self.str3,self.str2,self.str1];
    //这里的12位其中10位是时间，最后两位是开关“01”或者“”00或者FF，文档上写的
    WebSocket *socket = [WebSocket socketManager];
    CommandModel *command = [[CommandModel alloc] init];
    command.command = @"002C";
    command.deviceNo = self.deviceNo;
    command.content = stringg;
    [self.view startLoading];
    MyWeakSelf
    [socket sendSingleDataWithModel:command resultBlock:^(id response, NSError *error) {
        [weakSelf.view stopLoading];
        ZPLog(@"--------%@",response);
        if (!error) {
            [HintView showHint:Localize(@"定时开启已取消")];
        }else {
            [HintView showHint:error.localizedDescription];// 后台返回的提示
        }
    }];
}

// 取消定时关闭
- (void)CancelTiming2 {
    NSString * ssting = [[NSString stringWithFormat:@"%@",self.string1]substringFromIndex:2];// 获取后两位数字
    _str1 = [NSString stringWithFormat:@"%@%@%@%@%@",ssting,self.string2,self.string3,self.string4,self.string5];
    NSString * sstring1 = [[NSString stringWithFormat:@"%@",self.string11]substringFromIndex:2];
    _str2 = [NSString stringWithFormat:@"%@%@%@%@%@",sstring1,self.string22,self.string33,self.string44,self.string55];
    NSString * sstring2 = [[NSString stringWithFormat:@"%@",self.string111]substringFromIndex:2];
    _str3 = [NSString stringWithFormat:@"%@%@%@%@%@",sstring2,self.string222,self.string333,self.string444,self.string555];
    NSString * stringg = [NSString stringWithFormat:@"%@FF%@FF%@FF",self.str3,self.str2,self.str1];
    //这里的12位其中10位是时间，最后两位是开关“01”或者“”00或者FF，文档上写的
    WebSocket *socket = [WebSocket socketManager];
    CommandModel *command = [[CommandModel alloc] init];
    command.command = @"002C";
    command.deviceNo = self.deviceNo;
    command.content = stringg;
    [self.view startLoading];
    MyWeakSelf
    [socket sendSingleDataWithModel:command resultBlock:^(id response, NSError *error) {
        [weakSelf.view stopLoading];
        ZPLog(@"--------%@",response);
        if (!error) {
            [HintView showHint:Localize(@"定时关闭已取消")];
        }else {
            [HintView showHint:error.localizedDescription];// 后台返回的提示
        }
    }];
}

// 定时关（1）
- (void)Guandatas1 {
    NSString * ssting = [[NSString stringWithFormat:@"%@",self.stringg1]substringFromIndex:2];// 获取后两位数字
    _str1 = [NSString stringWithFormat:@"%@%@%@%@%@",ssting,self.stringg2,self.stringg3,self.stringg4,self.stringg5];
    
    NSString * sstring1 = [[NSString stringWithFormat:@"%@",self.string11]substringFromIndex:2];
    _str2 = [NSString stringWithFormat:@"%@%@%@%@%@",sstring1,self.string22,self.string33,self.string44,self.string55];
    NSString * sstring2 = [[NSString stringWithFormat:@"%@",self.string111]substringFromIndex:2];
    _str3 = [NSString stringWithFormat:@"%@%@%@%@%@",sstring2,self.string222,self.string333,self.string444,self.string555];
    if ([self.deviceNo containsString:@"61"]) {
        NSString * stringg = [NSString stringWithFormat:@"%@FF%@01%@FF",self.str3,self.str2,self.str1];
        //这里的12位其中10位是时间，最后两位是开关“01”或者“”00或者FF，文档上写的
        WebSocket *socket = [WebSocket socketManager];
        CommandModel *command = [[CommandModel alloc] init];
        command.command = @"002C";
        command.deviceNo = self.deviceNo;
        command.content = stringg;
        [self.view startLoading];
        MyWeakSelf
        [socket sendSingleDataWithModel:command resultBlock:^(id response, NSError *error) {
            [weakSelf.view stopLoading];
            ZPLog(@"--------%@",response);
            if (!error) {
                [HintView showHint:Localize(@"开关1定时关闭已设置")];
            }else {
                [HintView showHint:error.localizedDescription];// 后台返回的提示
            }
        }];
    }else {
    NSString * stringg = [NSString stringWithFormat:@"%@FF%@FF%@01",self.str3,self.str2,self.str1];
    //这里的12位其中10位是时间，最后两位是开关“01”或者“”00或者FF，文档上写的
    WebSocket *socket = [WebSocket socketManager];
    CommandModel *command = [[CommandModel alloc] init];
    command.command = @"002C";
    command.deviceNo = self.deviceNo;
    command.content = stringg;
    [self.view startLoading];
    MyWeakSelf
    [socket sendSingleDataWithModel:command resultBlock:^(id response, NSError *error) {
        [weakSelf.view stopLoading];
        ZPLog(@"--------%@",response);
        if (!error) {
            [HintView showHint:Localize(@"开关1定时关闭已设置")];
        }else {
            [HintView showHint:error.localizedDescription];// 后台返回的提示
        }
    }];
    }
}

// 定时关（2）
- (void)Guandatas2 {
    NSString * ssting = [[NSString stringWithFormat:@"%@",self.string1]substringFromIndex:2];// 获取后两位数字
    _str1 = [NSString stringWithFormat:@"%@%@%@%@%@",ssting,self.string2,self.string3,self.string4,self.string5];
    
    NSString * sstring1 = [[NSString stringWithFormat:@"%@",self.stringg11]substringFromIndex:2];
    _str2 = [NSString stringWithFormat:@"%@%@%@%@%@",sstring1,self.stringg22,self.stringg33,self.stringg44,self.stringg55];
    
    NSString * sstring2 = [[NSString stringWithFormat:@"%@",self.string111]substringFromIndex:2];
    _str3 = [NSString stringWithFormat:@"%@%@%@%@%@",sstring2,self.string222,self.string333,self.string444,self.string555];
    NSString * stringg = [NSString stringWithFormat:@"%@FF%@01%@FF",self.str3,self.str2,self.str1];
    //这里的12位其中10位是时间，最后两位是开关“01”或者“”00或者FF，文档上写的
    WebSocket *socket = [WebSocket socketManager];
    CommandModel *command = [[CommandModel alloc] init];
    command.command = @"002C";
    command.deviceNo = self.deviceNo;
    command.content = stringg;
    [self.view startLoading];
    MyWeakSelf
    [socket sendSingleDataWithModel:command resultBlock:^(id response, NSError *error) {
        [weakSelf.view stopLoading];
        ZPLog(@"--------%@",response);
        if (!error) {
            [HintView showHint:Localize(@"开关2定时关闭已设置")];
        }else {
            [HintView showHint:error.localizedDescription];// 后台返回的提示
        }
    }];
}

// 定时关（3）
- (void)Guandatas3 {
    NSString * ssting = [[NSString stringWithFormat:@"%@",self.string1]substringFromIndex:2];// 获取后两位数字
    _str1 = [NSString stringWithFormat:@"%@%@%@%@%@",ssting,self.string2,self.string3,self.string4,self.string5];
    NSString * sstring1 = [[NSString stringWithFormat:@"%@",self.string11]substringFromIndex:2];
    _str2 = [NSString stringWithFormat:@"%@%@%@%@%@",sstring1,self.string22,self.string33,self.string44,self.string55];
    NSString * sstring2 = [[NSString stringWithFormat:@"%@",self.string111]substringFromIndex:2];
    _str3 = [NSString stringWithFormat:@"%@%@%@%@%@",sstring2,self.string222,self.string333,self.string444,self.string555];
    NSString * stringg = [NSString stringWithFormat:@"%@01%@FF%@FF",self.str3,self.str2,self.str1];
    //这里的12位其中10位是时间，最后两位是开关“01”或者“”00或者FF，文档上写的
    WebSocket *socket = [WebSocket socketManager];
    CommandModel *command = [[CommandModel alloc] init];
    command.command = @"002C";
    command.deviceNo = self.deviceNo;
    command.content = stringg;
    [self.view startLoading];
    MyWeakSelf
    [socket sendSingleDataWithModel:command resultBlock:^(id response, NSError *error) {
        [weakSelf.view stopLoading];
        ZPLog(@"--------%@",response);
        if (!error) {
            [HintView showHint:Localize(@"开关3定时关闭已设置")];
        }else {
            [HintView showHint:error.localizedDescription];// 后台返回的提示
        }
    }];
}


// 获取当前年月日时间
- (void)yyyyMMddHHmm {
    NSDate *currentDate = [NSDate date];
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    //IOS 8 之后
    NSUInteger integer = NSCalendarUnitYear | NSCalendarUnitMonth |NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dataCom = [currentCalendar components:integer fromDate:currentDate];
    NSInteger year = [dataCom year]; // 年
    NSInteger month = [dataCom month]; // 月
    NSInteger day = [dataCom day]; // 日
    NSInteger hour = [dataCom hour]; // 时
    NSInteger minute = [dataCom minute]; // 分
    
    self.string1 = [[NSNumber numberWithInteger:year] stringValue];
    self.string11 = [[NSNumber numberWithInteger:year] stringValue];
    self.string111 = [[NSNumber numberWithInteger:year] stringValue];
    Years1TextField.text = [NSString stringWithString:self.string1];
    Years1TextField.enabled = NO;
    Years2TextField.text = [NSString stringWithString:self.string11];
    Years2TextField.enabled = NO;
    Years3TextField.text = [NSString stringWithString:self.string111];
    Years3TextField.enabled = NO;
    
    if(month >= 10) {
        self.string2 = [[NSNumber numberWithInteger:month] stringValue];
        self.string22 = [[NSNumber numberWithInteger:month] stringValue];
        self.string222 = [[NSNumber numberWithInteger:month] stringValue];
    }else {
        self.string2 = [NSString stringWithFormat:@"0%ld",(long)month];
        self.string22 = [NSString stringWithFormat:@"0%ld",(long)month];
        self.string222 = [NSString stringWithFormat:@"0%ld",(long)month];
    }
    Month1TextField.text = [NSString stringWithString:self.string2];
    Month2TextField.text = [NSString stringWithString:self.string22];
    Month3TextField.text = [NSString stringWithString:self.string222];
    
    if (day >= 10) {
        self.string3 = [[NSNumber numberWithInteger:day] stringValue];
        self.string33 = [[NSNumber numberWithInteger:day] stringValue];
        self.string333 = [[NSNumber numberWithInteger:day] stringValue];
    }else {
        self.string3 = [NSString stringWithFormat:@"0%ld",(long)day];
        self.string33 = [NSString stringWithFormat:@"0%ld",(long)day];
        self.string333 = [NSString stringWithFormat:@"0%ld",(long)day];
    }
    Day1textField.text = [NSString stringWithString:self.string3];
    Day2textField.text = [NSString stringWithString:self.string33];
    Day3textField.text = [NSString stringWithString:self.string333];
    
    if (hour >= 10) {
        self.string4 = [[NSNumber numberWithInteger:hour] stringValue];
        self.string44 = [[NSNumber numberWithInteger:hour] stringValue];
        self.string444 = [[NSNumber numberWithInteger:hour] stringValue];
    }else{
        self.string4 = [NSString stringWithFormat:@"0%ld",(long)hour];
        self.string44 = [NSString stringWithFormat:@"0%ld",(long)hour];
        self.string444 = [NSString stringWithFormat:@"0%ld",(long)hour];
    }
    Hours1TextField.text = [NSString stringWithString:self.string4];
    Hours2TextField.text = [NSString stringWithString:self.string44];
    Hours3TextField.text = [NSString stringWithString:self.string444];
    if (minute >= 10) {
        self.string5 = [[NSNumber numberWithInteger:minute] stringValue];
        self.string55 = [[NSNumber numberWithInteger:minute] stringValue];
        self.string555 = [[NSNumber numberWithInteger:minute] stringValue];
    }else {
        self.string5 = [NSString stringWithFormat:@"0%ld",(long)minute];
        self.string55 = [NSString stringWithFormat:@"0%ld",(long)minute];
        self.string555 = [NSString stringWithFormat:@"0%ld",(long)minute];
    }
    Minutes1TextField.text = [NSString stringWithString:self.string5];
    Minutes2TextField.text = [NSString stringWithString:self.string55];
    Minutes3TextField.text = [NSString stringWithString:self.string555];
}

// 按钮1
- (IBAction)switchButton:(UIButton *)sender {
    //    ZPLog(@"开1");
    NSString *string;
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    }
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDayHourMinute scrollToDate:[formatter dateFromString:string] CompleteBlock:^(NSDate *selectDate) {
        [formatter setDateFormat:@"yyyy"];// 解决问题
        [Years1TextField setText:[formatter stringFromDate:selectDate]];
        self.stringg1 = Years1TextField.text;
        Years1TextField.text = [NSString stringWithString:self.stringg1];
        
        [formatter setDateFormat:@"MM"];
        [Month1TextField setText:[formatter stringFromDate:selectDate]];
        self.stringg2 = Month1TextField.text;
        Month1TextField.text = [NSString stringWithString:self.stringg2];
        
        [formatter setDateFormat:@"dd"];
        [Day1textField setText:[formatter stringFromDate:selectDate]];
        self.stringg3 = Day1textField.text;
        Day1textField.text = [NSString stringWithString:self.stringg3];
        
        [formatter setDateFormat:@"HH"];
        [Hours1TextField setText:[formatter stringFromDate:selectDate]];
        self.stringg4 = Hours1TextField.text;
        Hours1TextField.text = [NSString stringWithString:self.stringg4];
        
        [formatter setDateFormat:@"mm"];
        [Minutes1TextField setText:[formatter stringFromDate:selectDate]];
        self.stringg5 = Minutes1TextField.text;
        Minutes1TextField.text = [NSString stringWithString:self.stringg5];
    }];
    datepicker.hideBackgroundYearLabel = YES;
    datepicker.dateLabelColor = kDefualtColor;
    datepicker.doneButtonColor = kDefualtColor;
    [datepicker show];
}

// 按钮2
- (IBAction)switch2Button:(UIButton *)sender {
    //    ZPLog(@"开1");
    NSString *string;
    if (!formatters) {
        formatters = [[NSDateFormatter alloc] init];
        formatters.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    }
    [formatters setDateFormat:@"yyyy-MM-dd HH:mm"];
    WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDayHourMinute scrollToDate:[formatters dateFromString:string] CompleteBlock:^(NSDate *selectDate) {
        [formatters setDateFormat:@"yyyy"];// 解决问题
        [Years2TextField setText:[formatters stringFromDate:selectDate]];
        self.stringg11 = Years2TextField.text;
        Years2TextField.text = [NSString stringWithString:self.stringg11];
        
        [formatters setDateFormat:@"MM"];
        [Month2TextField setText:[formatters stringFromDate:selectDate]];
        self.stringg22 = Month2TextField.text;
        Month2TextField.text = [NSString stringWithString:self.stringg22];
        
        [formatters setDateFormat:@"dd"];
        [Day2textField setText:[formatters stringFromDate:selectDate]];
        self.stringg33 = Day2textField.text;
        Day2textField.text = [NSString stringWithString:self.stringg33];
        
        [formatters setDateFormat:@"HH"];
        [Hours2TextField setText:[formatters stringFromDate:selectDate]];
        self.stringg44 = Hours2TextField.text;
        Hours2TextField.text = [NSString stringWithString:self.stringg44];
        
        [formatters setDateFormat:@"mm"];
        [Minutes2TextField setText:[formatters stringFromDate:selectDate]];
        self.stringg55 = Minutes2TextField.text;
        Minutes2TextField.text = [NSString stringWithString:self.stringg55];
    }];
    
    datepicker.hideBackgroundYearLabel = YES;
    datepicker.dateLabelColor = kDefualtColor;
    datepicker.doneButtonColor = kDefualtColor;
    [datepicker show];
}

// 按钮3
- (IBAction)switch3Button:(UIButton *)sender {
    //    ZPLog(@"开1");
    NSString *string;
    if (!formatterd) {
        formatterd = [[NSDateFormatter alloc] init];
        formatterd.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    }
    [formatterd setDateFormat:@"yyyy-MM-dd HH:mm"];
    WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDayHourMinute scrollToDate:[formatterd dateFromString:string] CompleteBlock:^(NSDate *selectDate) {
        [formatterd setDateFormat:@"yyyy"];// 解决问题
        [Years3TextField setText:[formatterd stringFromDate:selectDate]];
        self.string111 = Years3TextField.text;
        Years3TextField.text = [NSString stringWithString:self.string111];
        
        [formatterd setDateFormat:@"MM"];
        [Month3TextField setText:[formatterd stringFromDate:selectDate]];
        self.string222 = Month3TextField.text;
        Month3TextField.text = [NSString stringWithString:self.string222];
        
        [formatterd setDateFormat:@"dd"];
        [Day3textField setText:[formatterd stringFromDate:selectDate]];
        self.string333 = Day3textField.text;
        Day3textField.text = [NSString stringWithString:self.string333];
        
        [formatterd setDateFormat:@"HH"];
        [Hours3TextField setText:[formatterd stringFromDate:selectDate]];
        self.string444 = Hours3TextField.text;
        Hours3TextField.text = [NSString stringWithString:self.string444];
        
        [formatterd setDateFormat:@"mm"];
        [Minutes3TextField setText:[formatterd stringFromDate:selectDate]];
        self.string555 = Minutes3TextField.text;
        Minutes3TextField.text = [NSString stringWithString:self.string555];
    }];
    
    datepicker.hideBackgroundYearLabel = YES;
    datepicker.dateLabelColor = kDefualtColor;
    datepicker.doneButtonColor = kDefualtColor;
    [datepicker show];
}

@end
