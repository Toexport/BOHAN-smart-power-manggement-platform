//
//  EarningsTableViewCell.h
//  Bohan
//
//  Created by summer on 2018/9/13.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EarningsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *EarningsYesterdayBut; // 昨日收益
@property (weak, nonatomic) IBOutlet UIView *Underline1View;
@property (weak, nonatomic) IBOutlet UIButton *AllProceedsBut; // 所有收益
@property (weak, nonatomic) IBOutlet UIView *Underline2View;
@property (weak, nonatomic) IBOutlet UIButton *CalendarBut;  // 日历
@property (weak, nonatomic) IBOutlet UILabel *EarningsLabel; // 收益title
@property (weak, nonatomic) IBOutlet UILabel *TotalAmountLabel; // 总收益
@property (nonatomic, strong) NSString * MonthStr;
@property (nonatomic, strong) NSString * DayStr;

@end
