//
//  NSString+HeartDecode.m
//  Bohan
//
//  Created by Yang Lin on 2018/1/15.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import "NSString+HeartDecode.h"
#import "DebuggingANDPublishing.pch"
@implementation NSString (HeartDecode)

- (NSString *)status
{
    NSString *statu = @"";
    if (self.length >=10) {
        statu = [self substringWithRange:NSMakeRange(2, 2)];
    }
    
    return statu;
}

- (BOOL)isOn
{
    BOOL on = NO;
    
    if (self.length >=10) {
        
        NSString *status = [self status];
        
        if ([status integerValue] == 5 || [status integerValue] == 6) {
            on = NO;
        }else
        {
            on = YES;
        }
    }
    
    return on;
}

- (NSString *)power
{
    NSString *string = @"0.00W";
    if (self.length >=10) {
        string = [self substringFromIndex:self.length - 6];
        string = [NSString stringWithFormat:@"%.2fW",[string integerValue]/100.0];
    }
    
    return string;
    
}



- (NSString *)statusString
{
    NSString *string = @"";
    switch ([self integerValue]) {
        case 1:
            string = Localize(@"正在用电(智能断电开)");
            break;
        case 2:
            string = Localize(@"设备马上断电");
            break;
        case 3:
            string = Localize(@"正在用电(智能断电关)");
            break;
        case 4:
            string = Localize(@"设备未使用");
            break;
        case 5:
            string = Localize(@"设备已断电");
            break;
        case 6:
            string = Localize(@"设备已断电(智能断电开)");
            break;
        case 7:
            string = Localize(@"设备未使用");
            break;
        default:
            
            break;
    }
    return string;
}

#pragma mark -用电参数解析方法

- (NSString *)voltage
{
    
    NSString * string = @"";
    if (self.length >= 30) {
        
        string = [self substringWithRange:NSMakeRange(24, 6)];
        string = [NSString stringWithFormat:@"%.3f",[string integerValue]/1000.0];
    }
    
    return string;
}


- (NSString *)electric
{
    NSString * string = @"";
    if (self.length >= 36) {
        
        string = [self substringWithRange:NSMakeRange(30, 6)];
        string = [NSString stringWithFormat:@"%.3f",[string integerValue]/1000.0];
    }
    
    return string;
}

- (NSString *)realTimePower
{
    NSString * string = @"";
    if (self.length >= 42) {
        
        string = [self substringWithRange:NSMakeRange(36, 6)];
        string = [NSString stringWithFormat:@"%.2f",[string integerValue]/100.0];
    }
    
    return string;
}

- (NSString *)realTimePowerFactor
{
    NSString * string = @"";
    if (self.length >= 46) {
        
        string = [self substringWithRange:NSMakeRange(42, 4)];
        string = [NSString stringWithFormat:@"%.3f",[string integerValue]/1000.0];
    }
    
    return string;
}

- (NSString *)elcAmount
{
    NSString * string = @"";
    if (self.length >= 54) {
        
        string = [self substringWithRange:NSMakeRange(46, 8)];
        string = [NSString stringWithFormat:@"%.2f",[string integerValue]/100.0];
    }
    
    return string;
}

- (NSString *)carbon
{
    NSString * string = @"";
    if (self.length >= 62) {
        
        string = [self substringWithRange:NSMakeRange(54, 8)];
        string = [NSString stringWithFormat:@"%.2f",[string integerValue]/100.0];
    }
    
    return string;
}


- (NSString *)money
{
    NSString * string = @"";
    if (self.length >= 72) {
        
        string = [self substringWithRange:NSMakeRange(62, 10)];
        string = [NSString stringWithFormat:@"%.2f",[string integerValue]/100.0];
    }
    
    return string;
}


- (NSString *)time
{
    NSMutableString * string = [@"" mutableCopy];
    if (self.length >= 86) {
        
        string = [[self substringWithRange:NSMakeRange(72, 14)] mutableCopy];
        [string insertString:@"-" atIndex:2];
        [string insertString:@"-" atIndex:5];
        [string insertString:@" " atIndex:8];
        [string replaceCharactersInRange:NSMakeRange(9, 2) withString:@" "];
        [string insertString:@":" atIndex:12];
        [string insertString:@":" atIndex:15];

    }
    
    return string;
}

- (NSString *)week
{
    NSString * string = @"";
    if (self.length >= 86) {
        
        string = [self substringWithRange:NSMakeRange(72, 14)];
        
        string = [string substringWithRange:NSMakeRange(6, 2)];
        
        switch ([string integerValue]) {
            case 0:
//                string = Localize(@"星期一");
                break;
            case 1:
                string = Localize(@"星期一");
                break;
            case 2:
                string = Localize(@"星期二");
                break;
            case 3:
                string = Localize(@"星期三");
                break;
            case 4:
                string = Localize(@"星期四");
                break;
            case 5:
                string = Localize(@"星期五");
                break;
            case 6:
                string = Localize(@"星期六");
                break;
            case 7:
                string = Localize(@"星期日");
                break;
            default:
                break;
        }
    }
    
    return string;
}

- (NSString *)temperature
{
    NSString * string = @"";
    if (self.length >= 90) {
        
        string = [self substringWithRange:NSMakeRange(86, 4)];
        string = [NSString stringWithFormat:@"%.2f",[string integerValue]/100.0];
    }
    
    return string;

}

- (NSString *)loopWeekByHex
{
    
    NSString *string = [Utils getBinaryByHex:self];
    
    if ([[string substringFromIndex:1] isEqualToString:@"0000000"]) {
        return Localize(@"未设置星期");
    }
    
    if (string.length != 8) {
        
        NSAssert(string.length == 8 , @"进制转换错误");
    }
    NSMutableString *week = [NSMutableString stringWithString:Localize(@"周")];
    
    NSArray *weeks = @[Localize(@"一"), Localize(@"二"), Localize(@"三"), Localize(@"四"), Localize(@"五"), Localize(@"六")];
    for (int i = 0; i<string.length-2; i++) {
        
        NSString *bit = [string substringWithRange:NSMakeRange(string.length-i-2, 1)];
        if ([bit isEqualToString:@"1"]) {
            [week appendString:[NSString stringWithFormat:@" %@",weeks[i]]];
        }
    }
    
    if ([string hasSuffix:@"1"]) {
        [week appendString:[NSString stringWithFormat:@" %@",Localize(@"Sunday")]];
    }
    
    if ([week hasPrefix:@" "]) {
        week = [week substringFromIndex:1];
    }
    return week;
    
}

@end
