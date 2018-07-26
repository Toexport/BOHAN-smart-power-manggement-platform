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
    NSDateFormatter * formatters;
     NSDateFormatter * formatterd;
    NSString *start;
    NSString *end;
}

@end

@implementation MultipleSwitchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"定时开关", nil);
    [self TimeDisplay];
    [self yyyyMMddHHmm];
    [self StateQuery];
}

// 状态查询
- (void)StateQuery {
        [self.view startLoading];
     NSString * jsonString = self.deviceNo;
    NSDictionary * dic = @{@"deviceCode":jsonString};
        [[NetworkRequest sharedInstance]requestWithUrl:GET_DEVICE_INFO_URL parameter:dic completion:^(id response, NSError *error) {
            [self.view stopLoading];
            ZPLog(@"%@",error);
            ZPLog(@"jsonString");
            ZPLog(@"%@",response);
        }];
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
        [self Opendatas1];
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
        [self Opendatas2];
        ZPLog(@"开2");
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
        [self Opendatas3];
        ZPLog(@"开3");
    }
}

// 关
- (IBAction)Switch1GuanBut:(UIButton *)sender {
    if (sender.selected) {
        return;
    }else{
        sender.selected = !sender.selected;
        Open1But.selected = NO;
        [self Guandatas1];
        ZPLog(@"关1");
        
    }
}

// 关
- (IBAction)Switch2GuanBut:(UIButton *)sender {
    if (sender.selected) {
        return;
    }else{
        sender.selected = !sender.selected;
        Open2But.selected = NO;
        [self Guandatas2];
        ZPLog(@"关2");
    }
}


// 关
- (IBAction)Switch3GuanBut:(UIButton *)sender {
    if (sender.selected) {
        return;
    }else{
        sender.selected = !sender.selected;
        Open3But.selected = NO;
        [self Guandatas3];
        ZPLog(@"关3");
    }
}

// 定时开（1）
- (void)Opendatas1 {
    NSString * ssting = [[NSString stringWithFormat:@"%@",self.string1]substringFromIndex:2];// 获取后两位数字
    _str1 = [NSString stringWithFormat:@"%@%@%@%@%@",ssting,self.string2,self.string3,self.string4,self.string5];
    NSString * sstring1 = [[NSString stringWithFormat:@"%@",self.string11]substringFromIndex:2];
    _str2 = [NSString stringWithFormat:@"%@%@%@%@%@",sstring1,self.string22,self.string33,self.string44,self.string55];
    NSString * sstring2 = [[NSString stringWithFormat:@"%@",self.string111]substringFromIndex:2];
    _str3 = [NSString stringWithFormat:@"%@%@%@%@%@",sstring2,self.string222,self.string333,self.string444,self.string555];
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

// 定时开（2）
- (void)Opendatas2 {
    NSString * ssting = [[NSString stringWithFormat:@"%@",self.string1]substringFromIndex:2];// 获取后两位数字
    _str1 = [NSString stringWithFormat:@"%@%@%@%@%@",ssting,self.string2,self.string3,self.string4,self.string5];
    NSString * sstring1 = [[NSString stringWithFormat:@"%@",self.string11]substringFromIndex:2];
    _str2 = [NSString stringWithFormat:@"%@%@%@%@%@",sstring1,self.string22,self.string33,self.string44,self.string55];
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

// 定时开（3）
- (void)Opendatas3 {
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

// 定时关（1）
- (void)Guandatas1 {
    NSString * ssting = [[NSString stringWithFormat:@"%@",self.string1]substringFromIndex:2];// 获取后两位数字
    _str1 = [NSString stringWithFormat:@"%@%@%@%@%@",ssting,self.string2,self.string3,self.string4,self.string5];
    NSString * sstring1 = [[NSString stringWithFormat:@"%@",self.string11]substringFromIndex:2];
    _str2 = [NSString stringWithFormat:@"%@%@%@%@%@",sstring1,self.string22,self.string33,self.string44,self.string55];
    NSString * sstring2 = [[NSString stringWithFormat:@"%@",self.string111]substringFromIndex:2];
    _str3 = [NSString stringWithFormat:@"%@%@%@%@%@",sstring2,self.string222,self.string333,self.string444,self.string555];
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

// 定时关（2）
- (void)Guandatas2 {
    NSString * ssting = [[NSString stringWithFormat:@"%@",self.string1]substringFromIndex:2];// 获取后两位数字
    _str1 = [NSString stringWithFormat:@"%@%@%@%@%@",ssting,self.string2,self.string3,self.string4,self.string5];
    NSString * sstring1 = [[NSString stringWithFormat:@"%@",self.string11]substringFromIndex:2];
    _str2 = [NSString stringWithFormat:@"%@%@%@%@%@",sstring1,self.string22,self.string33,self.string44,self.string55];
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

// 定时关（3）
- (void)Guandatas3 {
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
    Years3TextField.text = [NSString stringWithString:self.string111];
    
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
        self.string11 = Years2TextField.text;
        Years2TextField.text = [NSString stringWithString:self.string11];
        
        [formatter setDateFormat:@"MM"];
        [Month2TextField setText:[formatter stringFromDate:selectDate]];
        self.string22 = Month2TextField.text;
        Month2TextField.text = [NSString stringWithString:self.string22];
        
        [formatter setDateFormat:@"dd"];
        [Day2textField setText:[formatter stringFromDate:selectDate]];
        self.string33 = Day2textField.text;
        Day2textField.text = [NSString stringWithString:self.string33];
        
        [formatter setDateFormat:@"HH"];
        [Hours2TextField setText:[formatter stringFromDate:selectDate]];
        self.string44 = Hours2TextField.text;
        Hours2TextField.text = [NSString stringWithString:self.string44];
        
        [formatter setDateFormat:@"mm"];
        [Minutes2TextField setText:[formatter stringFromDate:selectDate]];
        self.string55 = Minutes2TextField.text;
        Minutes2TextField.text = [NSString stringWithString:self.string55];
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
    WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDayHourMinute scrollToDate:[formatter dateFromString:string] CompleteBlock:^(NSDate *selectDate) {
        [formatter setDateFormat:@"yyyy"];// 解决问题
        [Years3TextField setText:[formatter stringFromDate:selectDate]];
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
