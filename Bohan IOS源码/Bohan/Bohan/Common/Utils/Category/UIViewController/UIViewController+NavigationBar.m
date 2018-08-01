//
//  UIViewController+NavigationBar.m
//  UFA
//
//  Created by YangLin on 2017/7/10.
//  Copyright © 2017年 UFA. All rights reserved.
//

#import "UIViewController+NavigationBar.h"

@implementation UIViewController (NavigationBar)


- (void)rightBarTitle:(NSString *)title action:(SEL)action
{
    
    [self rightBarTitle:title color:kDefualtColor action:action];
}

- (void)rightBarTitle:(NSString *)title color:(UIColor *)color action:(SEL)action
{
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:action];
    [buttonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:color, NSFontAttributeName:Font(15)} forState:UIControlStateNormal];
    [buttonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:RGBColor(255, 255, 255, 0.4), NSFontAttributeName:Font(16)} forState:UIControlStateDisabled];


    self.navigationItem.rightBarButtonItem = buttonItem;
}


- (void)rightBarImage:(NSString *)image action:(SEL)action
{
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:image] style:UIBarButtonItemStylePlain target:self action:action];
    self.navigationItem.rightBarButtonItem = buttonItem;
}

- (void)leftBarImage:(NSString *)image action:(SEL)action
{
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:action];
    self.navigationItem.leftBarButtonItem = buttonItem;
}

@end
