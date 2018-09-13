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
@property (weak, nonatomic) IBOutlet UIButton *WechatPayBut;
@property (weak, nonatomic) IBOutlet UIButton *AlipayPayBut;
@property (weak, nonatomic) IBOutlet UIButton *DetermineBut;
@property (nonatomic, strong) NSString * AmountPay;
@property (nonatomic, strong) NSString * PayWay; // 方式
@end
