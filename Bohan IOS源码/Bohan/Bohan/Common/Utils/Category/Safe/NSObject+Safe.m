//
//  NSObject+Safe.m
//  UFA
//
//  Created by YangLin on 2018/1/29.
//  Copyright © 2018年 UFA. All rights reserved.
//

#import "NSObject+Safe.h"
#import <objc/runtime.h>
@implementation NSObject (Safe)

//
//+ (void)replaceMethod:(SEL)methodSelector newMethod:(SEL)newMethodSelector classString:(NSString *)classString
//{
//    // 获取替换前的类方法
//    Method method = class_getInstanceMethod(NSClassFromString(classString), methodSelector);
//
//    // 获取替换后的类方法
//    Method newMethod = class_getInstanceMethod([self class], newMethodSelector);
//
//    // 然后交换类方法，交换两个方法的IMP指针，(IMP代表了方法的具体的实现）
//    method_exchangeImplementations(newMethod, method);
//}
//
//
//
//+ (void)SwizzlingMethod:(NSString *)systemMethodString systemClassString:(NSString *)systemClassString toSafeMethodString:(NSString *)safeMethodString targetClassString:(NSString *)targetClassString{
//    //获取系统方法IMP
//    Method sysMethod = class_getInstanceMethod(NSClassFromString(systemClassString), NSSelectorFromString(systemMethodString));
//    //自定义方法的IMP
//    Method safeMethod = class_getInstanceMethod(NSClassFromString(targetClassString), NSSelectorFromString(safeMethodString));
//    //IMP相互交换，方法的实现也就互相交换了
//    method_exchangeImplementations(safeMethod,sysMethod);
//}


- (void)swizzleMethod:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector{
    Class class = [self class];
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod = class_addMethod(class,
                                        originalSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@end
