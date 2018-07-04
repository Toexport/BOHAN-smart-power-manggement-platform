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

//电表数据(带小数点)
- (NSString *)powerr;
// 电表数据（不带小数点）
- (NSString *)powerrNo;

// GPRS电表(有小数点)
- (NSString *)powerrr;
// GPRS电表 （没有小数点）
- (NSString *)powerNo;
// GPRS电表（有小数点）
- (NSString *)powerrrr;
// GPRS电表（没有有小数点）
- (NSString *)powerrrrNo;

- (NSString *)statusString;




//用电参数解析
- (NSString *)voltage;

- (NSString *)electric;

- (NSString *)realTimePower;
//  用电参数调用接口(4.0位)
- (NSString *)realTimePowerr;
//  用电参数调用接口(4.0位，不带点)
- (NSString *)realTimePowwerr;
//  用电参数调用接口(4.0位)
- (NSString *)realTimePowwerrNo;

//  用电参数调用接口(4.0位 不带点)
- (NSString *)realTimePowerrNo;
//  用电参数调用接口(4.0位，不带点)
- (NSString *)realTimePowwwerrNo;
// GPRS电表（没有小数点）
- (NSString *)powwerrrrNo;

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
