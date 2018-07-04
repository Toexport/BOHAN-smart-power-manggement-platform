//
//  NSString+HeartDecode.h
//  Bohan
//
//  Created by Yang Lin on 2018/1/15.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (HeartDecode)

- (BOOL)isOn;
- (NSString *)status;

// 插座
- (NSString *)power;

// 一位三位开关
- (NSString *)poweer;

//二位开关
- (NSString *)powweer;

//电表
- (NSString *)powerr;

// GPRS电表
- (NSString *)powerrr;

- (NSString *)statusString;




//用电参数解析
- (NSString *)voltage;

- (NSString *)electric;

- (NSString *)realTimePower;
//  用电参数调用接口(4.0位)
- (NSString *)realTimePowerr;
// 一位开关
- (NSString *)realTimePoerrr;

- (NSString *)realTimePowerFactor;

- (NSString *)elcAmount;

- (NSString *)carbon;

- (NSString *)money;

- (NSString *)time;

- (NSString *)week;

- (NSString *)temperature;

//通电时段星期解析
- (NSString *)loopWeekByHex;

@end
