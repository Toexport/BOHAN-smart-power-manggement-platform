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
    NSDateFormatter *formatter;
    NSDateFormatter * formatters;
    NSDateFormatter * formatterd;
    NSDate *selectDate1;
    NSDate *selectDate2;
    NSDate *selectDate3;
}

@end

@implementation MultipleSwitchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"定时开关", nil);
    [self TimeDisplay];
    [self yyyyMMddHHmm];
    [self rightBarTitle:Localize(@"刷新") color:[UIColor whiteColor] action:@selector(StateQuery)];
}

- (void)viewWillAppear:(BOOL)animated {
    [self StateQuery];
    [self GetsTheLastWriteTime]; // 获取上次写入时间
}

// 状态查询
- (void)StateQuery {
    WebSocket *socket = [WebSocket socketManager];
    CommandModel *model = [[CommandModel alloc] init];
    model.command = @"0002";
    model.deviceNo = self.deviceNo;
    [self.view startLoading];
    MyWeakSelf
    [socket sendSingleDataWithModel:model resultBlock:^(id response, NSError *error) {
        [weakSelf.view stopLoading];
//        ZPLog(@"--------%@",response);
        if (!error) {
            NSString * str = response;
            NSString * string = [str substringWithRange:NSMakeRange(24, 2)];
            if ([string containsString:@"80"]) {
                self.TurnOnSwitch1.selected = NO;
                self.TurnOnSwitch2.selected = NO;
                self.TurnOnSwitch3.selected = NO;
            }else
            if ([string containsString:@"81"]) {
                self.TurnOnSwitch1.selected = YES;
                self.TurnOnSwitch2.selected = NO;
                self.TurnOnSwitch3.selected = NO;
            }else
            if ([string containsString:@"82"]) {
                self.TurnOnSwitch1.selected = NO;
                self.TurnOnSwitch2.selected = YES;
                self.TurnOnSwitch3.selected = NO;
            }else
            if ([string containsString:@"83"]) {
                self.TurnOnSwitch1.selected = YES;
                self.TurnOnSwitch2.selected = YES;
                self.TurnOnSwitch3.selected = NO;
            }else
            if ([string containsString:@"84"]) {
                self.TurnOnSwitch1.selected = NO;
                self.TurnOnSwitch2.selected = NO;
                self.TurnOnSwitch3.selected = YES;
            }else
            if ([string containsString:@"85"]) {
                self.TurnOnSwitch1.selected = YES;
                self.TurnOnSwitch2.selected = NO;
                self.TurnOnSwitch3.selected = YES;
            }else
            if ([string containsString:@"86"]) {
                self.TurnOnSwitch1.selected = NO;
                self.TurnOnSwitch2.selected = YES;
                self.TurnOnSwitch3.selected = YES;
            }else
            if ([string containsString:@"87"]) {
                self.TurnOnSwitch1.selected = YES;
                self.TurnOnSwitch2.selected = YES;
                self.TurnOnSwitch3.selected = YES;
            }
//            ZPLog(@"%@",string);
        }else {
            [HintView showHint:error.localizedDescription];// 后台返回的提示
        }
    }];
}

