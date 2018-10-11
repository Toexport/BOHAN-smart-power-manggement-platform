//
//  ZPPayPopupView.h
//  Bohan
//
//  Created by summer on 2018/10/10.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CountDownButton.h"
NS_ASSUME_NONNULL_BEGIN
@protocol ZPPayPopupViewDelegate <NSObject>

- (void)didClickForgetPasswordButton;
- (void)didPasswordInputFinished:(NSString *)password;

@end

@interface ZPPayPopupView : UIView
@property (nonatomic, weak) id <ZPPayPopupViewDelegate> delegate;
@property (nonatomic, strong) UIView *superView;
@property (nonatomic, strong) UIView *payPopupView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *forgetPasswordButton;
@property (nonatomic, strong) CountDownButton *sendBtn;

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UITextField *textField;
- (void)showPayPopView;
- (void)hidePayPopView:(BHFinishBlock)block;
- (void)didInputPayPasswordError;

@end

NS_ASSUME_NONNULL_END
