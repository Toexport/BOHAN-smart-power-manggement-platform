//
//  MultipleSwitchViewController.m
//  Bohan
//
//  Created by summer on 2018/7/18.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import "MultipleSwitchViewController.h"
#import "DebuggingANDPublishing.pch"
@interface MultipleSwitchViewController (){
   BOOL openg;
NSInteger totalSecend;//总秒数
NSInteger lastSecend;//剩余秒数点进去
}
@property (nonatomic, strong) NSString * string1;
@property (nonatomic, strong) NSString * string2;
@property (nonatomic, strong) NSString * string3;
@property (nonatomic, strong) NSString * string4;
@property (nonatomic, strong) NSString * string5;

@end

@implementation MultipleSwitchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"定时开关", nil);
//    .clearButtonMode = UITextFieldViewModeWhileEditing;  // 一键删除文字
    scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag; // 滚动时键盘隐藏
    Years1TextField.keyboardType = UIKeyboardTypeNumberPad; // 设置只能输入数字
    Month1TextField.keyboardType = UIKeyboardTypeNumberPad; // 设置只能输入数字
    Day1textField.keyboardType = UIKeyboardTypeNumberPad; // 设置只能输入数字
    Hours1TextField.keyboardType = UIKeyboardTypeNumberPad; // 设置只能输入数字
    Minutes1TextField.keyboardType = UIKeyboardTypeNumberPad; // 设置只能输入数字
    
    Years2TextField.keyboardType = UIKeyboardTypeNumberPad; // 设置只能输入数字
    Month2TextField.keyboardType = UIKeyboardTypeNumberPad; // 设置只能输入数字
    Day2textField.keyboardType = UIKeyboardTypeNumberPad; // 设置只能输入数字
    Hours2TextField.keyboardType = UIKeyboardTypeNumberPad; // 设置只能输入数字
    Minutes2TextField.keyboardType = UIKeyboardTypeNumberPad; // 设置只能输入数字
    
    Years3TextField.keyboardType = UIKeyboardTypeNumberPad; // 设置只能输入数字
    Month3TextField.keyboardType = UIKeyboardTypeNumberPad; // 设置只能输入数字
    Day3textField.keyboardType = UIKeyboardTypeNumberPad; // 设置只能输入数字
    Hours3TextField.keyboardType = UIKeyboardTypeNumberPad; // 设置只能输入数字
    Minutes3TextField.keyboardType = UIKeyboardTypeNumberPad; // 设置只能输入数字
    [self TimeDisplay];
    [self YYYY];
}

// 是否显示2-3号开关
- (void)TimeDisplay {
    if ([self.Coedid containsString:@"61"]) {
        ZPLog(@"%@1个开关",self.Coedid);
        Switch2view.hidden = YES;
        Switch3view.hidden = YES;
        DividerView.hidden = YES;
        Divider2View.hidden = YES;
    }else
        if ([self.Coedid containsString:@"62"]) {
//            ZPLog(@"%@2个开关",self.Coedid);
            Switch3view.hidden = YES;
            Divider2View.hidden = YES;
    }else
        if ([self.Coedid containsString:@"63"]) {
//            ZPLog(@"%@3个开关",self.Coedid);
            Switch2view.hidden = NO;
            Switch3view.hidden = NO;
            DividerView.hidden = NO;
            Divider2View.hidden = NO;
    }
}

