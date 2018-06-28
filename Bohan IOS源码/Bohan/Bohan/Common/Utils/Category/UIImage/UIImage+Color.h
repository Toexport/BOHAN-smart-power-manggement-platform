//
//  UIImage+Color.h
//  UFA
//
//  Created by YangLin on 2017/7/9.
//  Copyright © 2017年 UFA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Color)


/**
 根据颜色值生成图片

 @param color 颜色值
 @return 返回生成的对应颜色的颜色值
 */
+ (UIImage*) createImageWithColor: (UIColor*) color;

/**
 根据颜色值生成图片
 
 @param color 颜色值
 @param height 图片高度
 @return 返回生成的对应颜色的颜色值
 */

+ (UIImage*) createImageWithColor: (UIColor*) color height:(CGFloat)height;

@end
