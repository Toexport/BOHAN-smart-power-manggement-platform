//
//  CommonOperation.m
//  UFA
//
//  Created by YangLin on 2017/7/20.
//  Copyright © 2017年 UFA. All rights reserved.
//

#import "CommonOperation.h"
#import "FSAES128.h"
#import "NSData+Base64.h"
#import "NSString+Reverse.h"
#import "AppDelegate.h"

@implementation CommonOperation


//+ (void)keyRequest
//{
//
//    [[NetworkRequest sharedInstance] requestWithUrl:GETKEY_URL parameter:nil completion:^(NSInteger flag, id response) {
//
//        //请求成功
//        if (flag == 1) {
//            NSString *keyString = response[@"datas"][@"k"];
//            if (keyString && keyString.length > 0) {
//
//                NSData *data  = [NSData dataWithBase64EncodedString:keyString];
//                NSString *string =  [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//                NSString *tem = [FSAES128 AES128DecryptString:[string reverse]];
//                NSArray *array = [tem componentsSeparatedByString:@"."];
//                if (array.count>1) {
//                    NSString *key = array[1];
//                    [[NSUserDefaults standardUserDefaults] setObject:key forKey:@"SECRETKEY"];
//                    [[NSUserDefaults standardUserDefaults] synchronize];
//                }
//            }
//        }
//    }];
//
//}
//
//+ (void)areaRequestComplation:(void(^)(NSInteger flag, NSArray *cityArr))block
//{
//
//    [[NetworkRequest sharedInstance] requestWithUrl:REGIONLIST_URL parameter:nil completion:^(NSInteger flag, id response) {
//
//        //请求成功
//        if (flag == 1) {
//
//            NSArray *cityArr = [response objectForKey:@"datas"];
//
//            if (cityArr.count > 0) {
//
//                NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
//                path = [path stringByAppendingPathComponent:@"area.plist"];
//
//                [NSKeyedArchiver archiveRootObject:cityArr toFile:path];
//
//            }
//
//            if (block) {
//                block(flag,cityArr);
//            }
//        }
//    }];
//}
//
//+ (void)updateRequest
//{
//
//    [[NetworkRequest sharedInstance] requestWithUrl:VERSION_UPDATE_URL parameter:@{@"appType":@"1", @"platType":@"1"} completion:^(NSInteger flag, id response) {
//
//        //请求成功
//        if (flag == 1) {
//
//            NSDictionary *versionDic = response[@"datas"];
//            if ([CURRENTSHORTVERSION compare:versionDic[@"versionCode"] options:NSNumericSearch] == NSOrderedAscending) {
//
//                BOOL isForced = [versionDic[@"forced"] isEqualToString:@"1"]?YES:NO;
//                UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"新版本V%@更新提示",versionDic[@"versionCode"]] message:[NSString stringWithFormat:@"%@%@",versionDic[@"content"],isForced?@"\n\n当前版本已无法使用，请更新后使用":@""] preferredStyle:UIAlertControllerStyleAlert];
//                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"马上更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//                    if (isForced) {
//                        [[NSNotificationCenter defaultCenter] postNotificationName:LOGOUTNOTIFICATION object:nil];
//                    }
//
//                    NSString *iTunesString = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@", APPID];
//                    NSURL *iTunesURL = [NSURL URLWithString:iTunesString];
//                    [[UIApplication sharedApplication] openURL:iTunesURL];
//
//                }];
//                [alert addAction:okAction];
//
//                if (!isForced) {
//                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"稍后更新" style:UIAlertActionStyleCancel handler:nil];
//                    [alert addAction:cancelAction];
//                }
//                AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//                [delegate.window.rootViewController presentViewController:alert animated:YES completion:nil];
//            }
//        }
//    }];
//}
//
//


//设置通用参数并加密处理
+ (NSDictionary *)publicParamatersWithDic:(NSDictionary *)dic isSign:(BOOL)sign
{
    NSMutableDictionary *paramater = [NSMutableDictionary dictionaryWithDictionary:dic];
    
//    UserInfoManager *manager = [UserInfoManager sharedInstance];
    
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
    long long totalMilliseconds = interval*1000 ;
    
    NSString *timeSp = [NSString stringWithFormat:@"%lld",totalMilliseconds];
    
    [paramater setObject:CURRENTVERSION forKey:@"version"];
    [paramater setObject:@"ios" forKey:@"platform"];
    
    if (sign) {
        
//        if (manager.userInfo.token) {
//
//            [paramater setObject:manager.userInfo.token forKey:@"token"];
//        }
        [paramater setObject:timeSp forKey:@"nonce"];
        
        if (SIGNKEY) {
            
            NSMutableArray *keys = [NSMutableArray array];
            for (NSString *key in paramater.allKeys) {
                
                NSString *value = paramater[key];
                if (value && value.length > 0) {
                    
                    [keys addObject:key];
                }
            }
            
            NSArray *comparatorSortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                return [obj1 compare:obj2];
            }];
            
            NSMutableString *sign = [NSMutableString string];
            
            __block typeof(NSMutableString *) weakSign = sign;
            // 打印排序信息
            [comparatorSortedArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [weakSign appendFormat:@"%@=%@&",obj,paramater[obj]];
            }];
            
            [sign appendFormat:@"key=%@",SIGNKEY];
            
            [paramater setObject:[Utils md5:sign] forKey:@"sign"];
        }
        
    }
    
    return paramater;
}


+ (void)cancelDeviceRunModel:(NSString *)deviceNo result:(void(^)(id response, NSError *error))block
{

    WebSocket *socket = [WebSocket socketManager];
    CommandModel *model = [[CommandModel alloc] init];
    model.command = @"0002";
    model.deviceNo = deviceNo;
    
    [socket sendSingleDataWithModel:model resultBlock:^(id response, NSError *error) {
        
        if (!error) {
            
            if (((NSString *)response).length>26) {
                
                NSString *status = [response substringWithRange:NSMakeRange(24, 2)];
                model.command = @"0013";
                model.content = status;
                [socket sendSingleDataWithModel:model resultBlock:^(id response, NSError *error) {
                    
                    if (!error) {
                        //******注意：开启成功后，需要重新取实时数据*******
                        block(response, nil);
                    }else
                    {
                        block(nil, error);
                    }
                }];
                
            }
            
        }
        
    }];
    
}



@end
