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
#import "IQKeyboardManager.h"
#import "WebSocket.h"
#import "DebuggingANDPublishing.pch"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

//    [UserInfoManager deletAccount];

    [self initSocket];
    [self keyBoardManage];
    [self createTabBar];
    [self onCheckVersion];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutNotification:) name:LOGOUTNOTIFICATION object:nil];
    
    return YES;
}

- (void)keyBoardManage
{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    
    [manager setEnable:YES];
    [manager setEnableAutoToolbar:NO];
    manager.shouldResignOnTouchOutside = YES;

}

- (void)initSocket
{
    WebSocket *socketConnect = [WebSocket socketManager];
    [socketConnect.serverSockt webSocketOpen];
}

- (void)createTabBar
{
    if (ISLOGIN) {
        
//        [self SRWebSocketOpen];//打开soket
        
//        NSString *data = [NSString stringWithFormat:@"3A10000002%@0D",@"18229877048"];
//        NSString *data = @"E768160905065800080000F20D";
//
//        [[SocketRocketUtility instance] sendData:data];//打开soket
        EquipmentViewController *equipment = [[EquipmentViewController alloc] init];
        ManagementViewController *management = [[ManagementViewController alloc] init];
//        [management.view setBackgroundColor:kBackBackroundColor];
        
        ElectricityViewController *electricity = [[ElectricityViewController alloc] init];
        //        [electricity.view setBackgroundColor:kBackBackroundColor];
        CenterViewController *center = [[CenterViewController alloc] init];
        UINavigationController *equipmentNav = [[UINavigationController alloc] initWithRootViewController:equipment];
        UINavigationController *managementNav = [[UINavigationController alloc] initWithRootViewController:management];
        UINavigationController *electricityNav = [[UINavigationController alloc] initWithRootViewController:electricity];
//        UINavigationController *centerNav = [[UINavigationController alloc] initWithRootViewController:center];
        UINavigationController *PrepaidNav = [[UINavigationController alloc] initWithRootViewController:center];
        UITabBarController *tabBar = [[UITabBarController alloc] init];
        tabBar.viewControllers = @[equipmentNav, managementNav,electricityNav,PrepaidNav];
        
        NSArray *titles = @[Localize(@"设备列表"), Localize(@"设备管理"),Localize(@"所有用电"),Localize(@"个人中心")];
        NSArray *selectedImages = @[@"mainpage_main", @"mainpage_bang", @"mainpage_data",@"mainpage_me"];
        NSArray *images = @[@"mainpage_main_off", @"mainpage_bang_off", @"mainpage_data_off",@"mainpage_me_off"];
        
        for (int i = 0; i<[tabBar.viewControllers count]; i++) {
            ((UINavigationController *)tabBar.viewControllers[i]).tabBarItem = [[UITabBarItem alloc] initWithTitle:titles[i] image:[[UIImage imageNamed:images[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[UIImage imageNamed:selectedImages[i]]];
        }
        
        self.window.rootViewController = tabBar;

    }else{
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
}


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
