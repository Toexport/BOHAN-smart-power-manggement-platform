//
//  BaseViewController.h
//  UFA
//
//  Created by YangLin on 2017/7/1.
//  Copyright © 2017年 UFA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+loading.h"
//#import "NetworkRequest.h"
//#import "UIViewController+NavigationBar.h"
//#import "WRNavigationBar.h"

@interface BaseViewController : UIViewController

@property (nonatomic, strong) UIView *frontView;

//
///**
// 设置透明导航栏
// */
//- (void)transparentBar;
//
//
///**
// 还原上个页面导航栏
// */
//- (void)backNavigationBar;
//
//
//
//@property (nonatomic,strong)UIColor *navigationBarColor;

/**
 跳转登录
 */
- (void)toLogin;

/**
 跳转登录

 @param toPrePage 是否登录后返回登录前的页面
 */
- (void)toLogin:(BOOL)toPrePage;

////切换语言
//- (void)languageChange;
@end
