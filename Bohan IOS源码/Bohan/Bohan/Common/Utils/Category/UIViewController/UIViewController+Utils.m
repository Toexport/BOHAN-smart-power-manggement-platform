//
//  UIViewController+Utils.m
//  UFA
//
//  Created by YangLin on 2017/12/18.
//  Copyright © 2017年 UFA. All rights reserved.
//

#import "UIViewController+Utils.h"
#import "UIBarButtonItem+Button.h"
@implementation UIViewController (Utils)


//- (void)showMessage:(NSString *)message
//{
//
//}
//
//- (void)showError:(NSError *)error
//{
//
//}

-(void)setGoBackOrDismissButtonAuto {
    if([self.navigationController.viewControllers count]>1){
        [self setBackButton];
    }else{
        [self setCancelButton];
    }
}

-(void)dismissAutomatically {
    if([self.navigationController.viewControllers count]>1){
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)setBackButton {
    //白色
    UIBarButtonItem *leftButtonItem = [UIBarButtonItem backItemWithImage:[UIImage imageNamed:@"whiteBack"] highImage:[UIImage imageNamed:@"whiteBack"] target:self action:@selector(popViewControllerAnimated)];
    //    [leftButtonItem setTintColor:TP.barTintColor];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
}

-(void)setCancelButton {
    UIBarButtonItem *leftButtonItem =[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bar_icon_close"] style:UIBarButtonItemStylePlain target:self action:@selector(dismissModalViewController)];
    //    [leftButtonItem setTintColor:TP.barTintColor];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
}

- (void)setRightBarButtonWithImage:(UIImage*)image target:(id)aTarget action:(SEL)aAction {
    UIBarButtonItem *ButtonItem =[[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:aTarget action:aAction];
    //    [ButtonItem setTintColor:TP.barTintColor];
    self.navigationItem.rightBarButtonItem = ButtonItem;
}

- (void)setLeftBarButtonWithImage:(UIImage*)image target:(id)aTarget action:(SEL)aAction {
    UIBarButtonItem *ButtonItem =[[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:aTarget action:aAction];
    //    [ButtonItem setTintColor:TP.barTintColor];
    self.navigationItem.leftBarButtonItem = ButtonItem;
}

//-(void)showLoading
//{
//    [AV showTitle:@"请求中..." type:AlertTypeLoading];
//}


//-(void)hideLoading
//{
//    [AV hide];
//}

- (void)setRightBarButtonWithTitle:(NSString*)aTitle target:(id)aTarget action:(SEL)aAction {
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:aTitle style:UIBarButtonItemStylePlain target:self action:aAction];
}

//- (void)showError:(NSError *)error
//{
//    [AV showTitle:nil details:[Toolkit getErrorMsg:error]];
//}


//- (void)showText:(NSString*)str
//{
//    if(![str isKindOfClass:[NSString class]]){
//        return;
//    }
//    if ([str length] > 0) {
//        [AV showTitle:@"提示" details:str];
//    }
//}

-(void)popViewControllerAnimated {
    [self selfWillPop];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dismissModalViewController {
    [self selfWillPop];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)selfWillPop {
    
}


@end
