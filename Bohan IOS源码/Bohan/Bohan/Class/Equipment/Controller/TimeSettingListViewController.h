//
//  TimeSettingListViewController.h
//  Bohan
//
//  Created by Yang Lin on 2018/1/17.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import "BaseViewController.h"

@interface TimeSettingListViewController : BaseViewController

@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, copy) NSString *deviceNo;
@property (nonatomic, assign) BOOL isParentModel;

@end
