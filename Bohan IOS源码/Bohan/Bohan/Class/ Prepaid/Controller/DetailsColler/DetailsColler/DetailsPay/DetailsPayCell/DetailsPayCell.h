//
//  DetailsPayCell.h
//  Bohan
//
//  Created by summer on 2018/9/7.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface DetailsPayCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *DeviceId;  // 设备ID
@property (weak, nonatomic) IBOutlet UIView *BalanceView; // 余额View
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TitleLayoutConstraint;

//@property (weak, nonatomic) IBOutlet UIButton *BalanceBut;
//@property (weak, nonatomic) IBOutlet UIButton *AlapyPayBut;
//@property (weak, nonatomic) IBOutlet UIButton *WechatPayBut;
//@property (weak, nonatomic) IBOutlet UIButton *UnionpayBut;
@property (weak, nonatomic) IBOutlet UILabel *PriceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *MainImage;
@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *ConfirmBut; // 确认按钮
@property (nonatomic, strong) NSString * PayWay; // 方式

typedef void (^BalanceViewBlock)(id response);
@property (nonatomic , copy) BalanceViewBlock balanceViewBlock;
// 支付按钮
typedef void (^PayBlock)(id DeviceId ,id PayWay ,id PriceLabel);
@property (nonatomic , copy) PayBlock payBlockBlock;

@end
