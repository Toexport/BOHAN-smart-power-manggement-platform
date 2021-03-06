//
//  WifiConnectViewController.m
//  Bohan
//
//  Created by Yang Lin on 2018/1/9.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import "WifiConnectViewController.h"
#import "SliderView.h"
#import "WifiView.h"
#import "ESPSmartConnect.h"
#import "WebSocket.h"
#import "CommandModel.h"
#import <SAMKeychain/SAMKeychain.h>
#import "DebuggingANDPublishing.pch"
#import<SystemConfiguration/CaptiveNetwork.h>
@interface WifiConnectViewController ()<UIScrollViewDelegate> {
    NSUInteger currentIndex;
}
@property(nonatomic,strong)SliderView *sliderView;
@property (nonatomic, strong) UIScrollView *mainScroll;
@property (nonatomic, strong) WifiView *autoConV;
@property (nonatomic, strong) WifiView *mantConV;
@property (nonatomic, strong) ESPSmartConnect *espConnect;

@end

@implementation WifiConnectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //得到当前视图控制器中的所有控制器
    [self dismissViewControllerAnimated:YES completion:nil];
    if (@available(iOS 11.0, *)){
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.title = Localize(@"连接WiFi");
    [self.view addSubview:self.sliderView];
    [self.view addSubview:self.mainScroll];
    [self.mainScroll addSubview:self.autoConV];
    [self.mainScroll addSubview:self.mantConV];
    
    MyWeakSelf
    [self.mainScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(weakSelf.sliderView.mas_bottom);
    }];
    
    [_mainScroll setContentSize:CGSizeMake(2*ScreenWidth, self.mainScroll.frame.size.height)];
    [self.autoConV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(0);
        make.width.mas_equalTo(weakSelf.mainScroll.mas_width);
        make.height.mas_equalTo(@300);
    }];
    
    [self.mantConV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(self.autoConV.mas_right);
        make.width.mas_equalTo(weakSelf.mainScroll.mas_width);
        make.height.mas_equalTo(@300);
    }];
    
    self.autoConV.ssidTF.text = [self.espConnect fetchSsid];
    NSString * pwd = [SAMKeychain passwordForService:BUNDLEIDENTIFIER account:self.autoConV.ssidTF.text];
    if (pwd && pwd.length > 0) {
        self.autoConV.pwdTF.text = pwd;
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.espConnect connectCancel];
}

- (void)connectDeviceipAddress:(NSString *)ipAddress {
    WebSocket *socket = [WebSocket socketManager];
    CommandModel *model = [[CommandModel alloc] init];
    model.deviceNo = self.deviceNo;
    model.command = @"0001";
    [socket sendSingleDataWithModel:model resultBlock:^(id response, NSError *error) {
        ZPLog(@"--------%@",response);
    }];
}

- (void)showMessageWithType:(ESPConnectResultType)resultType {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
           [self.view stopLoading];
        });
            if (resultType == ESPConnectResultTypeSucceed) {
                [SAMKeychain setPassword:self.autoConV.pwdTF.text forService:BUNDLEIDENTIFIER account:self.autoConV.ssidTF.text];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [HintView showHint:Localize(@"WIFI连接成功！")];
                     [self.navigationController popToRootViewControllerAnimated:YES];
                });
            } else
                if(resultType != ESPConnectResultTypeCancel){
                //            if (resultType == ESPConnectResultTypePwdError)
                //        {
                //            [HintView showHint:@"WiFi和密码不匹配"];
                //
                //        }else if (resultType == ESPConnectResultTypeTimeout)
                //        {
                //            [HintView showHint:@"设备连接超时"];
                //
                //        }else if (resultType == ESPConnectResultTypeUnKnownError)
                //        {
                //            [HintView showHint:Localize(@"连接失败")];
                [self deviceStatus];
            }
    });
}
//查询设备是否已经连接
- (void)deviceStatus {
    WebSocket *socket = [WebSocket socketManager];
    CommandModel *model = [[CommandModel alloc] init];
    model.command = @"1001";
    model.content = USERNAME;
    MyWeakSelf
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view startLoading];
    });
    [socket sendMultiDataWithModel:model resultBlock:^(id response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
           [weakSelf.view stopLoading];
        });
        NSArray *status = [response componentsSeparatedByString:@","];
        for (NSString *content in status) {
            if ([content hasPrefix:weakSelf.deviceNo]) {
                [self.espConnect connectCancel];
                dispatch_async(dispatch_get_main_queue(), ^{
                     [HintView showHint:Localize(@"WIFI连接成功！")];
                });
                [self.navigationController popToRootViewControllerAnimated:YES];
                return;
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [HintView showHint:Localize(@"连接失败")];
        });
    }];
}