// 获取上次写入时间
- (void)GetsTheLastWriteTime {
    WebSocket *socket = [WebSocket socketManager];
    CommandModel *model = [[CommandModel alloc] init];
    model.command = @"002D";
    model.deviceNo = self.deviceNo;
    [self.view startLoading];
    MyWeakSelf
    [socket sendSingleDataWithModel:model resultBlock:^(id response, NSError *error) {
        [weakSelf.view stopLoading];
//        ZPLog(@"--------%@",response);
        if (!error) {
            NSString * str = response;
            NSString * string1 = [str substringWithRange:NSMakeRange(24, 10)];
            NSString * Years1 = [string1 substringWithRange:NSMakeRange(0, 2)];
            Years1TextField.text = [NSString stringWithFormat:@"%d%@",20,Years1];
            NSString * Month1 = [string1 substringWithRange:NSMakeRange(2, 2)];
            Month1TextField.text = [NSString stringWithFormat:@"%@",Month1];
            NSString * Day1 = [string1 substringWithRange:NSMakeRange(4, 2)];
            Day1textField.text = [NSString stringWithFormat:@"%@",Day1];
            NSString * Hours1 = [string1 substringWithRange:NSMakeRange(6, 2)];
            Hours1TextField.text = [NSString stringWithFormat:@"%@",Hours1];
            NSString * Minutes1 = [string1 substringWithRange:NSMakeRange(8, 2)];
            Minutes1TextField.text = [NSString stringWithFormat:@"%@",Minutes1];
//            ZPLog(@"%@-%@-%@-%@-%@",Years1,Month1,Day1,Hours1,Minutes1);
//             开关2
            NSString * string2 = [str substringWithRange:NSMakeRange(36, 10)];
            NSString * Years2 = [string2 substringWithRange:NSMakeRange(0, 2)];
            Years1TextField.text = [NSString stringWithFormat:@"%d%@",20,Years2];
            NSString * Month2 = [string2 substringWithRange:NSMakeRange(2, 2)];
            Month2TextField.text = [NSString stringWithFormat:@"%@",Month2];
            NSString * Day2 = [string2 substringWithRange:NSMakeRange(4, 2)];
            Day2textField.text = [NSString stringWithFormat:@"%@",Day2];
            NSString * Hours2 = [string2 substringWithRange:NSMakeRange(6, 2)];
            Hours2TextField.text = [NSString stringWithFormat:@"%@",Hours2];
            NSString * Minutes2 = [string2 substringWithRange:NSMakeRange(8, 2)];
            Minutes2TextField.text = [NSString stringWithFormat:@"%@",Minutes2];
//            ZPLog(@"%@-%@-%@-%@-%@",Years2,Month2,Day2,Hours2,Minutes2);
//            开关3
            NSString * string3 = [str substringWithRange:NSMakeRange(48, 10)];
            NSString * Years3 = [string3 substringWithRange:NSMakeRange(0, 2)];
            Years3TextField.text = [NSString stringWithFormat:@"%d%@",20,Years3];
            NSString * Month3 = [string3 substringWithRange:NSMakeRange(2, 2)];
            Month3TextField.text = [NSString stringWithFormat:@"%@",Month3];
            NSString * Day3 = [string3 substringWithRange:NSMakeRange(4, 2)];
            Day3textField.text = [NSString stringWithFormat:@"%@",Day3];
            NSString * Hours3 = [string3 substringWithRange:NSMakeRange(6, 2)];
            Hours3TextField.text = [NSString stringWithFormat:@"%@",Hours3];
            NSString * Minutes3 = [string3 substringWithRange:NSMakeRange(8, 2)];
            Minutes3TextField.text = [NSString stringWithFormat:@"%@",Minutes3];
//            ZPLog(@"%@-%@-%@-%@-%@",Years1,Month1,Day1,Hours1,Minutes1);
        }else {
            [HintView showHint:error.localizedDescription];// 后台返回的提示
        }
    }];
}

// 是否显示2-3号开关
- (void)TimeDisplay {
    NSString * strID = [self.deviceNo substringWithRange:NSMakeRange(0, 2)];
    if ([strID containsString:@"61"]) {
        ZPLog(@"%@1个开关",strID);
        Label2Text.text = Localize(@"开关1历史设置时间");
        Switch1view.hidden = YES;
        View2LayoutConstraint.constant = - 126;
        View4LayoutConstraint.constant = - 106;
        Switch3view.hidden = YES;
        Switch3view.hidden = YES;
        Divider2View.hidden = YES;
    }else
        if ([strID containsString:@"62"]) {
            Label3Text.text = Localize(@"开关2历史设置时间");
            Switch2view.hidden = YES;
            View3LayoutConstraint.constant = - 126;
            Divider2View.hidden = YES;
    }else
        if ([strID containsString:@"63"]) {
            Switch2view.hidden = NO;
            Switch3view.hidden = NO;
            DividerView.hidden = NO;
            Divider2View.hidden = NO;
    }
}

// 开关一
// 开
- (IBAction)Switch1OpenBut:(UIButton *)sender {
    sender.selected =!sender.selected;
    if (sender.selected) {
        sender.selected = YES;
        Guan1But.selected = NO;
        ZPLog(@"选中");
        return;
    }else {
        ZPLog(@"取消");
        return;
    }
}

// 开关二
// 开
- (IBAction)Switch2OpenBut:(UIButton *)sender {
    sender.selected =! sender.selected;
    if (sender.selected) {
        sender.selected = YES;
        Guan2But.selected = NO;
        return;
    }else {
        ZPLog(@"取消");
        return;
    }
}

// 开关三
//开
- (IBAction)Switch3OpenBut:(UIButton *)sender {
    sender.selected =! sender.selected;
    if (sender.selected) {
        sender.selected = YES;
        Guan3But.selected = NO;
        ZPLog(@"选中");
        return;
    }else {
        ZPLog(@"取消");
        return;
    }
}

