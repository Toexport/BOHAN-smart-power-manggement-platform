//
//  UILabel+Convenience.m
//  UFA
//
//  Created by mac on 2017/7/12.
//  Copyright © 2017年 UFA. All rights reserved.
//

#import "UILabel+Convenience.h"
#import "DebuggingANDPublishing.pch"
@implementation UILabel (Convenience)

+(instancetype)createLabelText:(NSString *)text textColor:(UIColor *)textColor textFontSize:(CGFloat)font{
    UILabel *label = [[UILabel alloc]init];
    label.text = text;
    label.textColor = textColor;
    label.font = [UIFont systemFontOfSize:font];
    return label;
    
}
@end
