//
//  ParamsSettingViewController.h
//  Bohan
//
//  Created by Yang Lin on 2018/1/20.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import "BaseViewController.h"

@interface ParamsSettingViewController : BaseViewController
{
    __weak IBOutlet UIButton *PriceBut;
    __weak IBOutlet UIButton *SaveBut;
    __weak IBOutlet UILabel *deviceId;
    __weak IBOutlet UILabel *price;
    __weak IBOutlet UILabel *limit;
    __weak IBOutlet UITextField *priceTF;
    __weak IBOutlet UITextField *limitTF;
    __weak IBOutlet UILabel *time;
    __weak IBOutlet UILabel *power;
//     新增
    
    __weak IBOutlet UIButton *ParentsModeBut; // 家长模式
    __weak IBOutlet UIButton *ChargingProtectionBut; // 充电保护
    __weak IBOutlet UIButton *PhoneChargingProtectionBut; // 手机充电保护
    __weak IBOutlet UIButton *DDCChargingProtectionBut; // 电动车充电保护
    __weak IBOutlet UIButton *ZNDDBut;  //智能断电控制
    __weak IBOutlet UIButton *SettingBut;  // 设置按钮
    __weak IBOutlet UIButton *timeBut; // 修改时间
    __weak IBOutlet UIButton *PowerBut;  // 功率设置
    
    
    
    
}
@property (nonatomic, copy)  NSString * Coedid;
@property (nonatomic, copy) NSString *dNo;
- (IBAction)saveAction:(UIButton *)sender;
//- (IBAction)savePrice;
//- (IBAction)saveLimit;
//- (IBAction)selectAction:(UIButton *)sender;
- (IBAction)timeEditAction;
- (IBAction)powerEditAction;
@end
