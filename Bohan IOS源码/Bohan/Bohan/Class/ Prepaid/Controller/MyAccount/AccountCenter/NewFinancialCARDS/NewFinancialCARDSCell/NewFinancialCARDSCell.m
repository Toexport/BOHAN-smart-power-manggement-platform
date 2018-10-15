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
}

// 到账方式
- (IBAction)WhyBut:(UIButton *)sender {
    
}

// 确定按钮
- (IBAction)ConfirmBut:(UIButton *)sender {
    if (self.WhyLabel.text || self.NameTExtField.text || self.AccountTextField.text || self.ConfirmAccountTextField.text == nil) {
        ZPLog(@"为空");
    }else {
        if (self.AccountTextField.text != self.ConfirmAccountTextField.text) {
            ZPLog(@"账号不一致");
        }else {
            ZPLog(@"成功2");
        }
    }
}

@end