- (ESPSmartConnect *)espConnect {
    if (!_espConnect) {
        _espConnect = [[ESPSmartConnect alloc] init];
        MyWeakSelf
        self.espConnect.resultBlock = ^(ESPConnectResultType resultType, NSString *server, NSString *port) {
            [weakSelf showMessageWithType:resultType];
//            if (resultType == ESPConnectResultTypeSucceed && server && port && server.length>0 && port.length>0) {
//                [weakSelf connectDeviceipAddress:server];
//            }
        };
    }
    return _espConnect;
}

- (SliderView *)sliderView {
    if (!_sliderView) {
        _sliderView = [[SliderView alloc] initWithFrame:CGRectMake(0, kTopHeight, ScreenWidth, 45) datas:@[Localize(@"极速添加"), Localize(@"手动添加")]];
        [_sliderView setBackgroundColor:kBackBackroundColor];
        MyWeakSelf
        _sliderView.block = ^(NSUInteger index) {
            currentIndex = index;
            [weakSelf.mainScroll setContentOffset:CGPointMake(currentIndex *ScreenWidth, 0) animated:YES];
        };
    }
    return _sliderView;
}

- (UIScrollView *)mainScroll {
    if (!_mainScroll) {
        _mainScroll = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _mainScroll.pagingEnabled = YES;
        _mainScroll.delegate = self;
        _mainScroll.showsHorizontalScrollIndicator = NO;
    }
    return _mainScroll;
}


- (WifiView *)autoConV {
    if (!_autoConV) {
        _autoConV = [self createWifiView];
    }
    return _autoConV;
}

- (WifiView *)mantConV {
    if (!_mantConV) {
        _mantConV = [self createWifiView];
    }
    return _mantConV;
}

- (WifiView *)createWifiView {
    WifiView *view = [[[NSBundle mainBundle] loadNibNamed:@"WifiView" owner:nil options:nil] lastObject];
    MyWeakSelf
    view.addBock = ^(NSString *ssid, NSString *pwd) {
        if (ssid.length == 0 || pwd.length == 0) {
            [HintView showHint:@"请输入wifi账号"];
            return ;
        }else {
        // 设备配网
        [weakSelf.view startLoading];
            
        }
      dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
          [weakSelf.espConnect connectWithApSsid:ssid apPwd:pwd];
        });
    };
    return view;
}

//681609050268
#pragma mark -UIScrollView delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self.sliderView selectedWithIndex:scrollView.contentOffset.x /scrollView.bounds.size.width];
}

//+ (NSString *)ssid {
//     NSString *ssid = @"Not Found";
//    CFArrayRef myArray = CNCopySupportedInterfaces();
//    if (myArray != nil) {
//        CFDictionaryRef myDict = CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray, 0));
//        if (myDict != nil) {
//            NSDictionary *dict = (NSDictionary*)CFBridgingRelease(myDict);
//            ssid = [dict valueForKey:@"SSID"];
//             }
//        }
//     return ssid;
//}
//
////获取MAC --MAC为网络接口物理地址，一般指电脑网卡的物理地址
//
//+ (NSString *)bssid //获取macIP
//{
//    NSString *bssid = @"Not Found";
//    CFArrayRef myArray = CNCopySupportedInterfaces();
//    if (myArray != nil) {
//        CFDictionaryRef myDict = CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray, 0));
//        if (myDict != nil) {
//            NSDictionary *dict = (NSDictionary*)CFBridgingRelease(myDict);
//            bssid = [dict valueForKey:@"BSSID"];
//            }
//        }
//    return bssid;
//
//}

@end
