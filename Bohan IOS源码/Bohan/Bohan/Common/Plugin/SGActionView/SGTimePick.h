//
//  SGSheetMenu.h
//  SGActionView
//
//  Created by Sagi on 13-9-6.
//  Copyright (c) 2013年 AzureLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGBaseMenu.h"


@interface SGTimePick : SGBaseMenu
{
    NSArray *subDataArray;
}

- (id)initWithTitle:(NSString *)title type:(ActionSheetType)currentType starTime:(NSDate *)starTimeDate withIndex:(NSString *)indexStr;

- (void)triggerSelectedAction:(void (^)(NSDate *startTime,NSString *selectedItem))actionHandle;

@property (nonatomic, strong) void(^actionHandle)(NSDate *selectTime,NSString *selectedItem);
@property (nonatomic, strong) NSArray *dataArray;
@end
