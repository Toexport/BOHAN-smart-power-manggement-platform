//
//  UIViewController+LLProgress.h
//  FrameworkTest
//
//  Created by APPLE on 2017/9/7.
//  Copyright © 2017年 com.icue. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 設置UIBarItem
 - LLNavigationBarItemTypeLeftFirst: 左邊第一個
 - LLNavigationBarItemTypeLeftSecond: 左邊第二個
 - LLNavigationBarItemTypeRightFirst: 右邊第一個
 - LLNavigationBarItemTypeRightSecond: 右邊第二個
 - LLNavigationBarItemTypeRightThird: 右邊第三個
 */
typedef NS_ENUM(NSInteger,LLNavigationBarItemType) {
    LLNavigationBarItemTypeLeftFirst,
    LLNavigationBarItemTypeLeftSecond,
    LLNavigationBarItemTypeRightFirst,
    LLNavigationBarItemTypeRightSecond,
    LLNavigationBarItemTypeRightThird,
};

@interface UIViewController (LLProgress)

/**
 添加UINavigationBarItem

 @param itemType 類型，即位置
 @param handler 返回UIButton
 */
- (void)addNavigationBarItemWithType:(LLNavigationBarItemType)itemType
                             handler:(void(^)(UIButton *button))handler;



@end
