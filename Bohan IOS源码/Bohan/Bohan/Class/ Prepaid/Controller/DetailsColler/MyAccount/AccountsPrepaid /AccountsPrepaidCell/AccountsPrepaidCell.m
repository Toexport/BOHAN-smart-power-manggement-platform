//
//  AccountsPrepaidCell.m
//  Bohan
//
//  Created by summer on 2018/9/5.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import "AccountsPrepaidCell.h"
#import "DebuggingANDPublishing.pch"
#import "PrefixHeader.pch"
@implementation AccountsPrepaidCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.DetermineBut setEnabled:NO]; //交互关闭
    self.DetermineBut.alpha= 0.4;//透明度
}

- (IBAction)PayBut1:(UIButton *)sender {
    if (sender.selected) {
        return;
    }else {
        sender.selected =! sender.selected;
        self.AmountPay = @"5";
        self.PayBut2.selected = NO;
        self.PayBut3.selected = NO;
        self.PayBut4.selected = NO;
        self.PayBut5.selected = NO;
        self.PayBut6.selected = NO;
    }
}

- (IBAction)PayBut2:(UIButton *)sender {
    if (sender.selected) {
        return;
    }else {
        sender.selected =! sender.selected;
        self.AmountPay = @"10";
        self.PayBut1.selected = NO;
        self.PayBut3.selected = NO;
        self.PayBut4.selected = NO;
        self.PayBut5.selected = NO;
        self.PayBut6.selected = NO;
        ZPLog(@"选中");
        return;
    }
    
}

- (IBAction)PayBut3:(UIButton *)sender {
    if (sender.selected) {
        return;
    }else {
        sender.selected =! sender.selected;
        self.AmountPay = @"30";
        self.PayBut2.selected = NO;
        self.PayBut1.selected = NO;
        self.PayBut4.selected = NO;
        self.PayBut5.selected = NO;
        self.PayBut6.selected = NO;
        ZPLog(@"选中");
        return;
    }
}

- (IBAction)PayBut4:(UIButton *)sender {
    if (sender.selected) {
        return;
    }else {
        sender.selected =! sender.selected;
        self.AmountPay = @"50";
        self.PayBut2.selected = NO;
        self.PayBut3.selected = NO;
        self.PayBut1.selected = NO;
        self.PayBut5.selected = NO;
        self.PayBut6.selected = NO;
        ZPLog(@"选中");
        return;
    }
}

- (IBAction)PayBut5:(UIButton *)sender {
    if (sender.selected) {
        return;
    }else {
        sender.selected =! sender.selected;
        self.AmountPay = @"100";
        self.PayBut2.selected = NO;
        self.PayBut3.selected = NO;
        self.PayBut4.selected = NO;
        self.PayBut1.selected = NO;
        self.PayBut6.selected = NO;
        ZPLog(@"选中");
        return;
    }
}

- (IBAction)PayBut6:(UIButton *)sender {
    if (sender.selected) {
        return;
    }else {
        sender.selected =! sender.selected;
        self.AmountPay = @"200";
        self.PayBut2.selected = NO;
        self.PayBut3.selected = NO;
        self.PayBut4.selected = NO;
        self.PayBut5.selected = NO;
        self.PayBut1.selected = NO;
        ZPLog(@"选中");
        return;
    }
}

// 微信
- (IBAction)WechatPayBut:(UIButton *)sender {
    if (!_PayBut1.selected && !_PayBut2.selected && !_PayBut3.selected && !_PayBut4.selected && !_PayBut5.selected && !_PayBut6.selected) {
        ZPLog(@"没有选中金额");
        [HintView showHint:Localize(@"请选择充值金额")];
    }else {
        if (sender.selected) {
            return;
        }else {
            sender.selected =! sender.selected;
            self.PayWay = @"微信";
            self.AlipayPayBut.selected = NO;
            [self.DetermineBut setEnabled:YES]; //交互关闭
            self.DetermineBut.alpha= 100;//透明度
            ZPLog(@"选中");
            ZPLog(@"%@",self.AmountPay);
        }
    }
    
}

// 支付宝
- (IBAction)AlipayPayBut:(UIButton *)sender {
    if (!_PayBut1.selected && !_PayBut2.selected && !_PayBut3.selected && !_PayBut4.selected && !_PayBut5.selected && !_PayBut6.selected) {
        ZPLog(@"没有选中金额");
        [HintView showHint:Localize(@"请选择充值金额")];
    }else {
        if (sender.selected) {
            return;
        }else {
            sender.selected =! sender.selected;
            self.PayWay = @"支付宝";
            self.WechatPayBut.selected = NO;
            [self.DetermineBut setEnabled:YES]; //交互关闭
            self.DetermineBut.alpha= 100;//透明度
            ZPLog(@"选中");
            ZPLog(@"%@",self.AmountPay);
        }
    }
}

//确定按钮
- (IBAction)DetermineBut:(UIButton *)sender {
    if (self.AmountPay == nil || self.PayWay == nil) {
        ZPLog(@"失败");
        return;
    }else {
        ZPLog(@"成功");
        ZPLog(@"%@充值%@元",self.PayWay,self.AmountPay);
    }
}


@end