// 关1
- (IBAction)Switch1GuanBut:(UIButton *)sender {
    sender.selected =! sender.selected;
    if (sender.selected) {
        sender.selected = YES;
        Open1But.selected = NO;
        ZPLog(@"选中");
        return;
    }else {
        ZPLog(@"取消");
        return;
    }
}

// 关2
- (IBAction)Switch2GuanBut:(UIButton *)sender {
    sender.selected =! sender.selected;
    if (sender.selected) {
        sender.selected = YES;
        Open2But.selected = NO;
        ZPLog(@"选中");
        return;
    }else {
        ZPLog(@"取消");
        return;
    }
}

// 关3
- (IBAction)Switch3GuanBut:(UIButton *)sender {
    sender.selected =! sender.selected;
    if (sender.selected) {
        sender.selected = YES;
        Open3But.selected = NO;
        ZPLog(@"选中");
        return;
    }else {
        ZPLog(@"取消");
        return;
    }
}

/**
 按钮集合
 @return return value description
 */
- (NSString *)getContent {
    NSMutableString *content = [NSMutableString string];
    //    第一个按钮
    NSString *ssting = [[NSString stringWithFormat:@"%@",self.string111]substringFromIndex:2];
    [content appendFormat:@"%@%@%@%@%@",ssting,self.string222,self.string333,self.string444,self.string555];
    if (!Open1But.selected && !Guan1But.selected) {
        [content appendString:@"FF"];
    } else {
        [content appendFormat:@"%@",Guan1But.selected?@"00":@"01"];
    }
//      第二个按钮
    ssting = [[NSString stringWithFormat:@"%@",self.string11]substringFromIndex:2];
    [content appendFormat:@"%@%@%@%@%@",ssting,self.string22,self.string33,self.string44,self.string55];
    if (!Open2But.selected && !Guan2But.selected) {
        [content appendString:@"FF"];
    } else {
        [content appendFormat:@"%@",Guan2But.selected?@"00":@"01"];
    }
    //    第三个开关
    ssting = [[NSString stringWithFormat:@"%@",self.string1]substringFromIndex:2];
    [content appendFormat:@"%@%@%@%@%@",ssting,self.string2,self.string3,self.string4,self.string5];
    if (!Open3But.selected && !Guan3But.selected) {
        [content appendString:@"FF"];
    } else {
        [content appendFormat:@"%@",Guan3But.selected?@"00":@"01"];
    }
    return content;
}

// 一键设置所有的开关
- (IBAction)OneKeySetsAllTheSwitches:(UIButton *)sender {
    NSDate *date = [[NSDate date] dateWithFormatter:@"yyyy-MM-dd HH:mm"];
    if (([date compare:selectDate1]>0 && (Open1But.selected || Guan1But.selected)) || ([date compare:selectDate2]>0 && (Open2But.selected || Guan2But.selected)) || ([date compare:selectDate3]>0 && (Open3But.selected || Guan3But.selected))) {
        ZPLog(@"不行");
        [HintView showHint:Localize(@"设置时间不能小于当前时间")];
        return;
    }
    WebSocket *socket = [WebSocket socketManager];
    CommandModel *command = [[CommandModel alloc] init];
    command.command = @"002C";
    command.deviceNo = self.deviceNo;
    command.content = [self getContent];
    [self.view startLoading];
    MyWeakSelf
    [socket sendSingleDataWithModel:command resultBlock:^(id response, NSError *error) {
        [weakSelf.view stopLoading];
        if (!error) {
            [HintView showHint:Localize(@"设置成功")];
        }else {
            [HintView showHint:error.localizedDescription];// 后台返回的提示
        }
    }];
}

