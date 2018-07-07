//
//  UIColor+Transform.h
//  UFA
//
//  Created by YangLin on 2017/7/7.
//  Copyright © 2017年 UFA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface UIColor (Transform)

/**
 将十六进制的颜色值转为objective-c的颜色

 @param hexColor 十六进制颜色值
 @return 返回转换后的颜色
 */
+ (instancetype)getColor:(NSString *) hexColor;
@end


@interface CALayer (LayerColor)

@property (nonatomic, strong)UIColor *borderColorFromUIColor;

@end
