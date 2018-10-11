//
//  ZPPayPopupView.m
//  Bohan
//
//  Created by summer on 2018/10/10.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import "ZPPayPopupView.h"
#import "ZPPayPasswordView.h"
#import "PrefixHeader.pch"

#define kZJAnimationTimeInterval 0.3
#define kZJSupeViewAlpha 0.3

@interface ZPPayPopupView ()<UITextFieldDelegate>
@property (nonatomic, strong) ZPPayPasswordView *payPasswordView;

@end

@implementation ZPPayPopupView

#pragma mark -lifeCycle

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = UIColorFromHEX(0xffffff);
        [self createUI];
    }
    return self;
}

- (void)createUI {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.superView];
    [self.superView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.left.equalTo(window);
    }];
    
    [self.superView addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.superView);
        make.top.equalTo(self.superView.mas_top).with.offset(XX_6(230));
    }];
    
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(XX_6(16));
        make.centerX.equalTo(self);
    }];
    
    [self addSubview:self.closeButton];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(XX_6(16));
        make.centerY.equalTo(self.titleLabel);
        make.width.mas_equalTo(XX_6(14));
        make.height.mas_equalTo(XX_6(14));
    }];
    
    [self addSubview:self.sendBtn];
    [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).with.offset(XX_6(-8));
        make.centerY.equalTo(self.titleLabel);
        make.width.mas_equalTo(XX_6(120));
        make.height.mas_equalTo(XX_6(30));
    }];
    
    [self addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.mas_top).with.offset(XX_6(48));
        make.height.mas_equalTo(XX_6(1));
    }];
    
    [self addSubview:self.payPasswordView];
    [self.payPasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self.mas_top).with.offset(XX_6(70));
        make.height.mas_equalTo(XX_6(50));
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    
    [self addSubview:self.forgetPasswordButton];
    [self.forgetPasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).with.offset(XX_6(-16));
        make.top.equalTo(self.payPasswordView.mas_bottom).with.offset(XX_6(16));
        make.height.mas_equalTo(XX_6(20));
        make.width.mas_equalTo(XX_6(60));
    }];
}

#pragma mark -Private
- (void)forgetPasswordAction {
//        [self hidePayPopView];
    if ([self.delegate respondsToSelector:@selector(didClickForgetPasswordButton)]) {
        [self.delegate didClickForgetPasswordButton];
    }
}

#pragma mark -Public
- (void)showPayPopView {
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:kZJAnimationTimeInterval animations:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.superView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.3];
    } completion:nil];
}

- (void)hidePayPopView {
    [self hidePayPopView:nil];
}

- (void)hidePayPopView:(BHFinishBlock)block {
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:kZJAnimationTimeInterval animations:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.superView.alpha = 0.0;
        strongSelf.frame = CGRectMake(strongSelf.frame.origin.x, SCREEN_HEIGHT, strongSelf.frame.size.width, strongSelf.frame.size.height);
    } completion:^(BOOL finished) {
        if (block) {
            block(0);
        }
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.superView removeFromSuperview];
        strongSelf.superView = nil;
    }];
}

- (void)didInputPayPasswordError {
    [self.payPasswordView didInputPasswordError];
}

#pragma mark -Setter/Getter
- (ZPPayPasswordView *)payPasswordView {
    if (!_payPasswordView) {
        _payPasswordView = [[ZPPayPasswordView alloc] init];
        __weak typeof(self) weakSelf = self;
        _payPasswordView.completionBlock = ^(NSString *password) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if ([strongSelf.delegate respondsToSelector:@selector(didPasswordInputFinished:)]) {
                [strongSelf.delegate didPasswordInputFinished:password];
            }
        };
    }
    return _payPasswordView;
}

- (UIView *)superView {
    if (!_superView) {
        _superView = [[UIView alloc] init];
    }
    return _superView;
}

- (UIView *)payPopupView {
    if (!_payPopupView) {
        _payPopupView = [[UIView alloc] init];
        _payPopupView.backgroundColor = UIColorFromHEX(0xFFFFFF);
    }
    return _payPopupView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = UIColorFromHEX(0x444444);
        _titleLabel.font = Font_XX6(16);
        _titleLabel.text = Localize(@"交易密码");
    }
    return _titleLabel;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setBackgroundImage:[UIImage imageNamed:@"zj_close_icon"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(hidePayPopView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (CountDownButton *)sendBtn {
    if (!_sendBtn) {
        _sendBtn = [CountDownButton buttonWithType:UIButtonTypeCustom];
        [_sendBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        [_sendBtn setTitleColor:UIColorFromHEX(0x444444) forState:UIControlStateNormal];
        _sendBtn.titleLabel.font = Font_XX6(12);
        [_sendBtn addTarget:self action:@selector(sendBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendBtn;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = UIColorFromHEX(0xEEEEEE);
    }
    return _lineView;
}

- (UIButton *)forgetPasswordButton {
    if (!_forgetPasswordButton) {
        _forgetPasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_forgetPasswordButton setTitle:@"忘记密码" forState:UIControlStateNormal];
        [_forgetPasswordButton setTitleColor:UIColorFromHEX(0xFF352E) forState:UIControlStateNormal];
        _forgetPasswordButton.titleLabel.font = Font_XX6(12);
        [_forgetPasswordButton addTarget:self action:@selector(forgetPasswordAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forgetPasswordButton;
}

@end
