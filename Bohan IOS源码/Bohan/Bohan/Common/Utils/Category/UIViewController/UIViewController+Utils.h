//
//  UIViewController+Utils.h
//  UFA
//
//  Created by YangLin on 2017/12/18.
//  Copyright © 2017年 UFA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Utils)
- (void)setBackButton;
- (void)setCancelButton;
- (void)setGoBackOrDismissButtonAuto;
-(void)dismissAutomatically;
//- (void) showLoading;
//-(void)showLoadingOnLandscape;
//- (void) hideLoading;
//- (void) showText:(NSString*)str;
//- (void) showError:(NSError*)error;
- (void) setRightBarButtonWithTitle:(NSString*)aTitle target:(id)aTarget action:(SEL)aAction;
- (void) setRightBarButtonWithImage:(UIImage*)image target:(id)aTarget action:(SEL)aAction;
- (void) setLeftBarButtonWithImage:(UIImage*)image target:(id)aTarget action:(SEL)aAction;


@end
