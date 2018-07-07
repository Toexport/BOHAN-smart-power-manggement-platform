//
//  YLSheetView.m
//  UFA
//
//  Created by YangLin on 2017/7/10.
//  Copyright © 2017年 UFA. All rights reserved.
//

#import "YLSheetView.h"
#import "DebuggingANDPublishing.pch"
@interface YLSheetView ()
{
    CGRect fromFrame;
    CGRect toFrame;
}
@property (nonatomic, strong) UIButton *backView;
@property (nonatomic, strong) UIView *showView;

@end

@implementation YLSheetView
static YLSheetView *instance = nil;

+ (instancetype)sharedInstace
{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[YLSheetView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        
        [instance addSubview:instance.backView];
    });
    
    return instance;

}

#pragma Event


- (void)showFromBottom:(UIView *)view
{
    toFrame = view.frame;
    fromFrame = CGRectMake(view.frame.origin.x, self.frame.size.height, view.frame.size.width, view.frame.size.height);
    
    [self showView:view];
}

- (void)showFromCenter:(UIView *)view
{
    toFrame = view.frame;
    fromFrame = toFrame;
    
    [self showView:view];

}


- (void)showFromRight:(UIView *)view

{
    toFrame = view.frame;
    fromFrame = CGRectMake(self.frame.size.width, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
    
    [self showView:view];

}

- (void)showView:(UIView *)view
{
    
    //已经添加了一个就不再做处理
    if (self.subviews.count >= 2) {
        return;
    }
    
    [view setFrame:fromFrame];
    self.showView = view;
    
    [self.backView setBackgroundColor:RGBColor(51, 51, 51, 0)];
    
    //    backView.alpha = 0.0;
//    self.alpha = 0.0;
    
//    [self.showView removeFromSuperview];
    
    for (UIView *subview in self.subviews) {
        
        if (subview.tag != 5000) {
            
            [subview removeFromSuperview];
        }
    }
    
    [self addSubview:self.showView];
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        //        backView.alpha = 0.7;
        [self.backView setBackgroundColor:RGBColor(51, 51, 51, 0.5)];
        
//        self.alpha = 1.0;
        
        [self.showView setFrame:toFrame];
        
        [[[UIApplication sharedApplication] keyWindow] addSubview:self];
        
    } completion:^(BOOL finished) {
        
    }];
    
}


- (void)closeView
{
    //    backView.alpha = 0.7;
    [self.backView setBackgroundColor:RGBColor(51, 51, 51, 0.5)];
    
//    self.alpha = 1.0;
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        //        backView.alpha = 0.0;
        [self.backView setBackgroundColor:RGBColor(51, 51, 51, 0)];
        
        [self.showView setFrame:fromFrame];

//        self.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        
        [self.showView removeFromSuperview];
        [self removeFromSuperview];
    }];
    
}


#pragma mark - getter and setter

- (UIButton *)backView
{
    if (!_backView) {
        _backView = [[UIButton alloc] initWithFrame:self.bounds];
        [_backView addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
        [_backView setTag:5000];
    }
    
    return _backView;
}




@end
