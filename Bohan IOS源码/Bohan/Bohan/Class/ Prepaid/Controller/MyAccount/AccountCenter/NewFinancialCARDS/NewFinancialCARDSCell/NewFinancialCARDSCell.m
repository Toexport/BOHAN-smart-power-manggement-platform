//
//  NewFinancialCARDSCell.m
//  Bohan
//
//  Created by summer on 2018/9/25.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import "NewFinancialCARDSCell.h"
#import "PrefixHeader.pch"
@implementation NewFinancialCARDSCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.DividerView1.hidden = YES;
    self.BankView.hidden = YES;
    self.BackViewLayoutConstraint.constant = 178;
    self.NameTExtField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.AccountTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.ConfirmAccountTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.BankTextField.clearButtonMode = UITextFieldViewModeWhileEditing;// 一键删除文字
}

// 到账方式
- (IBAction)WhyBut:(UIButton *)sender {
    self.whyButBlock (sender);
}

- (void)updateBalanceView:(NSInteger)type {
    NSArray *imageArray = @[@"AlpayPay",@"WechatPay",@"YhkPay"];
    NSArray *titleArray = @[@"支付宝",@"微信",@"银联卡"];
    _WhyImageS.image = [UIImage imageNamed:imageArray[type]];
    _WhyLabel.text = titleArray[type];
    self.WhyWay = [NSString stringWithFormat:@"%@",self.WhyLabel];
    NSString *newText = [NSString stringWithFormat:@"%@",self.WhyLabel.text];
    if ([newText isEqualToString:Localize(@"银联卡")]) {
        self.DividerView1.hidden = NO;
        self.BankView.hidden = NO;
        self.BackViewLayoutConstraint.constant = 223;
    }else {
        self.DividerView1.hidden = YES;
        self.BankView.hidden = YES;
        self.BackViewLayoutConstraint.constant = 178;
    }
}

// 确定按钮
- (IBAction)ConfirmBut:(UIButton *)sender {
    if ([self.WhyLabel.text isEqualToString:Localize(@"请选择")]) {
        ZPLog(@"请选择提款方式");
        [HintView showHint:Localize(@"请选择提款方式")];
    }else
        if ([self.NameTExtField.text isEqualToString:@""]) {
            ZPLog(@"请填写名字");
            [HintView showHint:Localize(@"请填写名字")];
        }else
            if ([self.AccountTextField.text isEqualToString:@""]) {
                ZPLog(@"请填写账号");
                [HintView showHint:Localize(@"请填写账号")];
            }else
                if ([self.ConfirmAccountTextField.text isEqualToString:@""]) {
                    ZPLog(@"请填写确认账号");
                    [HintView showHint:Localize(@"请填写确认账号")];
                }else
                    if (self.AccountTextField.text.longLongValue != self.ConfirmAccountTextField.text.longLongValue) {
                        ZPLog(@"账号不一致");
                        [HintView showHint:Localize(@"账号不一致")];
                    }else
                        [self AllDateS];
}

- (void)AllDateS {
    ZPLog(@"成功");
}


@end
