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
    NSDateFormatter *formatter;
    NSString *start;
    NSString *end;
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
    formatter = [[NSDateFormatter alloc] init];
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
//    [self YYYY];
     [self datas];
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
//            ZPLog(@"%@2个开关",self.Coedid);
            Switch3view.hidden = YES;
            Divider2View.hidden = YES;
    }else
        if ([self.deviceNo containsString:@"63"]) {
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
    NSString *string;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDayHourMinute scrollToDate:[formatter dateFromString:string] CompleteBlock:^(NSDate *selectDate) {
        
        [formatter setDateFormat:@"yyyy"];// 解决问题
        [Years1TextField setText:[formatter stringFromDate:selectDate]];
        [Years2TextField setText:[formatter stringFromDate:selectDate]];
        [Years3TextField setText:[formatter stringFromDate:selectDate]];
        [formatter setDateFormat:@"MM"];
        [Month1TextField setText:[formatter stringFromDate:selectDate]];
        [Month2TextField setText:[formatter stringFromDate:selectDate]];
        [Month3TextField setText:[formatter stringFromDate:selectDate]];
        [formatter setDateFormat:@"dd"];
        [Day1textField setText:[formatter stringFromDate:selectDate]];
        [Day2textField setText:[formatter stringFromDate:selectDate]];
        [Day3textField setText:[formatter stringFromDate:selectDate]];
        
        [formatter setDateFormat:@"HH"];
        [Hours1TextField setText:[formatter stringFromDate:selectDate]];
        [Hours2TextField setText:[formatter stringFromDate:selectDate]];
        [Hours3TextField setText:[formatter stringFromDate:selectDate]];
        [formatter setDateFormat:@"mm"];
        [Minutes1TextField setText:[formatter stringFromDate:selectDate]];
        [Minutes2TextField setText:[formatter stringFromDate:selectDate]];
        [Minutes3TextField setText:[formatter stringFromDate:selectDate]];
        
//        [formatter setDateFormat:@"yyMMddHHmmss"];
//        start = [formatter stringFromDate:selectDate];
//        if (start.length>0 && end.length>0) {
//
//            [Minutes1TextField setText:[Utils gapDateFrom:[formatter dateFromString:start] toDate:[formatter dateFromString:end]]];
//        }
    }];
    
    datepicker.hideBackgroundYearLabel = YES;
    datepicker.dateLabelColor = kDefualtColor;
    datepicker.doneButtonColor = kDefualtColor;
    [datepicker show];
    
    
    
    
    if (sender.selected) {
        return;
    }else{
        sender.selected =!sender.selected;
        Guan1But.selected = NO;
        //    ZPLog(@"开1");
        
        
        //    ZPLog(@"%@",string);
    }
}
// 定时开关（开）
- (void)datas{ // 老地方，这个我说过了，要和后台联调，我把我能想到的问题都试过了，结果还是不行没办法，最后一个小问题
//    NSString * string = [NSString stringWithFormat:@"%@%@%@%@%@",self.string1,self.string2,self.string3,self.string4,self.string5];
    NSString * string = @"1807241800";
    //这里的12位其中10位是时间，最后两位是开关“01”或者“”00或者FF，文档上写的
    WebSocket *socket = [WebSocket socketManager];
    CommandModel *command = [[CommandModel alloc] init];
    command.command = @"002C";
    command.deviceNo = self.deviceNo;
//    NSMutableString *content = [NSMutableString stringWithString:[Open1But.titleLabel stringByAppendingString:closeBtn.titleLabel.text]];
//    model.content = [content stringByReplacingOccurrencesOfString:@":" withString:@""];
//    不用打印，我目前看的是没有拼过，我要看他是什么啊 是这样的，0027是两个拼在一起的，所以这个可能是3个拼在一起传过去的，你拼过了吗，我打印下，我现在提供两个方法给你试一下，如果不行我也不知道怎么做了，就是你的string应该是12位的，这点要肯定，目前的不够
//    如果10位的时间不行的过就尝试一下12位的时间加上2位的开关，关于时间是怎么排的，是否显示07前面的那种“0”，你都要尝试一下，我说的这些有没有看懂？ok
    command.content = string;
    [self.view startLoading];
    MyWeakSelf
    [socket sendSingleDataWithModel:command resultBlock:^(id response, NSError *error) {
        [weakSelf.view stopLoading];
        ZPLog(@"--------%@",response);
        if (!error) {
            [HintView showHint:openg?Localize(@"已开启"):Localize(@"已关闭")];
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
//    self.string1 = [[NSNumber numberWithInteger:year] stringValue];
//    Years1TextField.text = [NSString stringWithString:self.string1];
//    Years1TextField.enabled = NO;
//    Years2TextField.text = [NSString stringWithString:self.string1];
//    Years3TextField.text = [NSString stringWithString:self.string1];
//    self.string2 = [[NSNumber numberWithInteger:month] stringValue];
//    Month1TextField.text = [NSString stringWithString:self.string2];
//    Month2TextField.text = [NSString stringWithString:self.string2];
//    Month3TextField.text = [NSString stringWithString:self.string2];
//    self.string3 = [[NSNumber numberWithInteger:day] stringValue];
//    Day1textField.text = [NSString stringWithString:self.string3];
//    Day2textField.text = [NSString stringWithString:self.string3];
//    Day3textField.text = [NSString stringWithString:self.string3];
//    self.string4 = [[NSNumber numberWithInteger:hour] stringValue];
//    Hours1TextField.text = [NSString stringWithString:self.string4];
//    Hours2TextField.text = [NSString stringWithString:self.string4];
//    Hours3TextField.text = [NSString stringWithString:self.string4];
//    self.string5 = [[NSNumber numberWithInteger:minute] stringValue];
//    Minutes1TextField.text = [NSString stringWithString:self.string5];
//    Minutes2TextField.text = [NSString stringWithString:self.string5];
//    Minutes3TextField.text = [NSString stringWithString:self.string5];
    
    
    ZPLog(@"year===%ld",(long)year);
    ZPLog(@"month===%ld",(long)month);
    ZPLog(@"day===%ld",(long)day);
    ZPLog(@"hour===%ld",(long)hour);
    ZPLog(@"minute===%ld",(long)minute);
    ZPLog(@"second===%ld",(long)second);

}


@end
