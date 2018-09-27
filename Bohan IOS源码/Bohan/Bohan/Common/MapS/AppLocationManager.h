//
//  AppLocationManager.h
//  Bohan
//
//  Created by summer on 2018/9/4.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
typedef void(^XMInfoBlock)(NSDictionary *info);

@interface AppLocationManager : NSObject

@property (nonatomic, copy)NSString *area;
@property (nonatomic, copy)NSString *city;
@property (nonatomic, copy)NSString *cityCode;
@property (nonatomic, copy)NSString *latitude;
@property (nonatomic, copy)NSString *longitude;
@property (nonatomic, strong)XMInfoBlock infoBlock;


+ (instancetype)shareAppLocationManager;

- (void)getLocation:(XMInfoBlock)infoBlock;

+ (void)jumpToMapWithLat:(NSString *)lat lng:(NSString *)lng title:(NSString *)title content:(NSString *)content VC:(UIViewController *)vc;

@end
