//
//  AccountsPrepaidCell.h
//  Bohan
//
//  Created by summer on 2018/9/5.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountsPrepaidCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *PayBut1;
@property (weak, nonatomic) IBOutlet UIButton *PayBut2;
@property (weak, nonatomic) IBOutlet UIButton *PayBut3;
@property (weak, nonatomic) IBOutlet UIButton *PayBut4;
@property (weak, nonatomic) IBOutlet UIButton *PayBut5;
@property (weak, nonatomic) IBOutlet UIButton *PayBut6;

@property (weak, nonatomic) IBOutlet UIView *BackView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *BackViewLayoutConstraint;

@property (weak, nonatomic) IBOutlet UIView *AlipayPayView;
@property (weak, nonatomic) IBOutlet UIButton *AlipayPayBut;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *AlipayLayoutConstraint;

@property (weak, nonatomic) IBOutlet UIView *WechatPayView;
@property (weak, nonatomic) IBOutlet UIButton *WechatPayBut;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *WeChatLayoutConstraint;

@property (weak, nonatomic) IBOutlet UIView *ApplePayView;
@property (weak, nonatomic) IBOutlet UIButton *ApplePayBut;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ApplePayLayoutConstraint;


@property (weak, nonatomic) IBOutlet UIButton *DetermineBut;

@property (nonatomic, strong) NSString * AmountPay;
@property (nonatomic, strong) NSString * PayWay; // 方式

// 支付按钮
typedef void (^PayBlock)(id AmountPay ,id PayWay);
@property (nonatomic , copy) PayBlock payBlockBlock;
@end
