//
//  HintView.h
//  UFA
//
//  Created by YangLin on 2017/7/20.
//  Copyright © 2017年 UFA. All rights reserved.
//
typedef NS_ENUM(NSInteger, HintType)
{
    HintType_Top = 0,
    HintType_Botton
};

#import <Foundation/Foundation.h>

@interface HintView : NSObject


#define kTagHintView 5000000

+ (void)showHint:(NSString *)text;


@end
