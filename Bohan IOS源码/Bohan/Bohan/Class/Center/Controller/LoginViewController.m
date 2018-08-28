//
//  LoginViewController.m
//  Bohan
//
//  Created by Yang Lin on 2017/12/24.
//  Copyright © 2017年 Bohan. All rights reserved.
//

#import "LoginViewController.h"
#import "VerificationCodeViewController.h"
#import "WebViewController.h"
#import "DebuggingANDPublishing.pch"
@interface LoginViewController ()<UITextFieldDelegate>
{
    __weak IBOutlet EdgetTextField *accountTF;
    __weak IBOutlet EdgetTextField *passwordTF;
    __weak IBOutlet UIImageView *accountLeft;
    __weak IBOutlet UIImageView *passwordLeft;
    __weak IBOutlet UIButton *passwordRight;
    __weak IBOutlet UIButton *moreInfoBtn;
    
    
}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor getColor:@"3d8df1"];
    self.navigationController.navigationBarHidden = YES;
    if (@available(iOS 11.0, *)){
        [(UIScrollView *)self.view setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }else
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    accountTF.keyboardType = UIKeyboardTypeASCIICapable;
    accountTF.clearButtonMode = UITextFieldViewModeWhileEditing;  // 一键删除文字
    passwordTF.keyboardType = UIKeyboardTypeASCIICapable;
    passwordTF.clearButtonMode = UITextFieldViewModeWhileEditing;  // 一键删除文字
    
    accountTF.leftViewSpacing = 8;
    accountTF.textSpacing = 8;
    accountTF.editSpacing = 8;
    
    passwordTF.leftViewSpacing = 8;
    passwordTF.textSpacing = 8;
    passwordTF.editSpacing = 8;

    [accountTF setLeftView:accountLeft];
    [passwordTF setLeftView:passwordLeft];
    [passwordTF setRightView:passwordRight];
    
    accountTF.leftViewMode = UITextFieldViewModeAlways;
    passwordTF.leftViewMode = UITextFieldViewModeAlways;

    accountTF.rightViewMode = UITextFieldViewModeWhileEditing;
    passwordTF.rightViewMode = UITextFieldViewModeAlways;
    
    if (USERNAME) {
        accountTF.text = USERNAME;
    }
    if (PASSWORD) {
        passwordTF.text = PASSWORD;
    }
    
    NSString *moreStr = Localize(@"了解更多伯瀚:");
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:moreInfoBtn.titleLabel.text];
    [attr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(moreStr.length, attr.length-moreStr.length)];
    moreInfoBtn.titleLabel.attributedText = attr;
//    [moreInfoBtn.titleLabel setFont:Font(15)];
    moreInfoBtn.titleLabel.numberOfLines = 2;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - action

- (IBAction)loginAction {
    //    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ISLOGIN"];
    if ([accountTF.text rangeOfString:@"@"].location != NSNotFound) {
        ZPLog(@"包含");
        if ([Utils validateEmail:accountTF.text]) {
            if ([Utils vertifyThePassword:passwordTF.text]) {
                [self loginRequest];
            }else {
                [HintView showHint:Localize(@"请输入英文或数字(6到12位)")];
            }
        }else {
            [HintView showHint:Localize(@"请输入正确邮箱地址")];
        }
        
    }else {
        ZPLog(@"不包含");
        if ([Utils isMobileNumber:accountTF.text]) {
            if ([Utils vertifyThePassword:passwordTF.text]) {
                [self loginRequest];
            }else {
                [HintView showHint:Localize(@"请输入英文或数字(6到12位)")];
            }
        }else {
            [HintView showHint:Localize(@"请输入正确手机号")];
        }
    }
}

- (IBAction)showAction:(UIButton *)sender {
    passwordTF.secureTextEntry = sender.selected;
    sender.selected = !sender.selected;
}

- (IBAction)forgotPwdAction {
    VerificationCodeViewController *code = [[VerificationCodeViewController alloc] init];
    [self.navigationController pushViewController:code animated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];  // 隐藏返回按钮上的文字
}

- (IBAction)registAction {
    VerificationCodeViewController *code = [[VerificationCodeViewController alloc] init];
    code.isRegist = YES;
    [self.navigationController pushViewController:code animated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];

    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];  // 隐藏返回按钮上的文字
}

- (IBAction)moreInfoAction {
    WebViewController *help = [[WebViewController alloc] initWithTitle:Localize(@"伯瀚") urlStr:@"http://www.bohan-smartec.com/"];
    help.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:help animated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];  // 隐藏返回按钮上的文字
}

#pragma mark - Request
- (void)loginRequest {
    [self.view.window startLoading];
    NSDictionary *dic = @{@"userName":accountTF.text, @"password":passwordTF.text};
    [[NetworkRequest sharedInstance] requestWithUrl:LOGIN_URL parameter:dic completion:^(id response, NSError *error) {
        
        [self.view.window stopLoading];
        //请求成功
        if (!error) {
            [[WebSocket socketManager].serverSockt webSocketClose];
            [[WebSocket socketManager].serverSockt webSocketOpen];
            [UserInfoManager saveToken:response[@"content"]];
            [UserInfoManager saveUserName:accountTF.text];
            [UserInfoManager savePassword:passwordTF.text];
            [UserInfoManager updateLoginState:YES];
            [(AppDelegate *)[[UIApplication sharedApplication] delegate] createTabBar];

        }else {
            [HintView showHint:error.localizedDescription];
        }
        
    }];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    [self loginRequest];
    return YES;
}
@end
