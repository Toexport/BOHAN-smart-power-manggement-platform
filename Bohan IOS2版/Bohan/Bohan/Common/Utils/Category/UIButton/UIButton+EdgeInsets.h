//
//  UIButton+EdgeInsets.h
//  UFA
//
//  Created by YangLin on 2017/7/28.
//  Copyright © 2017年 UFA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (EdgeInsets)

/**
 设置图片和标题偏移量

 @param imageCenter 图片中心位置
 @param titleCenter 标题中心位置
 */
- (void)imageViewCenter:(CGPoint)imageCenter titleCenter:(CGPoint)titleCenter;
@end
