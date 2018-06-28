//
//  NSString+Reverse.m
//  UFA
//
//  Created by YangLin on 2017/7/22.
//  Copyright © 2017年 UFA. All rights reserved.
//

#import "NSString+Reverse.h"

@implementation NSString (Reverse)

///反转字符串
- (NSString *)reverse
{
    //length 计算字符串的长度
    NSInteger length = self.length;
    
    ///取出一个字符串中的每一个字符
    unichar *buffer = calloc(length, sizeof(unichar));
    
    ///翻转字符串的长度
    [self getCharacters:buffer range:NSMakeRange(0, length)];
    
    for (NSInteger i = 0; i<length/2; i++)
    {
        unichar temp = buffer[i];
        buffer[i] = buffer[length-1-i];
        buffer[length-1-i] = temp;
    }
    
    ///得到翻转之后的字符串
    NSString *result = [NSString stringWithCharacters:buffer length:length];
    
    //释放对象
    free(buffer);
    return result;
}

//类方法
+ (NSString *)reverseString:(NSString *)string
{
    //直接调用reverse的对象方法的返回值就OK
    return [string reverse];
}

@end
