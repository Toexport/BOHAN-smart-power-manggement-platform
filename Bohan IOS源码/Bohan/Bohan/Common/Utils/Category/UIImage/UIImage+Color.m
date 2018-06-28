//
//  UIImage+Color.m
//  UFA
//
//  Created by YangLin on 2017/7/9.
//  Copyright © 2017年 UFA. All rights reserved.
//

#import "UIImage+Color.h"

@implementation UIImage (Color)


+ (UIImage*) createImageWithColor: (UIColor*) color
{
    return [UIImage createImageWithColor:color height:1.0];
}


+ (UIImage*) createImageWithColor: (UIColor*) color height:(CGFloat)height
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}


@end
