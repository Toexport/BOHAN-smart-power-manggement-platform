//
//  NSObject+Safe.h
//  UFA
//
//  Created by YangLin on 2018/1/29.
//  Copyright © 2018年 UFA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Safe)

//+ (void)SwizzlingMethod:(NSString *)systemMethodString systemClassString:(NSString *)systemClassString toSafeMethodString:(NSString *)safeMethodString targetClassString:(NSString *)targetClassString;
//
//+ (void)replaceMethod:(SEL)methodSelector newMethod:(SEL)newMethodSelector classString:(NSString *)classString;

- (void)swizzleMethod:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector;
@end
