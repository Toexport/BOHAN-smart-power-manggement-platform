//
//  AppDelegate.m
//  Bohan
//
//  Created by Yang Lin on 2017/12/24.
//  Copyright © 2017年 Bohan. All rights reserved.
//

#import "AppDelegate.h"
#import "EquipmentViewController.h"
#import "ManagementViewController.h"
#import "ElectricityViewController.h"
#import "CenterViewController.h"
#import "LoginViewController.h"
#import "DetailsViewController.h"
#import "IQKeyboardManager.h"
#import "WebSocket.h"
#import "WXApi.h"
#import "DebuggingANDPublishing.pch"

#import <UMPush/UMessage.h>
#import <UMCommon/UMCommon.h>           // 公共组件是所有友盟产品的基础组件，必选
#import <UMPush/UMessage.h>             // Push组件
#import <UserNotifications/UserNotifications.h>  // Push组件必须的系统库

@interface AppDelegate ()<UNUserNotificationCenterDelegate>
@property (nonatomic, strong) NSDictionary *userInfo;

@end

@implementation AppDelegate
static NSString *UMessageAppKey  = @"5baee85eb465f5c3b200013e";
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self initUM:launchOptions];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self initSocket];
    [self keyBoardManage];
    [self createTabBar];
    [self onCheckVersion];
    //    [self ThreeTouch];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutNotification:) name:LOGOUTNOTIFICATION object:nil];
    [WXApi registerApp:@"wx76320274b0800e51"];
    
    return YES;
}

//-(void)ThreeTouch {
//    CGFloat currentDeviceVersionFloat = [[[UIDevice currentDevice] systemVersion] floatValue];
//    //判断版本号，3D Touch是从iOS9.0后开始使用
//    if (currentDeviceVersionFloat >= 9.0) {
//        UIApplicationShortcutIcon *iconFitness = [UIApplicationShortcutIcon iconWithTemplateImageName:@"qrcode_scan"];
//        //菜单文字
//        UIMutableApplicationShortcutItem *itemFitness = [[UIMutableApplicationShortcutItem alloc] initWithType:@"1" localizedTitle: Localize(@"扫描")];
//        //绑定信息到指定菜单
//        itemFitness.icon = iconFitness;
//
//        // 菜单图标
//        UIApplicationShortcutIcon *iconRun = [UIApplicationShortcutIcon iconWithTemplateImageName:@"manage_device_share"];
//        //菜单文字
//        UIMutableApplicationShortcutItem *itemRun = [[UIMutableApplicationShortcutItem alloc] initWithType:@"2" localizedTitle:@"分享"];
//        //绑定信息到指定菜单
//        itemRun.icon = iconRun;
//        //绑定到App icon
////        UIApplication.shortcutItems = @[itemFitness,itemRun];
//    }
//
//}

//- (void)application:(UIApplication *)application performActionForShortcutItem:(nonnull UIApplicationShortcutItem *)shortcutItem completionHandler:(nonnull void (^)(BOOL))completionHandler{
//    if ([shortcutItem.type isEqualToString:@"1"]) {
//        //如果有导航栏参考下面注释部分
//        UINavigationController *myNavi = self.window.rootViewController.childViewControllers[0];
//        //        _tabBar.selectedIndex = 0;
//        UIViewController * picker1 = [[UIViewController alloc]init];//进入窗口的初始化
//        //利用NSUserDefaults 的标识，来防止重复初始化VC
//        //    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"3d"]) {
//        //       [myNavi popViewControllerAnimated:NO];
//        //      [myNavi pushViewController:_picker1 animated:YES ];
//        //    }else{
//        [myNavi pushViewController:picker1 animated:YES ];
//
//        //    }
//
//    }
//    if ([shortcutItem.type isEqualToString:@"2"]) {
//        / /   UINavigationController *myNavi = self.window.rootViewController.childViewControllers[1];
//        //    _tabBar.selectedIndex = 1;
//        UIViewController *vc = [[UIViewController1 alloc]init];//进入窗口的初始化
//        //     if ([[NSUserDefaults standardUserDefaults]boolForKey:@"3d1"]) {
//        //       [myNavi popViewControllerAnimated:NO];
//        //      [myNavi pushViewController:_LJHVC animated:YES ];
//        //    }else{
//
//        [myNavi pushViewController:vc animated:YES ];

