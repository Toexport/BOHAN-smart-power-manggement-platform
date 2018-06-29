//
//  DeviceModel.h
//  Bohan
//
//  Created by Yang Lin on 2018/1/1.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceModel : NSObject

@property (nonatomic, copy) NSString *position;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *sort;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *brand;
@property (nonatomic, copy) NSString *appliancesort;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString * powerinfo;//用电信息
@property (nonatomic, assign) BOOL isOpen;//是否开启


@end
