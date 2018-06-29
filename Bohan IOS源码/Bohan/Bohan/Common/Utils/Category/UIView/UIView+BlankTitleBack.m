//
//  UIView+BlankTitleBack.m
//  UFA
//
//  Created by YangLin on 2017/10/19.
//  Copyright © 2017年 UFA. All rights reserved.
//

#import "UIView+BlankTitleBack.h"
#import <objc/runtime.h>
//#import "JRSwizzle.h"
#import "DebuggingANDPublishing.pch"
@implementation UIView (BlankTitleBack)


+ (void)load
{
    if (@available(iOS 11, *)) {
        
//        [NSClassFromString(@"_UIBackButtonContainerView") jr_swizzleMethod:@selector(addSubview:) withMethod:@selector(iOS11BackButtonNoTextTrick_addSubview:) error:nil];
        
        // 获取替换后的类方法
        Method newMethod = class_getClassMethod(NSClassFromString(@"_UIBackButtonContainerView"), @selector(addSubview:));
        // 获取替换前的类方法
        Method method = class_getClassMethod(NSClassFromString(@"_UIBackButtonContainerView"), @selector(iOS11BackButtonNoTextTrick_addSubview:));
        
        // 然后交换类方法，交换两个方法的IMP指针，(IMP代表了方法的具体的实现）
        method_exchangeImplementations(newMethod, method);
        
    }
}
- (void)iOS11BackButtonNoTextTrick_addSubview:(UIView *)view
{
    view.alpha = 0;
    if ([view isKindOfClass:[UIButton class]]) {
        UIButton *button = (id)view;
        [button setTitle:@" " forState:UIControlStateNormal];
    }
    [self iOS11BackButtonNoTextTrick_addSubview:view];
    
}
@end