- (void)keyBoardManage
{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    
    [manager setEnable:YES];
    [manager setEnableAutoToolbar:NO];
    manager.shouldResignOnTouchOutside = YES;
    
}

- (void)initSocket {
    WebSocket *socketConnect = [WebSocket socketManager];
    [socketConnect.serverSockt webSocketOpen];
}

- (void)initUM:(NSDictionary *)launchOptions {
    [UMConfigure setLogEnabled:YES];
    [UMConfigure initWithAppkey:UMessageAppKey channel:nil];
    
    UMessageRegisterEntity * entity = [[UMessageRegisterEntity alloc] init];
    [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    entity.types = UMessageAuthorizationOptionBadge|UMessageAuthorizationOptionSound;
    [UMessage registerForRemoteNotificationsWithLaunchOptions:launchOptions Entity:entity completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            ZPLog(@"推送注册成功");
//            push_umessage_debug5
            
        } else {
            NSLog(@"推送注册失败");
        }
    }];
}




- (void)createTabBar
{
    if (ISLOGIN) {
        EquipmentViewController *equipment = [[EquipmentViewController alloc] init];
        
        ManagementViewController *management = [[ManagementViewController alloc] init];
        
        ElectricityViewController *electricity = [[ElectricityViewController alloc] init];
        
        DetailsViewController * Details = [[DetailsViewController alloc]init];
        
        CenterViewController *center = [[CenterViewController alloc] init];
        
        UINavigationController *equipmentNav = [[UINavigationController alloc] initWithRootViewController:equipment];
        
        UINavigationController *managementNav = [[UINavigationController alloc] initWithRootViewController:management];
        
        UINavigationController *electricityNav = [[UINavigationController alloc] initWithRootViewController:electricity];
        
        UINavigationController *PrepaidNav = [[UINavigationController alloc] initWithRootViewController:Details];
        
        UINavigationController *centerNav = [[UINavigationController alloc] initWithRootViewController:center];
        UITabBarController *tabBar = [[UITabBarController alloc] init];
        
        tabBar.viewControllers = @[equipmentNav, managementNav,electricityNav,PrepaidNav,centerNav];
        
        NSArray *titles = @[Localize(@"设备列表"), Localize(@"设备管理"),Localize(@"所有用电"),Localize(@"付费充电"),Localize(@"个人中心")];
        
        NSArray *selectedImages = @[@"mainpage_main", @"mainpage_bang", @"mainpage_data",@"Pay_pay_me",@"mainpage_me"];
        
        NSArray *images = @[@"mainpage_main_off", @"mainpage_bang_off", @"mainpage_data_off",@"Pay_pay_off",@"mainpage_me_off"];
        
        for (int i = 0; i<[tabBar.viewControllers count]; i++) {
            ((UINavigationController *)tabBar.viewControllers[i]).tabBarItem = [[UITabBarItem alloc] initWithTitle:titles[i] image:[[UIImage imageNamed:images[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[UIImage imageNamed:selectedImages[i]]];
        }
        
        self.window.rootViewController = tabBar;
        
    }else {
        LoginViewController *login = [[LoginViewController alloc] init];
        UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:login];
        
        self.window.rootViewController = loginNav;
    }
    self.window.rootViewController.view.backgroundColor = [UIColor whiteColor];
    
    [[UINavigationBar appearance] setBarTintColor:kDefualtColor];
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[UIColor whiteColor], nil] forKeys:[NSArray arrayWithObjects:NSForegroundColorAttributeName, nil]]];
    [[UITabBar appearance] setTintColor:kDefualtColor];
    //    UIViewController.hidesBottomBarWhenPushed = YES;
    //    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0,0) forBarMetrics:UIBarMetricsDefault];
    //    [[UIBarButtonItem appearance]setBackButtonBackgroundImage:[UIImage imageNamed:@"whiteBack"] forState:UIControlStateNormal barMetrics:UIBarMetricsCompact];
    //    [[UIBarButtonItem appearance]setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -64) forBarMetrics:UIBarMetricsDefault];
    //    [viewController setBackButton];
}

//- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    if (self.childViewControllers.count > 0) {//非根控制器
//        viewController.hidesBottomBarWhenPushed = YES;
//        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
//        [viewController setBackButton];
//    }
//
//    [super pushViewController:viewController animated:animated];
//
//    //根据栈顶控制器 设置导航条title
//    //拿到tabbar控制器
//    //    UITabBarController *tabbarVC = (UITabBarController *)self.tabBarController;
//    //    viewController.navigationItem.title = tabbarVC.selectedViewController.tabBarItem.title;
//}
//
//#pragma mark - 手势代理
////手势是否应该被识别
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
//    if (self.childViewControllers.count > 1) {
//        return YES;
//    }else{
//        return NO;
//    }
//}

/**
 *  @brief  检测版本更新
 */
-(void)onCheckVersion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString * URL = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",BohanID];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:URL]];
        [request setHTTPMethod:@"POST"];
        [request setTimeoutInterval:15];
        
        NSHTTPURLResponse *urlResponse;
        NSError *error;
        
        NSData *recervedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (recervedData) {
                NSDictionary *results = [NSJSONSerialization JSONObjectWithData:recervedData options:NSJSONReadingAllowFragments error:nil];
                NSArray *infoArray = [results objectForKey:@"results"];
                if ([infoArray count]) {
                    NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
                    NSString *lastVersion = [releaseInfo objectForKey:@"version"];
                    
                    if ([CURRENTSHORTVERSION compare:lastVersion options:NSNumericSearch] == NSOrderedAscending) {
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:Localize(@"新版本提醒") message:Localize(@"有新的版本更新，是否前往更新？") preferredStyle:UIAlertControllerStyleAlert];
                        [alert addAction:[UIAlertAction actionWithTitle:Localize(@"马上更新") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            NSString *iTunesString = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@", BohanID];
                            NSURL *iTunesURL = [NSURL URLWithString:iTunesString];
                            [[UIApplication sharedApplication] openURL:iTunesURL];
                            
                        }]];
                        [alert addAction:[UIAlertAction actionWithTitle:Localize(@"稍后更新") style:UIAlertActionStyleCancel handler:nil]];
                        [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
                        
                    }
                }
            }
            
        });
        
    });
    
}

- (void)logoutNotification:(NSNotification*)notify
{
    [[WebSocket socketManager].serverSockt webSocketClose];
    [UserInfoManager updateLoginState:NO];
    LoginViewController *login = [[LoginViewController alloc] init];
    UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:login];
    
    if (notify.object) {
        
        [HintView showHint:notify.userInfo[@"message"]];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            //            [self.window.rootViewController.view removeFromSuperview];
            self.window.rootViewController = loginNav;
        });
        
    }else
    {
        
        //        [self.window.rootViewController.view removeFromSuperview];
        self.window.rootViewController = loginNav;
    }
    
}

//- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    if (self.childViewControllers.count > 0) {//非根控制器
//        viewController.hidesBottomBarWhenPushed = YES;
//        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
//        [viewController setBackButton];
//    }
//
//    [super pushViewController:viewController animated:animated];
//
//    //根据栈顶控制器 设置导航条title
//    //拿到tabbar控制器
//    //    UITabBarController *tabbarVC = (UITabBarController *)self.tabBarController;
//    //    viewController.navigationItem.title = tabbarVC.selectedViewController.tabBarItem.title;
//}

// 处理其他app调起的情况
-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    // 交给微信处理，如果它能处理 会回调delegate的相关方法如onResp:
    return [WXApi handleOpenURL:url delegate:self];
}

#pragma mark WXApiDelegate
-(void) onResp:(BaseResp*)resp{
    NSString *str = [NSString stringWithFormat:@"%d",resp.errCode];
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"微信返回结果" message:str delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
    [alertview show];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    ZPLog(@"%@",[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                  stringByReplacingOccurrencesOfString: @">" withString: @""]
                 stringByReplacingOccurrencesOfString: @" " withString: @""]);
}

//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        //关闭U-Push自带的弹出框
        [UMessage setAutoAlert:NO];
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
    }else{
        //应用处于前台时的本地推送接受
    }
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
    }else{
        //应用处于后台时的本地推送接受
        
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [UMessage didReceiveRemoteNotification:userInfo];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
