//
//  FeedbackViewController.m
//  Bohan
//
//  Created by Yang Lin on 2018/2/5.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import "FeedbackViewController.h"
#import "UIViewController+NavigationBar.h"
//#import "EdgetTextField.h"
#import "DebuggingANDPublishing.pch"
#import "DescModel.h"
#import "SGActionView.h"
@interface FeedbackViewController ()
{
    NSMutableArray *datas;
}
@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = Localize(@"意见与反馈");
    
    datas = [NSMutableArray array];
//    [self rightBarImage:@"" action:@selector(hostoryAction)];
    
    if (@available(iOS 11.0, *)){
        [self.emotiontext setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }else
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self loadData];
//    [self.view setBackgroundColor:[UIColor getColor:@"f0f0f0"]];
//
//    [_emotiontext setBackgroundColor:[UIColor getColor:@"ffffff"]];
//    [_emotiontext.layer setCornerRadius:5];
}


- (void)loadData
{
    
    [self.view.window startLoading];
    [[NetworkRequest sharedInstance] requestWithUrl:GET_CLASSIFICATION_URL parameter:nil completion:^(id response, NSError *error) {
        
        [self.view.window stopLoading];
        //请求成功
        if (!error) {
//            NSArray *arr = [[NSArray yy_modelArrayWithClass:[DescModel class] json:response[@"content"]] mutableCopy];
            
            if ([response[@"content"] isKindOfClass:[NSDictionary class]]) {
                
                [datas addObject:response[@"content"][@"CDesc"]];

            }else if ([response[@"content"] isKindOfClass:[NSArray class]])
            {
                for (NSDictionary *dic in response[@"content"]) {
                    [datas addObject:dic[@"CDesc"]];
                }
            }
        }else
        {
            [HintView showHint:error.localizedDescription];
        }
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)hostoryAction
{
    
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        self.placeHolder.hidden = NO;
    }else
    {
        self.placeHolder.hidden = YES;
    }
}


- (IBAction)submitAction {
    
    if ([_typeLab.text isEqualToString:Localize(@"请选择问题分类")]) {
        [HintView showHint:Localize(@"请选择问题分类")];
        return;

    }else if ([Utils convertToInt:_emotiontext.text] < 20) {

        [HintView showHint:Localize(@"请输入10个字以上的反馈意见")];
        return;
    }
    [self.view startLoading];
    NSDictionary *dic = @{@"CDesc":_typeLab.text, @"Content":_emotiontext.text};
    [[NetworkRequest sharedInstance] requestWithUrl:FEEDBACK_URL parameter:dic completion:^(id response, NSError *error) {

        [self.view stopLoading];
        //请求成功
        if (!error) {

            [HintView showHint:Localize(@"提交成功")];
            [self.navigationController popViewControllerAnimated:YES];

        }else
        {
            [HintView showHint:error.localizedDescription];
        }

    }];
    
}

- (IBAction)selectAction {
    
    [SGActionView showSheetWithTitle:nil itemTitles:datas itemSubTitles:nil selectedIndex:[datas indexOfObject:self.typeLab.text] selectedHandle:^(NSInteger index) {
        
        self.typeLab.text = datas[index];
        
    }];

}

@end
