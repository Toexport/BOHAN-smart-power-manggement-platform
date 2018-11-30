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
    UITapGestureRecognizer * tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.BalanceView addGestureRecognizer:tapGesturRecognizer];
}

// View点击事件
-(void)tapAction:(id)tap {
    self.balanceViewBlock (nil);
}

// 余额
//- (IBAction)BalanceBut:(UIButton *)sender {
//    if (sender.selected) {
//        return;
//    }else {
//        sender.selected =! sender.selected;
//        self.PayWay = @"余额";
//        self.AlapyPayBut.selected = NO;
//        self.WechatPayBut.selected = NO;
//        self.UnionpayBut.selected = NO;
//
//        [self.ConfirmBut setEnabled:YES]; //交互关闭
//        self.ConfirmBut.alpha= 100;//透明度
////        return;
//    }
//
//}
// 支付宝
//- (IBAction)AlapyPayBut:(UIButton *)sender {
//    if (sender.selected) {
//        return;
//    }else {
//        sender.selected =! sender.selected;
//        self.PayWay = @"支付宝";
//        self.BalanceBut.selected = NO;
//        self.WechatPayBut.selected = NO;
//        self.UnionpayBut.selected = NO;
//
//        [self.ConfirmBut setEnabled:YES]; //交互关闭
//        self.ConfirmBut.alpha= 100;//透明度
////        return;
//    }
//}
// 微信
//- (IBAction)WechatPayBut:(UIButton *)sender {
//    if (sender.selected) {
//        return;
//    }else {
//        sender.selected =! sender.selected;
//        self.PayWay = @"微信";
//        self.BalanceBut.selected = NO;
//        self.AlapyPayBut.selected = NO;
//        self.UnionpayBut.selected = NO;
//
//        [self.ConfirmBut setEnabled:YES]; //交互关闭
//        self.ConfirmBut.alpha= 100;//透明度
//        //        return;
//    }
//}
//// 银联卡
//- (IBAction)UnionpayBut:(UIButton *)sender {
//    if (sender.selected) {
//        return;
//    }else {
//        sender.selected =! sender.selected;
//        self.PayWay = @"银联";
//        self.BalanceBut.selected = NO;
//        self.AlapyPayBut.selected = NO;
//        self.WechatPayBut.selected = NO;
//
//        [self.ConfirmBut setEnabled:YES]; //交互关闭
//        self.ConfirmBut.alpha= 100;//透明度
////        return;
//    }
//}

- (void)updateBalanceView:(NSInteger)type {
    NSArray * imageArray = @[@"yuePay",@"AlpayPay",@"WechatPay"];
    NSArray * titleArray = @[@"余额",@"支付宝",@"微信"];
    _MainImage.image = [UIImage imageNamed:imageArray[type]];
    _TitleLabel.text = titleArray[type];
    self.PayWay = [NSString stringWithFormat:@"%@",self.TitleLabel];
}

// 付款
- (IBAction)ConfirmBut:(UIButton *)sender {
//    if (self.PayWay == nil || self.PriceLabel.text || self.DeviceId) {
//        ZPLog(@"失败");
//    }else {
//        self.payBlockBlock(self.PriceLabel.text, self.PayWay, self.DeviceId.text);

    NSString * string = [NSString stringWithFormat:@"%@",self.PriceLabel.text];
    NSString * stringg = [NSString stringWithFormat:@"设备ID:%@",self.DeviceId.text];
    self.payBlockBlock(stringg, string);
//        ZPLog(@"成功");
//    }
}

@end
