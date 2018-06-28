//
//  ESPSmartConnect.m
//  Bohan
//
//  Created by Yang Lin on 2018/1/10.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import "ESPSmartConnect.h"
#import "ESPTouchTask.h"
#import "ESPTouchResult.h"
#import "ESP_NetUtil.h"
#import "ESPTouchDelegate.h"
#import <ifaddrs.h>

#import <arpa/inet.h>
#import <SystemConfiguration/CaptiveNetwork.h>

@interface ESPSmartConnect ()<ESPTouchDelegate>

@property (atomic, strong) ESPTouchTask *_esptouchTask;
@property (nonatomic, strong) NSCondition *_condition;

@end

@implementation ESPSmartConnect

- (instancetype)init
{
    if (self == [super init]) {
        
        self._condition = [[NSCondition alloc]init];
    }
    return self;
}

- (void)connectWithApSsid:(NSString *)apSsid apPwd:(NSString *)apPwd
{
    
    [self._condition lock];

    self._esptouchTask =
    [[ESPTouchTask alloc]initWithApSsid:apSsid andApBssid:[self fetchBssid] andApPwd:apPwd andTimeoutMillisecond:30000];
    [self._esptouchTask setEsptouchDelegate:self];
    [self._esptouchTask executeForResults:1];
    
    [self._condition unlock];

}


- (void)connectCancel
{
    [self._condition lock];
    if (self._esptouchTask != nil)
    {
        [self._esptouchTask interrupt];
    }
    [self._condition unlock];
}

- (NSString *)fetchSsid
{
    NSDictionary *ssidInfo = [self fetchNetInfo];
    
    return [ssidInfo objectForKey:@"SSID"];
}

- (NSString *)fetchBssid
{
    NSDictionary *bssidInfo = [self fetchNetInfo];
    
    return [bssidInfo objectForKey:@"BSSID"];
}

// refer to http://stackoverflow.com/questions/5198716/iphone-get-ssid-without-private-library
- (NSDictionary *)fetchNetInfo
{
    NSArray *interfaceNames = CFBridgingRelease(CNCopySupportedInterfaces());
    //    NSLog(@"%s: Supported interfaces: %@", __func__, interfaceNames);
    
    NSDictionary *SSIDInfo;
    for (NSString *interfaceName in interfaceNames) {
        SSIDInfo = CFBridgingRelease(
                                     CNCopyCurrentNetworkInfo((__bridge CFStringRef)interfaceName));
        //        NSLog(@"%s: %@ => %@", __func__, interfaceName, SSIDInfo);
        
        BOOL isNotEmpty = (SSIDInfo.count > 0);
        if (isNotEmpty) {
            break;
        }
    }
    return SSIDInfo;
}


#pragma mark - ESPTouchDelegate
-(void) onEsptouchResultAddedWithResult: (ESPTouchResult *) result
{
    
    
    if (result.isSuc) {
        
        NSString *ipAddress = [ESP_NetUtil descriptionInetAddr4ByData:result.ipAddrData];
        NSString *port = [NSString stringWithFormat:@"%d",self._esptouchTask._server.port];
        NSLog(@"配网成功: ipAddress=%@,port=%@", ipAddress,port);
        if (self.resultBlock) {
            self.resultBlock(ESPConnectResultTypeSucceed, ipAddress, port);
        }
    }else
    {
        if (self.resultBlock) {
            
            self.resultBlock(result.isCancelled?ESPConnectResultTypeCancel:ESPConnectResultTypeUnKnownError, nil, nil);
        }
    }
}


- (void) onEsptouchTimeout
{
    if (self.resultBlock) {
        self.resultBlock(ESPConnectResultTypeTimeout, nil, nil);
    }

}

//密码错误
- (void) onEsptouchPasswordError
{
    if (self.resultBlock) {
        self.resultBlock(ESPConnectResultTypePwdError, nil, nil);
    }

}

@end
