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
    [self TimeDisplay];
    [self yyyyMMddHHmm];
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
    if (sender.selected) {
        return;
    }else{
        sender.selected =!sender.selected;
        Guan1But.selected = NO;
        [self datas];
    }
}

// 定时开关（开）
- (void)datas{
        NSString * ssting = [[NSString stringWithFormat:@"%@",self.string1]substringFromIndex:2];// 获取后两位数字
        _str1 = [NSString stringWithFormat:@"%@%@%@%@%@",ssting,self.string2,self.string3,self.string4,self.string5];
        _str2 = [NSString stringWithFormat:@"%@%@%@%@%@",ssting,self.string2,self.string3,self.string4,self.string5];
        _str3 = [NSString stringWithFormat:@"%@%@%@%@%@",ssting,self.string2,self.string3,self.string4,self.string5];
//    NSString * string11 = @"1807251943";
//    NSString * string22 = @"1807251944";
//    NSString * string33 = @"1807251945";
        NSString * stringg = [NSString stringWithFormat:@"%@00%@FF%@FF",self.str3,self.str2,self.str1];
//    NSString * stringg = [NSString stringWithFormat:@"%@01%@00%@01",string11,string22,string33];
    //    NSString * string = @"1807261800001807261800FF1807261800FF";
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
    Years1TextField.text = [NSString stringWithString:self.string1];
    Years1TextField.enabled = NO;
    Years2TextField.text = [NSString stringWithString:self.string1];
    Years3TextField.text = [NSString stringWithString:self.string1];
    
    if(month >= 10) {
        self.string2 = [[NSNumber numberWithInteger:month] stringValue];
    }else {
        self.string2 = [NSString stringWithFormat:@"0%ld",(long)month];
    }
    Month1TextField.text = [NSString stringWithString:self.string2];
    Month2TextField.text = [NSString stringWithString:self.string2];
    Month3TextField.text = [NSString stringWithString:self.string2];
    
    if (day >= 10) {
        self.string3 = [[NSNumber numberWithInteger:day] stringValue];
    }else {
        self.string3 = [NSString stringWithFormat:@"0%ld",(long)day];
    }
    Day1textField.text = [NSString stringWithString:self.string3];
    Day2textField.text = [NSString stringWithString:self.string3];
    Day3textField.text = [NSString stringWithString:self.string3];
    
    if (hour >= 10) {
        self.string4 = [[NSNumber numberWithInteger:hour] stringValue];
    }else{
        self.string4 = [NSString stringWithFormat:@"0%ld",(long)hour];
    }
    Hours1TextField.text = [NSString stringWithString:self.string4];
    Hours2TextField.text = [NSString stringWithString:self.string4];
    Hours3TextField.text = [NSString stringWithString:self.string4];
    
    if (minute >= 10) {
        self.string5 = [[NSNumber numberWithInteger:minute] stringValue];
    }else {
        self.string5 = [NSString stringWithFormat:@"0%ld",(long)minute];
    }
    Minutes1TextField.text = [NSString stringWithString:self.string5];
    Minutes2TextField.text = [NSString stringWithString:self.string5];
    Minutes3TextField.text = [NSString stringWithString:self.string5];
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
        self.string1 = Years1TextField.text;
        Years1TextField.text = [NSString stringWithString:self.string1];
        
        [formatter setDateFormat:@"MM"];
        [Month1TextField setText:[formatter stringFromDate:selectDate]];
        self.string2 = Month1TextField.text;
        Month1TextField.text = [NSString stringWithString:self.string2];
        
        [formatter setDateFormat:@"dd"];
        [Day1textField setText:[formatter stringFromDate:selectDate]];
        self.string3 = Day1textField.text;
        Day1textField.text = [NSString stringWithString:self.string3];
        
        [formatter setDateFormat:@"HH"];
        [Hours1TextField setText:[formatter stringFromDate:selectDate]];
        self.string4 = Hours1TextField.text;
        Hours1TextField.text = [NSString stringWithString:self.string4];
        
        [formatter setDateFormat:@"mm"];
        [Minutes1TextField setText:[formatter stringFromDate:selectDate]];
        self.string5 = Minutes1TextField.text;
        Minutes1TextField.text = [NSString stringWithString:self.string5];
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
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    }
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDayHourMinute scrollToDate:[formatter dateFromString:string] CompleteBlock:^(NSDate *selectDate) {
        [formatter setDateFormat:@"yyyy"];// 解决问题
        [Years2TextField setText:[formatter stringFromDate:selectDate]];
        self.string1 = Years1TextField.text;
        Years2TextField.text = [NSString stringWithString:self.string1];
        
        [formatter setDateFormat:@"MM"];
        [Month2TextField setText:[formatter stringFromDate:selectDate]];
        self.string2 = Month2TextField.text;
        Month2TextField.text = [NSString stringWithString:self.string2];
        
        [formatter setDateFormat:@"dd"];
        [Day2textField setText:[formatter stringFromDate:selectDate]];
        self.string3 = Day2textField.text;
        Day2textField.text = [NSString stringWithString:self.string3];
        
        [formatter setDateFormat:@"HH"];
        [Hours2TextField setText:[formatter stringFromDate:selectDate]];
        self.string4 = Hours2TextField.text;
        Hours2TextField.text = [NSString stringWithString:self.string4];
        
        [formatter setDateFormat:@"mm"];
        [Minutes2TextField setText:[formatter stringFromDate:selectDate]];
        self.string5 = Minutes2TextField.text;
        Minutes2TextField.text = [NSString stringWithString:self.string5];
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
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    }
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDayHourMinute scrollToDate:[formatter dateFromString:string] CompleteBlock:^(NSDate *selectDate) {
        [formatter setDateFormat:@"yyyy"];// 解决问题
        [Years3TextField setText:[formatter stringFromDate:selectDate]];
        self.string1 = Years3TextField.text;
        Years3TextField.text = [NSString stringWithString:self.string1];
        
        [formatter setDateFormat:@"MM"];
        [Month3TextField setText:[formatter stringFromDate:selectDate]];
        self.string2 = Month3TextField.text;
        Month3TextField.text = [NSString stringWithString:self.string2];
        
        [formatter setDateFormat:@"dd"];
        [Day3textField setText:[formatter stringFromDate:selectDate]];
        self.string3 = Day3textField.text;
        Day3textField.text = [NSString stringWithString:self.string3];
        
        [formatter setDateFormat:@"HH"];
        [Hours3TextField setText:[formatter stringFromDate:selectDate]];
        self.string4 = Hours3TextField.text;
        Hours3TextField.text = [NSString stringWithString:self.string4];
        
        [formatter setDateFormat:@"mm"];
        [Minutes3TextField setText:[formatter stringFromDate:selectDate]];
        self.string5 = Minutes3TextField.text;
        Minutes3TextField.text = [NSString stringWithString:self.string5];
    }];
    
    datepicker.hideBackgroundYearLabel = YES;
    datepicker.dateLabelColor = kDefualtColor;
    datepicker.doneButtonColor = kDefualtColor;
    [datepicker show];
}

@end
