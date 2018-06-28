//
//  TimeSettingModel.h
//  Bohan
//
//  Created by Yang Lin on 2018/1/18.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeSettingModel : NSObject

@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, copy) NSString *week;
@property (nonatomic, assign) BOOL open;
@property (nonatomic, assign) BOOL showOn;


@end