// 获取当前年月日时间
- (void)yyyyMMddHHmm {
    NSDate *currentDate = [NSDate date];
    selectDate1 = [currentDate dateWithFormatter:@"yyyy-MM-dd HH:mm"];
    selectDate2 = [currentDate dateWithFormatter:@"yyyy-MM-dd HH:mm"];
    selectDate3 = [currentDate dateWithFormatter:@"yyyy-MM-dd HH:mm"];
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
    [formatter setDateFormat:@"yyyyMMddHHmm"];
    WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDayHourMinute scrollToDate:[formatter dateFromString:string] CompleteBlock:^(NSDate *selectDate) {
        selectDate1 = selectDate;
        NSDate *date = [[NSDate date] dateWithFormatter:@"yyyy-MM-dd HH:mm"];
        if ([date compare:selectDate]>0 && (Open1But.selected || Guan1But.selected)) {
            ZPLog(@"不行");
            [HintView showHint:Localize(@"设置时间不能小于当前时间")];
            return ;
        }
        self.str1 = [formatter stringFromDate:selectDate];
        self.str11 = [NSString stringWithFormat:@"%@%@%@%@%@", self.string1, self.string2, self.string3, self.string4, self.string5];
        [formatter setDateFormat:@"yyyy"];// 解决问题
        [Years1TextField setText:[formatter stringFromDate:selectDate]];
        self.string1 = Years1TextField.text;
        [formatter setDateFormat:@"MM"];
        [Month1TextField setText:[formatter stringFromDate:selectDate]];
        self.string2 = Month1TextField.text;
        [formatter setDateFormat:@"dd"];
        [Day1textField setText:[formatter stringFromDate:selectDate]];
        self.string3 = Day1textField.text;
        
        [formatter setDateFormat:@"HH"];
        [Hours1TextField setText:[formatter stringFromDate:selectDate]];
        self.string4 = Hours1TextField.text;
        
        [formatter setDateFormat:@"mm"];
        [Minutes1TextField setText:[formatter stringFromDate:selectDate]];
        self.string5 = Minutes1TextField.text;
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
    [formatters setDateFormat:@"yyyyMMddHHmm"];
    WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDayHourMinute scrollToDate:[formatters dateFromString:string] CompleteBlock:^(NSDate *selectDate) {
        selectDate2 = selectDate;
        NSDate *date = [[NSDate date] dateWithFormatter:@"yyyy-MM-dd HH:mm"];
        if ([date compare:selectDate]>0 && (Open2But.selected || Guan2But.selected)) {
            ZPLog(@"不行");
            [HintView showHint:Localize(@"设置时间不能小于当前时间")];
            return ;
        }
        self.str2 = [formatters stringFromDate:selectDate];
        self.str22 = [NSString stringWithFormat:@"%@%@%@%@%@", self.string11, self.string22, self.string33, self.string44, self.string55];
        [formatters setDateFormat:@"yyyy"];// 解决问题
        [Years2TextField setText:[formatters stringFromDate:selectDate]];
        self.string11 = Years2TextField.text;
        
        [formatters setDateFormat:@"MM"];
        [Month2TextField setText:[formatters stringFromDate:selectDate]];
        self.string22 = Month2TextField.text;
        
        [formatters setDateFormat:@"dd"];
        [Day2textField setText:[formatters stringFromDate:selectDate]];
        self.string33 = Day2textField.text;
        
        [formatters setDateFormat:@"HH"];
        [Hours2TextField setText:[formatters stringFromDate:selectDate]];
        self.string44 = Hours2TextField.text;
        
        [formatters setDateFormat:@"mm"];
        [Minutes2TextField setText:[formatters stringFromDate:selectDate]];
        self.string55 = Minutes2TextField.text;
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
    [formatterd setDateFormat:@"yyyyMMddHHmm"];
    WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDayHourMinute scrollToDate:[formatterd dateFromString:string] CompleteBlock:^(NSDate *selectDate) {
        selectDate3 = selectDate;
        NSDate *date = [[NSDate date] dateWithFormatter:@"yyyy-MM-dd HH:mm"];
        if ([date compare:selectDate]>0 && (Open3But.selected || Guan3But.selected)) {
            ZPLog(@"不行");
            [HintView showHint:Localize(@"设置时间不能小于当前时间")];
            return ;
        }
        self.str3 = [formatterd stringFromDate:selectDate];
        self.str33 = [NSString stringWithFormat:@"%@%@%@%@%@", self.string111, self.string222, self.string333, self.string444, self.string555];
        [formatterd setDateFormat:@"yyyy"];// 解决问题
        [Years3TextField setText:[formatterd stringFromDate:selectDate]];
        self.string111 = Years3TextField.text;
        
        [formatterd setDateFormat:@"MM"];
        [Month3TextField setText:[formatterd stringFromDate:selectDate]];
        self.string222 = Month3TextField.text;
        [formatterd setDateFormat:@"dd"];
        [Day3textField setText:[formatterd stringFromDate:selectDate]];
        self.string333 = Day3textField.text;
        
        [formatterd setDateFormat:@"HH"];
        [Hours3TextField setText:[formatterd stringFromDate:selectDate]];
        self.string444 = Hours3TextField.text;
        
        [formatterd setDateFormat:@"mm"];
        [Minutes3TextField setText:[formatterd stringFromDate:selectDate]];
        self.string555 = Minutes3TextField.text;
    }];
    datepicker.hideBackgroundYearLabel = YES;
    datepicker.dateLabelColor = kDefualtColor;
    datepicker.doneButtonColor = kDefualtColor;
    [datepicker show];
}

@end
