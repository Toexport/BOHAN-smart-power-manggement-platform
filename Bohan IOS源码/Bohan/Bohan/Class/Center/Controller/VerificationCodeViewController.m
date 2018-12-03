//
//  VerificationCodeViewController.m
//  Bohan
//
//  Created by Yang Lin on 2017/12/24.
//  Copyright © 2017年 Bohan. All rights reserved.
//

#import "VerificationCodeViewController.h"
#import "ResetPwdViewController.h"
#import "CountDownButton.h"
#import "UIButton+Disable.h"
#import "DebuggingANDPublishing.pch"
#import "ZPVerifyAlertView.h"
@interface VerificationCodeViewController ()<UITextFieldDelegate> {
    __weak IBOutlet UITextField *accountTF;
    __weak IBOutlet UITextField *codeTF;
    __weak IBOutlet CountDownButton *sendBtn;
    __weak IBOutlet UIButton *nextBtn;
}
@end

@implementation VerificationCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     accountTF.clearButtonMode = UITextFieldViewModeWhileEditing;  // 一键删除文字
    codeTF.clearButtonMode = UITextFieldViewModeWhileEditing;  // 一键删除文字
    self.title = self.isRegist?Localize(@"注册账号"):Localize(@"忘记密码");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    [nextBtn disable];
}


- (void)getData {
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    NSString *language = [df objectForKey:@"App_Language_Switch_Key"];
    NSString *localeLanguageCode = [NSLocale preferredLanguages][0];
    localeLanguageCode = [[localeLanguageCode componentsSeparatedByString:@"-"] firstObject];
    [self.view.window startLoading];
    if ((language && [language isEqualToString:@"zh-Hans"]) || (!language && [localeLanguageCode isEqualToString:@"zh"])) {
        NSDictionary *dic = @{@"mobileNum":accountTF.text, @"flag":(self.isRegist?@"0":@"1")};
        MyWeakSelf
        [[NetworkRequest sharedInstance] requestWithUrl:GET_REGISTER_CODE_URL parameter:dic completion:^(id response, NSError *error) {
            MyStrongSelf
            [strongSelf.view.window stopLoading];
            //请求成功
            if (!error) {
                [HintView showHint:Localize(@"验证码发送成功")];
                [sendBtn startTime];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [codeTF becomeFirstResponder];
                });
            }else {
                DBLog(@"%@",error);
                [HintView showHint:error.localizedDescription];
            }
        }];
    }else {
        NSDictionary *dic = @{@"reciver":accountTF.text, @"flag":(self.isRegist?@"0":@"1")};
        ZPLog(@"英文");
        MyWeakSelf
        [[NetworkRequest sharedInstance] requestWithUrl:GET_REGISTER_CODE_BY_MAIL_URL parameter:dic completion:^(id response, NSError *error) {
            MyStrongSelf
            [strongSelf.view.window stopLoading];
            //请求成功
            if (!error) {
                [HintView showHint:Localize(@"验证码发送成功")];
                [sendBtn startTime];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [codeTF becomeFirstResponder];
                });
            }else {
                ZPLog(@"%@",error);
                [HintView showHint:error.localizedDescription];
            }
        }];
    }
}

#pragma mark - action
- (IBAction)nextAction {
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    NSString *language = [df objectForKey:@"App_Language_Switch_Key"];
    NSString *localeLanguageCode = [NSLocale preferredLanguages][0];
    localeLanguageCode = [[localeLanguageCode componentsSeparatedByString:@"-"] firstObject];
    if ((language && [language isEqualToString:@"zh-Hans"]) || (!language && [localeLanguageCode isEqualToString:@"zh"])) {
        
        if (![Utils isMobileNumber:accountTF.text]) {
            [HintView showHint:Localize(@"请输入正确手机号")];
        }else{
            ResetPwdViewController *reset = [[ResetPwdViewController alloc] init];
            reset.isRegist = self.isRegist;
            reset.username = accountTF.text;
            reset.code = codeTF.text;
            [self.navigationController pushViewController:reset animated:YES];
            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];  // 隐藏返回按钮上的文字
        }
    }else {
        if (![Utils validateEmail:accountTF.text]) {
            [HintView showHint:Localize(@"请输入正确的邮箱地址")];
        }else{
            ResetPwdViewController *reset = [[ResetPwdViewController alloc] init];
            reset.isRegist = self.isRegist;
            reset.username = accountTF.text;
            reset.code = codeTF.text;
            [self.navigationController pushViewController:reset animated:YES];
            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];  // 隐藏返回按钮上的文字
        }
        ZPLog(@"英文");
    }
}


- (IBAction)getCodeAction {
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    NSString *language = [df objectForKey:@"App_Language_Switch_Key"];
    NSString *localeLanguageCode = [NSLocale preferredLanguages][0];
    localeLanguageCode = [[localeLanguageCode componentsSeparatedByString:@"-"] firstObject];
    if ((language && [language isEqualToString:@"zh-Hans"]) || (!language && [localeLanguageCode isEqualToString:@"zh"])) {
        if (![Utils isMobileNumber:accountTF.text]) {
            [HintView showHint:Localize(@"请输入正确手机号")];
        }else {
            ZPVerifyAlertView *verifyView = [[ZPVerifyAlertView alloc] initWithMaximumVerifyNumber:3 results:^(ZPVerifyState state) {
                NSLog(@"%zd", state);
                [self getData];
            }];
            [verifyView show];
        }
    }else {
        if (![Utils validateEmail:accountTF.text]) {
            [HintView showHint:Localize(@"请输入正确的邮箱地址")];
            ZPLog(@"请输入正确的邮箱");
        }else {
            ZPVerifyAlertView *verifyView = [[ZPVerifyAlertView alloc] initWithMaximumVerifyNumber:3 results:^(ZPVerifyState state) {
                NSLog(@"%zd", state);
                [self getData];
            }];
            [verifyView show];
        }
    }
    
}


#pragma mark - UITextFildDelegate

- (void)textDidChanged:(NSNotification *)notify {
    
    if (accountTF.text.length > 0 && codeTF.text.length > 0) {
        [nextBtn enable];
    }else{
        [nextBtn disable];
    }
}

@end
