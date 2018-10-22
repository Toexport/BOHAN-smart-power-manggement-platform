//
//  NewFinancialCARDSCell.h
//  Bohan
//
//  Created by summer on 2018/9/25.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewFinancialCARDSCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *WhyImageS; // 主图
@property (weak, nonatomic) IBOutlet UILabel *WhyLabel; // 提款方式
@property (weak, nonatomic) IBOutlet UIButton *WhyBut; // 选择按钮
typedef void (^WhyButBlock)(id response);
@property (nonatomic ,copy) WhyButBlock whyButBlock;
@property (weak, nonatomic) IBOutlet UITextField *NameTExtField; // 姓名
@property (weak, nonatomic) IBOutlet UITextField *AccountTextField; // 账号
@property (weak, nonatomic) IBOutlet UITextField *ConfirmAccountTextField; // 确认账号
@property (weak, nonatomic) IBOutlet UITextField *BankTextField; // 银行
@property (weak, nonatomic) IBOutlet UIButton *ConfirmBut; // 确定按钮

@property (weak, nonatomic) IBOutlet UIView *BackView; // 背景View
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *BackViewLayoutConstraint;
@property (weak, nonatomic) IBOutlet UIView *DividerView1; // 分割线
@property (weak, nonatomic) IBOutlet UIView *BankView; // 银联View
@property (weak, nonatomic) IBOutlet UILabel *RemindLabel; // 提示Label


@property (nonatomic, strong) NSString * WhyWay; // 方式
- (void)updateBalanceView:(NSInteger)type;

@end

NS_ASSUME_NONNULL_END
