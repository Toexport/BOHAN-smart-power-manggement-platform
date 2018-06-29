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
@interface VerificationCodeViewController ()<UITextFieldDelegate>
{
    __weak IBOutlet UITextField *accountTF;
    __weak IBOutlet UITextField *codeTF;
    __weak IBOutlet CountDownButton *sendBtn;
    
    __weak IBOutlet UIButton *nextBtn;
}
@end

@implementation VerificationCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.isRegist?Localize(@"注册账号"):Localize(@"忘记密码");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChanged:) name:UITextFieldTextDidChangeNotification object:nil];

    [nextBtn disable];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)getData
{
    [self.view.window startLoading];
    
    NSDictionary *dic = @{@"mobileNum":accountTF.text, @"flag":(self.isRegist?@"0":@"1")};
    MyWeakSelf
    
    [[NetworkRequest sharedInstance] requestWithUrl:GET_REGISTER_CODE_URL parameter:dic completion:^(id response, NSError *error) {
        
        MyStrongSelf
        [strongSelf.view.window stopLoading];
        
        //请求成功
        if (!error) {
            
            [HintView showHint:Localize(@"验证码发送成功，请留意手机号")];
            [sendBtn startTime];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [codeTF becomeFirstResponder];
            });
            
        }else
        {
            DBLog(@"%@",error);
            [HintView showHint:error.localizedDescription];
        }
        
    }];
    
}




#pragma mark - action

- (IBAction)nextAction {
    
    if (![Utils isMobileNumber:accountTF.text]) {
        [HintView showHint:Localize(@"手机格式有误哦，请输入正确手机号")];
    }else{
        
        ResetPwdViewController *reset = [[ResetPwdViewController alloc] init];
        reset.isRegist = self.isRegist;
        reset.username = accountTF.text;
        reset.code = codeTF.text;
        [self.navigationController pushViewController:reset animated:YES];
    }
}
- (IBAction)getCodeAction {
    
    if (![Utils isMobileNumber:accountTF.text]) {
        [HintView showHint:Localize(@"手机格式有误哦，请输入正确手机号")];
    }else{
        
        [self getData];
    }
}


#pragma mark - UITextFildDelegate

- (void)textDidChanged:(NSNotification *)notify
{
    
    if (accountTF.text.length > 0 && codeTF.text.length > 0)
    {
        [nextBtn enable];
    }else{
        [nextBtn disable];
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
