//
//  AppDelegate+Configure.m
//  UFA
//
//  Created by YangLin on 2017/7/7.
//  Copyright © 2017年 UFA. All rights reserved.
//

#import "AppDelegate+Configure.h"
//#import "WRNavigationBar.h"
@implementation AppDelegate (Configure)


- (void)appearance
{
//    [UIColor wr_setDefaultNavBarBarTintColor:kDefualtColor];
//    [UIColor wr_setDefaultNavBarTitleColor:[UIColor whiteColor]];
//    [UIColor wr_setDefaultStatusBarStyle:UIStatusBarStyleLightContent];

//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:kDefualtColor];

//    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
//                                                         forBarMetrics:UIBarMetricsDefault];
    
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage createImageWithColor:kDefualtColor] forBarMetrics:UIBarMetricsDefault];
    
    
    
//    [[UINavigationBar appearance] setBackIndicatorImage:[[UIImage imageNamed:@"ic_register_back"] imageWithRenderingMode:UIImageRenderingModeAutomatic]];
    
//    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[[UIImage imageNamed:@"ic_register_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:EFont(18)}];
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    
    UITabBarController *tab = (UITabBarController *)self.window.rootViewController;

    
    if ([tab isKindOfClass:[UITabBarController class]]) {
        
        for (UITabBarItem *barItem in tab.tabBar.items) {
            
            //使用原图
            barItem.image = [barItem.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            barItem.selectedImage = [barItem.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            
            //设置字体颜色
            [barItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor getColor:@"333333"]} forState:UIControlStateNormal];
            [barItem setTitleTextAttributes:@{NSForegroundColorAttributeName:kDefualtColor} forState:UIControlStateSelected];
        }
    }
    
    
}
@end
