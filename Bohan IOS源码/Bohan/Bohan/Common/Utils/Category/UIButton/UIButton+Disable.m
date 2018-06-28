//
//  UIButton+Disable.m
//  Wordaily
//
//  Created by YangLin on 16/3/22.
//  Copyright © 2016年 YangLin. All rights reserved.
//

#import "UIButton+Disable.h"
@implementation UIButton (Disable)


- (void)disable
{
    [self setEnabled:NO];

    [self setBackgroundColor:RGBColor(158, 155, 162, 0.5)];

}
- (void)enable
{
    
    [self setBackgroundColor:kDefualtColor];

    [self setEnabled:YES];
}
@end
