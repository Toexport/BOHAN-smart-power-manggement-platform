//
//  DeviceInfoViewController.h
//  Bohan
//
//  Created by Yang Lin on 2018/1/16.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import "BaseViewController.h"
@class DeviceModel;
@interface DeviceInfoViewController : BaseViewController


@property (nonatomic, strong) DeviceModel *model;
@property (nonatomic, assign) NSString * type; // ID
@property (nonatomic, strong) NSString * sortt;

@property (weak, nonatomic) IBOutlet UIView *PayView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *StateViewLayoutConstraint; // 状态
@end
