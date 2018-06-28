//
//  BaseViewController.m
//  UFA
//
//  Created by YangLin on 2017/7/1.
//  Copyright © 2017年 UFA. All rights reserved.
//

#import "BaseViewController.h"

//#import "LoginViewController.h"
@interface BaseViewController ()
//{
//    UIImage *barImage;
//    BOOL clipsToBounds;
//}
@end

@implementation BaseViewController

#pragma mark - 生命周期

- (void)awakeFromNib
{
    [super awakeFromNib];
//    [UIColor wr_setDefaultNavBarTintColor:[UIColor whiteColor]];
     //    self.view.backgroundColor = [UIColor whiteColor];
}

//- (id)init
//{
//    self = [super init];
//    if (self) {
//        
//        self.hidesBottomBarWhenPushed = YES;
//        self.view.backgroundColor = [UIColor whiteColor];
//        
//        if (!self.navigationBarColor) {
//            self.navigationBarColor = kDefualtColor;
//        }
//    }
//    return self;
//}

//- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//
//    if (self) {
////        self.hidesBottomBarWhenPushed = YES;
//    }
//
//    return self;
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kBackBackroundColor;
    

    
//    [self wr_setStatusBarStyle:UIStatusBarStyleLightContent];
//    [self wr_setNavBarBarTintColor:kDefualtColor];
//    [self wr_setNavBarBackgroundAlpha:1];
//    [self wr_setNavBarShadowImageHidden:NO];
//    [self wr_setNavBarTitleColor:[UIColor whiteColor]];
    
    // Do any additional setup after loading the view.
}

//- (void)languageChange{
//
//    self.title = Localize(self.title);
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - 私有方法



- (void)toLogin
{
    [self toLogin:NO];
}

- (void)toLogin:(BOOL)toPrePage
{
//    LoginViewController *login = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
//    login.toPrePage = toPrePage;
//    [self.navigationController pushViewController:login animated:YES];
}


- (UIView *)frontView
{
    if (!_frontView) {
        _frontView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        [_frontView setBackgroundColor:[UIColor whiteColor]];
    }
    
    return _frontView;
}

@end
