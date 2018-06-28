//
//  ESPSmartConnect.h
//  Bohan
//
//  Created by Yang Lin on 2018/1/10.
//  Copyright © 2018年 Bohan. All rights reserved.
//

typedef NS_ENUM(NSInteger, ESPConnectResultType) {
    
    ESPConnectResultTypeUnKnownError = 1,
    ESPConnectResultTypeSucceed,
    ESPConnectResultTypePwdError,
    ESPConnectResultTypeTimeout,
    ESPConnectResultTypeCancel

};

typedef void(^ConnectResultBlock)(ESPConnectResultType resultType, NSString *server, NSString *port);


#import <Foundation/Foundation.h>


@interface ESPSmartConnect : NSObject


- (void)connectWithApSsid:(NSString *)apSsid apPwd:(NSString *)apPwd;

- (void)connectCancel;
- (NSString *)fetchSsid;

@property (nonatomic, copy) ConnectResultBlock resultBlock;
@property (nonatomic, assign) ESPConnectResultType resultType;



@end
