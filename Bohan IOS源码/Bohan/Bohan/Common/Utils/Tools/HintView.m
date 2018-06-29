//
//  HintView.m
//  UFA
//
//  Created by YangLin on 2017/7/20.
//  Copyright © 2017年 UFA. All rights reserved.
//



#import "HintView.h"
#import "DebuggingANDPublishing.pch"
@implementation HintView

#define kTagHintView 5000000

+ (void)showHint:(NSString *)text
{
    [HintView showHintWithText:text type:HintType_Botton];
}


+ (void)showHintWithText:(NSString *)text type:(HintType)type
{
    if (!text || text.length == 0) {
        return;
    }
    CGSize size = getTextSize(Font(16), text, ScreenWidth - 100);
    size.height += 20;
    size.width += 20;
    
    CGPoint theCenter;
    UIColor *color;
    if (type == HintType_Top) {
        theCenter = CGPointMake(ScreenWidth/2, 84);
        color = RGBColor(218, 117, 213, 0.8);
    }else
    {
        theCenter = CGPointMake(ScreenWidth/2, ScreenHeight - size.height - kNavBarHeight);
        color = RGBColor(61, 141, 241, 0.8);
    }
    
    UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow endEditing:YES];
    [[keyWindow viewWithTag:kTagHintView] removeFromSuperview];
    
    UIFont *textFont = Font(16);
    
    UILabel *hintView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    hintView.center = theCenter;
    [hintView setBackgroundColor:color];
    hintView.tag = kTagHintView;
    hintView.font = textFont;
    hintView.textAlignment = NSTextAlignmentCenter;
    hintView.numberOfLines = 0;
    hintView.text = text;
    hintView.textColor = [UIColor whiteColor];
    hintView.layer.cornerRadius = 8;
    hintView.layer.masksToBounds = YES;
    
    [keyWindow addSubview:hintView];
    
    [keyWindow bringSubviewToFront:hintView];
    hintView.alpha = 0;
    
    [UIView animateWithDuration:0.5 animations:^{
        [hintView setAlpha:1.0f];
        [hintView.layer setTransform:(CATransform3DMakeScale(1.0, 1.0, 1.0))];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 delay:2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [hintView setAlpha:0.0f];
            
        } completion:^(BOOL finished) {
            [hintView removeFromSuperview];
        }];
    }];
    
}
@end
