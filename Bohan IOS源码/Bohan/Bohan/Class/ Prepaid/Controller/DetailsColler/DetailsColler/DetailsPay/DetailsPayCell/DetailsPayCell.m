//
//  DetailsPayCell.m
//  Bohan
//
//  Created by summer on 2018/9/7.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import "DetailsPayCell.h"
#import "PrefixHeader.pch"
#import "DebuggingANDPublishing.pch"
@implementation DetailsPayCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
// 余额
- (IBAction)BalanceBut:(UIButton *)sender {
    if (sender.selected) {
        sender.selected =! sender.selected;
    }else {
        self.PayWay = @"余额";
        self.AlapyPayBut.selected = NO;
        self.WechatPayBut.selected = NO;
        self.UnionpayBut.selected = NO;
        [self.ConfirmBut setEnabled:YES]; //交互关闭
        self.ConfirmBut.alpha= 100;//透明度
    }
    
}
// 支付宝
- (IBAction)AlapyPayBut:(UIButton *)sender {
    if (sender.selected) {
        sender.selected =! sender.selected;
    }else {
        self.PayWay = @"支付宝";
        self.BalanceBut.selected = NO;
        self.WechatPayBut.selected = NO;
        self.UnionpayBut.selected = NO;
        [self.ConfirmBut setEnabled:YES]; //交互关闭
        self.ConfirmBut.alpha= 100;//透明度
    }
}
// 微信
- (IBAction)WechatPayBut:(UIButton *)sender {
    if (sender.selected) {
        sender.selected =! sender.selected;
    }else {
        self.PayWay = @"微信";
        self.BalanceBut.selected = NO;
        self.AlapyPayBut.selected = NO;
        self.UnionpayBut.selected = NO;
        [self.ConfirmBut setEnabled:YES]; //交互关闭
        self.ConfirmBut.alpha= 100;//透明度
    }
}
// 银联卡
- (IBAction)UnionpayBut:(UIButton *)sender {
    if (sender.selected) {
        sender.selected =! sender.selected;
    }else {
        self.PayWay = @"银联卡";
        self.BalanceBut.selected = NO;
        self.AlapyPayBut.selected = NO;
        self.WechatPayBut.selected = NO;
        [self.ConfirmBut setEnabled:YES]; //交互关闭
        self.ConfirmBut.alpha= 100;//透明度
    }
}

// 付款
- (IBAction)ConfirmBut:(UIButton *)sender {
    if (self.PayWay == nil) {
        ZPLog(@"失败");
    }else {
        ZPLog(@"成功");
        ZPLog(@"%@付款",self.PayWay);
    }
}


@end
