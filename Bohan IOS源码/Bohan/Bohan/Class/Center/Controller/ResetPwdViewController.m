//
//  ResetPwdViewController.m
//  Bohan
//
//  Created by Yang Lin on 2017/12/24.
//  Copyright © 2017年 Bohan. All rights reserved.
//

#import "ResetPwdViewController.h"
#import "UIButton+Disable.h"
#import "DebuggingANDPublishing.pch"
@interface ResetPwdViewController ()<UITextFieldDelegate> {
    __weak IBOutlet UITextField * pwdTF;
    __weak IBOutlet UIButton * okBtn;
}

@end

@implementation ResetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = Localize(@"注册账号");
    pwdTF.keyboardType = UIKeyboardTypeASCIICapable;
    pwdTF.clearButtonMode = UITextFieldViewModeWhileEditing;  // 一键删除文字
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    [okBtn disable];
}

- (void)submit {
    [self.view.window startLoading];
    NSDictionary *parameter = @{@"userName":self.username, @"password":pwdTF.text, @"checkCode":self.code, @"flag":(self.isRegist?@"0":@"1")};
    [[NetworkRequest sharedInstance] requestWithUrl:REGISTER_URL parameter:parameter completion:^(id response, NSError *error) {
        [self.view.window stopLoading];
        //请求成功
        if (!error) {
            [HintView showHint:self.isRegist?Localize(@"注册成功"):Localize(@"重置密码成功")];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else {
            [HintView showHint:error.localizedDescription];
        }
    }];
}

- (IBAction)okAction {
    if ([Utils vertifyThePassword:pwdTF.text]) {
        [self submit];
    }else {
        [HintView showHint:Localize(@"请输入英文或数字(6到12位)")];
    }
}

#pragma mark - UITextFildDelegate
- (void)textDidChanged:(NSNotification *)notify {
    if (pwdTF.text.length >0) {
        [okBtn enable];
    }else {
        [okBtn disable];
    }
}

@end
