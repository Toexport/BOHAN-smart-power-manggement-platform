//
//  UIFont+Adaptation.h
//  UFA
//
//  Created by YangLin on 2017/12/15.
//  Copyright © 2017年 UFA. All rights reserved.
//
#define SizeScale (ScreenWidth)/375.0
//#define Font(f) [UIFont systemFontOfSize:MFontSize(f)]
#define Font(size) [UIFont systemFontOfSize:size]
//不根据屏幕适配的字体
#define EFont(size) [UIFont adjustFont:size]

//不根据屏幕适配的粗体字体
#define EBFont(size) [UIFont adjustBlodFont:size]

//按缩放系数向上取整
#define MFontSize(size) MAX(10,ceilf(size * SizeScale))
//xib、storyboard上不用适配字体控件tag
#define ExcaptionTag  10000

#import <UIKit/UIKit.h>

@interface UIFont (Adaptation)

+ (UIFont *)adjustFont:(CGFloat)fontSize;

+ (UIFont *)adjustBlodFont:(CGFloat)fontSize;

@end


@interface UILabel (UIFont)

@end


@interface UIButton (UIFont)

@end


@interface UITextField (UIFont)

@end


@interface UITextView (UIFont)

@end

