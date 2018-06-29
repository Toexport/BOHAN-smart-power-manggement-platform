//
//  UIView+loading.m
//  UFA
//
//  Created by YangLin on 2017/7/1.
//  Copyright © 2017年 UFA. All rights reserved.
//

#import "UIView+loading.h"
#import "RTSpinKitView.h"
#import "DebuggingANDPublishing.pch"

static RTSpinKitView * spinner = nil;

#define kSpinnerTag 5000000

@interface UIView ()

@end
@implementation UIView (loading)



#pragma mark - 私有方法
- (void)startLoading
{

    if (spinner.superview == self) {

        return;
    }

    spinner = [[RTSpinKitView alloc] initWithStyle:RTSpinKitViewStyleFadingCircleAlt color:kDefualtColor];
    [spinner setBackgroundColor:[UIColor clearColor]];
    [spinner setTag:kSpinnerTag];
    [spinner setCenter:CGPointMake(ScreenWidth/2.0 - 4, ScreenHeight/2.0 - 4)];

    [spinner startAnimating];

    [self addSubview:spinner];

    self.userInteractionEnabled = NO;

}

- (void)stopLoading
{
    self.userInteractionEnabled = YES;

    for (UIView *view in self.subviews) {

        if (view.tag == kSpinnerTag && [view isKindOfClass:[RTSpinKitView class]]) {

            [spinner stopAnimating];
            [view removeFromSuperview];
            return;
        }
    }
}

@end
