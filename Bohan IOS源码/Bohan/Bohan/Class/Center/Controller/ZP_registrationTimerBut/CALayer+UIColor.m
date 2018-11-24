//
//  CALayer+UIColor.m
//  VINEYARDS
//
//  Created by APPLE on 16/9/5.
//  Copyright © 2016年 VINEYARDS. All rights reserved.
//

#import "CALayer+UIColor.h"

@implementation CALayer (UIColor)

- (void) setBorderColorFromUIColor:(UIColor *)borderColorFromUIColor {
    self.borderColor = borderColorFromUIColor.CGColor;
}

- (UIColor *) borderColorFromUIColor {
    return [UIColor colorWithCGColor:self.borderColor];
}

@end
