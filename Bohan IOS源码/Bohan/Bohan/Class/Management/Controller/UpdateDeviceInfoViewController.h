//
//  UpdateDeviceInfoViewController.h
//  Bohan
//
//  Created by Yang Lin on 2018/1/28.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import "BaseViewController.h"
@class DeviceModel;
@interface UpdateDeviceInfoViewController : BaseViewController

@property (nonatomic, strong) DeviceModel *model;

- (IBAction)saveAction;
- (IBAction)deviceInfoAction;
- (IBAction)connectAction;
@end
