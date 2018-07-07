//
//  NSDictionary+Safe.m
//  UFA
//
//  Created by YangLin on 2018/1/29.
//  Copyright © 2018年 UFA. All rights reserved.
//

#import "NSDictionary+Safe.h"
#import <objc/runtime.h>
#import "DebuggingANDPublishing.pch"
@implementation NSDictionary (Safe)

+ (void)load{
    static dispatch_once_t onceDispatch;
    dispatch_once(&onceDispatch, ^{
        


        /** 不可变字典 */
        [objc_getClass("__NSDictionaryI") swizzleMethod:@selector(initWithObjects:forKeys:count:) swizzledSelector:@selector(initWithSafeObjects:forKeys:count:)];
//        [objc_getClass("__NSDictionaryI") swizzleMethod:@selector(initWithObjects:forKeys:) swizzledSelector:@selector(initWithSafeObjects:forKeys:)];
        [objc_getClass("__NSDictionaryI") swizzleMethod:@selector(setObject:forKey:) swizzledSelector:@selector(safe_setObject:forKey:)];
        [objc_getClass("__NSDictionaryI") swizzleMethod:@selector(setObject:forKey:) swizzledSelector:@selector(safe_callError)];

        //空
        
        [objc_getClass("__NSDictionary0") swizzleMethod:@selector(initWithObjects:forKeys:count:) swizzledSelector:@selector(initWithSafeObjects:forKeys:count:)];
//        [objc_getClass("__NSDictionary0") swizzleMethod:@selector(initWithObjects:forKeys:) swizzledSelector:@selector(initWithSafeObjects:forKeys:)];
        [objc_getClass("__NSDictionary0") swizzleMethod:@selector(setObject:forKey:) swizzledSelector:@selector(safe_setObject:forKey:)];
        [objc_getClass("__NSDictionary0") swizzleMethod:@selector(setObject:forKey:) swizzledSelector:@selector(safe_callError)];

        //非空
        /** 可变数组 */

        [objc_getClass("__NSDictionaryM") swizzleMethod:@selector(initWithObjects:forKeys:count:) swizzledSelector:@selector(initWithSafeObjects:forKeys:count:)];
//        [objc_getClass("__NSDictionaryM") swizzleMethod:@selector(initWithObjects:forKeys:) swizzledSelector:@selector(initWithSafeObjects:forKeys:)];
        [objc_getClass("__NSDictionaryM") swizzleMethod:@selector(setObject:forKey:) swizzledSelector:@selector(safe_setObject:forKey:)];
        [objc_getClass("__NSDictionaryM") swizzleMethod:@selector(setObject:forKey:) swizzledSelector:@selector(safe_callError)];

        /** 只有一个元素 */
        //数组中只有一个元素
        [objc_getClass("__NSSingleEntryDictionaryI") swizzleMethod:@selector(initWithObjects:forKeys:count:) swizzledSelector:@selector(initWithSafeObjects:forKeys:count:)];
//        [objc_getClass("__NSSingleEntryDictionaryI") swizzleMethod:@selector(initWithObjects:forKeys:) swizzledSelector:@selector(initWithSafeObjects:forKeys:)];
        [objc_getClass("__NSSingleEntryDictionaryI") swizzleMethod:@selector(setObject:forKey:) swizzledSelector:@selector(safe_callError)];

        /** 类方法创建的数组,插入空时,下面这两个会崩溃 */
        [objc_getClass("__NSPlaceholderDictionary") swizzleMethod:@selector(initWithObjects:forKeys:count:) swizzledSelector:@selector(initWithSafeObjects:forKeys:count:)];
        [objc_getClass("__NSPlaceholderDictionary") swizzleMethod:@selector(setObject:forKey:) swizzledSelector:@selector(safe_callError)];


    });
}
-(instancetype)initWithSafeObjects:(id *)objects forKeys:(id<NSCopying> *)keys count:(NSUInteger)count {
    NSUInteger rightCount = 0;
    for (int i = 0; i < count; i++) {
        if (!(keys[i] && objects[i])) {
            DBLog(@"字典初始化时，key或value为nil,keys[%d]=%@,objects[%d]=%@",i,keys[i],i,objects[i]);
            break;
        }else{
            rightCount++;
        }
    }
    self = [self initWithSafeObjects:objects forKeys:keys count:rightCount];
    return self;
}

- (instancetype)initWithSafeObjects:(NSArray *)objects forKeys:(NSArray<id<NSCopying>> *)keys
{
    NSUInteger rightCount = 0;
    for (id key in keys) {
        if (!(key && [self objectForKey:key])) {
            
            DBLog(@"字典初始化时，key或value为nil,key=%@,object=%@",key,[self objectForKey:key]);
            break;
        }else{
            rightCount++;
        }

    }
    self = [self initWithSafeObjects:objects forKeys:keys];
    return self;
}

- (id)safe_objectForKey:(id)key
{
    if (!key) {
        DBLog(@"通过空的key取object,dictionary=：%@",self);
        return nil;
    }
    return [self safe_objectForKey:key];
}

- (id)safe_valueForKey:(id)key
{
    if (!key) {
        DBLog(@"通过空的key取value,dictionary=：%@",self);
        return nil;
    }
    return [self safe_valueForKey:key];
}



- (void)safe_removeObjectForKey:(id)key {
    if (!key) {
        DBLog(@"remove不存在的key,dictionary=：%@",self);
        return;
    }
    [self safe_removeObjectForKey:key];
}
- (void)safe_setObject:(id)obj forKey:(id <NSCopying>)key {
    
    if (!obj) {
        DBLog(@"设置空的value值,dictionary=：%@",self);
        return;
    }
    if (!key) {
        DBLog(@"设置空的key值，key为nil,dictionary=：%@",self);
        return;
    }
    [self safe_setObject:obj forKey:key];
}


- (void)safe_callError
{
    DBLog(@"字典错误调用，dictionary=：%@",self);
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    DBLog(@"字典错误调用，key%@未定义,dictionary=：%@",key,self);
}


@end
