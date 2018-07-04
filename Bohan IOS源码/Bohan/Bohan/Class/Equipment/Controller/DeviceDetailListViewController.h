//
//  DeviceDetailListViewController.h
//  Bohan
//
//  Created by Yang Lin on 2018/1/9.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import "BaseViewController.h"

@interface DeviceDetailListViewController : BaseViewController

@property (nonatomic, copy) NSString * name;
@property (nonatomic, assign) BOOL isPos;
@property (nonatomic, assign) NSInteger type; // 识别号
@end
