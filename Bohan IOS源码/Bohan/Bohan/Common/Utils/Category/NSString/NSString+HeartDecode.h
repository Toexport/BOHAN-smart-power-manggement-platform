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


- (NSString *)power;



- (NSString *)statusString;




//用电参数解析
- (NSString *)voltage;

- (NSString *)electric;

- (NSString *)realTimePower;

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
