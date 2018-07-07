//
//  YLSheetView.h
//  UFA
//
//  Created by YangLin on 2017/7/10.
//  Copyright © 2017年 UFA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLSheetView : UIView

/**
 获取单例方法
 
 @return 返回单例实例
 */
+ (instancetype)sharedInstace;

/**
 从底部弹出视图

 @param view 需要弹出的视图
 */
- (void)showFromBottom:(UIView *)view;

/**
 从中间弹出视图

 @param view 需要弹出的视图
 */
- (void)showFromCenter:(UIView *)view;


/**
 从右边弹出视图

 @param view 需要弹出的视图
 */
- (void)showFromRight:(UIView *)view;
/**
 收起弹出视图
 */
- (void)closeView;

@end
