//
//  EarningsTableViewCell.m
//  Bohan
//
//  Created by summer on 2018/9/13.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import "EarningsTableViewCell.h"
#import "PrefixHeader.pch"
#import "DebuggingANDPublishing.pch"
@implementation EarningsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.EarningsYesterdayBut.selected = YES;
    self.Underline1View.hidden = NO;
    [self yyyyMMddHHmm];
}

// 昨天收益按钮
- (IBAction)EarningsYesterdayBut:(UIButton *)sender {
    if (sender.selected) {
        return;
    }else {
        sender.selected =! sender.selected;
        self.AllProceedsBut.selected = NO;
        self.Underline1View.hidden = NO;
        self.Underline2View.hidden = YES;
        [self EarningsYesterdayUI];
        return;
    }
}
// 总收益按钮
- (IBAction)AllProceedsBut:(UIButton *)sender {
    if (sender.selected) {
        return;
    }else {
        sender.selected =! sender.selected;
        self.EarningsYesterdayBut.selected = NO;;
        self.Underline2View.hidden = NO;
        self.Underline1View.hidden = YES;
        [self AllProceedsUI];
        return;
    }
}

// 昨天收益UI
- (void)EarningsYesterdayUI {
    self.CalendarBut.hidden = NO;
    self.EarningsLabel.text = Localize(@"昨日收益 (09月10日)");
    self.TotalAmountLabel.text = Localize(@"￥ 99.50");
    self.IncomeLabel.text = @"13,50";
    self.NoSettlementLabel.text = @"13.50";
    self.ElectricityPricesLabel.text = @"2.5";
    self.NumberLabel.text = @"9";
    self.ElectricityConsumptionLabel.text = @"10";
    self.AbnormalLabel.text = @"3";
}

// 总收益UI
- (void)AllProceedsUI {
    self.CalendarBut.hidden = YES;
    self.EarningsLabel.text = Localize(@"总收益");
    self.TotalAmountLabel.text = Localize(@"￥ 1000.00");
    self.IncomeLabel.text = @"1000";
    self.NoSettlementLabel.text = @"1000";
    self.ElectricityPricesLabel.text = @"2.5";
    self.NumberLabel.text = @"400";
    self.ElectricityConsumptionLabel.text = @"100";
    self.AbnormalLabel.text = @"20";
}

// 获取当前年月日时间
- (void)yyyyMMddHHmm {
    NSTimeInterval time = 24 * 60 * 60;
    NSDate *currentDate = [[NSDate date] dateByAddingTimeInterval:-time];
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    //IOS 8 之后
    NSUInteger integer = NSCalendarUnitMonth |NSCalendarUnitDay;
    NSDateComponents *dataCom = [currentCalendar components:integer fromDate:currentDate];
    NSInteger month = [dataCom month]; // 月
    NSInteger day = [dataCom day]; // 日
    ZPLog(@"%ld-%ld",(long)month,day);
    if(month >= 10) {
        ZPLog(@"%ld",month);
        self.MonthStr = [[NSNumber numberWithInteger:month] stringValue];
    }else {
        self.MonthStr = [NSString stringWithFormat:@"0%ld",(long)month];
    }
    if (day >= 10) {
        self.DayStr = [[NSNumber numberWithInteger:day] stringValue];
    }else {
        self.DayStr = [NSString stringWithFormat:@"0%ld",(long)day];
    }
    [self.CalendarBut setTitle:[NSString stringWithFormat:@"%@",self.DayStr] forState:UIControlStateNormal];
    self.EarningsLabel.text = [NSString stringWithFormat:Localize(@"昨日收益 (%@月%@日)"),self.MonthStr,self.DayStr];
}



@end