// 开关一
// 开
- (IBAction)Switch1OpenBut:(UIButton *)sender {
    if (sender.selected) {
        return;
    }else{
    sender.selected =!sender.selected;
    Guan1But.selected = NO;
//    ZPLog(@"开1");
        [self datas];
        
//    ZPLog(@"%@",string);
    }
}
// 定时开关（开）
- (void)datas{
//    NSString * string = [NSString stringWithFormat:@"%@%@%@%@%@",self.string1,self.string2,self.string3,self.string4,self.string5];
//    NSString * string = @"201872192FF";??
    WebSocket *socket = [WebSocket socketManager];
    CommandModel *command = [[CommandModel alloc] init];
    command.command = @"002C";
    [socket sendMultiDataWithModel:command resultBlock:^(id response, NSError *error) {
        ZPLog(@"--------%@",response);
        
        if (!error) {
//            [HintView showHint:openg?Localize(@"已开启"):Localize(@"已关闭")];//等半天了，我看了一下，002B没有002A额没有，有些请求的参数好像也是两个一个是002C这种，一个是deviceNo，我搜搜下这个是什么，但是我们已经试过了，穿着两个参数不行，我看接口文档只看到002C，所以就看不懂了是的啊，这个你自己今天先看一下，我待会还要处理一些事情，明天我不上班，明天中午帮你搞吧，你最好还是把代码发给我GIThub下，怎么把你加进去，
        }else {
            [HintView showHint:error.localizedDescription];// 后台返回的提示
            
        }
    }];
    
}

// 关
- (IBAction)Switch1GuanBut:(UIButton *)sender {
    if (sender.selected) {
        return;
    }else{
    sender.selected = !sender.selected;
    Open1But.selected = NO;
    ZPLog(@"关1");
}
}

// 开关二
// 开
- (IBAction)Switch2OpenBut:(UIButton *)sender {
    if (sender.selected) {
        return;
    }else{
        sender.selected = !sender.selected;
        Guan2But.selected = NO;
    ZPLog(@"开2");
    }
}

// 关
- (IBAction)Switch2GuanBut:(UIButton *)sender {
    if (sender.selected) {
        return;
    }else{
        sender.selected = !sender.selected;
        Open2But.selected = NO;
    ZPLog(@"关2");
    }
}

// 开关三
//开
- (IBAction)Switch3OpenBut:(UIButton *)sender {
    if (sender.selected) {
        return;
    }else{
        sender.selected = !sender.selected;
        Guan3But.selected = NO;
    ZPLog(@"开3");
    }
}

// 关
- (IBAction)Switch3GuanBut:(UIButton *)sender {
    if (sender.selected) {
        return;
    }else{
        sender.selected = !sender.selected;
        Open3But.selected = NO;
    ZPLog(@"关3");
}
}


// 获取当前年月日时间
- (void)YYYY {
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
    NSInteger second = [dataCom second]; // 秒
    self.string1 = [[NSNumber numberWithInteger:year] stringValue];
    Years1TextField.text = [NSString stringWithString:self.string1];
    Years2TextField.text = [NSString stringWithString:self.string1];
    Years3TextField.text = [NSString stringWithString:self.string1];
    self.string2 = [[NSNumber numberWithInteger:month] stringValue];
    Month1TextField.text = [NSString stringWithString:self.string2];
    Month2TextField.text = [NSString stringWithString:self.string2];
    Month3TextField.text = [NSString stringWithString:self.string2];
    self.string3 = [[NSNumber numberWithInteger:day] stringValue];
    Day1textField.text = [NSString stringWithString:self.string3];
    Day2textField.text = [NSString stringWithString:self.string3];
    Day3textField.text = [NSString stringWithString:self.string3];
    self.string4 = [[NSNumber numberWithInteger:hour] stringValue];
    Hours1TextField.text = [NSString stringWithString:self.string4];
    Hours2TextField.text = [NSString stringWithString:self.string4];
    Hours3TextField.text = [NSString stringWithString:self.string4];
    self.string5 = [[NSNumber numberWithInteger:minute] stringValue];
    Minutes1TextField.text = [NSString stringWithString:self.string5];
    Minutes2TextField.text = [NSString stringWithString:self.string5];
    Minutes3TextField.text = [NSString stringWithString:self.string5];
    
    ZPLog(@"year===%ld",(long)year);
    ZPLog(@"month===%ld",(long)month);
    ZPLog(@"day===%ld",(long)day);
    ZPLog(@"hour===%ld",(long)hour);
    ZPLog(@"minute===%ld",(long)minute);
    ZPLog(@"second===%ld",(long)second);

}


@end
