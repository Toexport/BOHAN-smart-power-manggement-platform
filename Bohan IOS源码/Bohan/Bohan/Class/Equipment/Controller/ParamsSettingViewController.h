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
    __weak IBOutlet UILabel *deviceId;
    __weak IBOutlet UILabel *price;
    __weak IBOutlet UILabel *limit;
    __weak IBOutlet UITextField *priceTF;
    __weak IBOutlet UITextField *limitTF;
    __weak IBOutlet UIButton *closeBtn;
    __weak IBOutlet UIButton *openBtn;
    __weak IBOutlet UILabel *time;
    __weak IBOutlet UILabel *power;
    
}

@property (nonatomic, copy) NSString *dNo;
- (IBAction)saveAction:(UIButton *)sender;
//- (IBAction)savePrice;
//- (IBAction)saveLimit;
- (IBAction)selectAction:(UIButton *)sender;
- (IBAction)timeEditAction;
- (IBAction)powerEditAction;
@end
