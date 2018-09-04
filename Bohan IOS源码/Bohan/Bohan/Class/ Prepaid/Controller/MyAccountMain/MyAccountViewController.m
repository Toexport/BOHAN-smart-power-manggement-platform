//
//  MyAccountViewController.m
//  Bohan
//
//  Created by summer on 2018/9/4.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import "MyAccountViewController.h"
#import "AccountsPrepaidController.h"
#import "RechargeRecordController.h"
#import "PrefixHeader.pch"
#import "DebuggingANDPublishing.pch"
@interface MyAccountViewController ()

@end

@implementation MyAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = Localize(@"我");
    [self initUI];
}

- (void)initUI {
    UITapGestureRecognizer *tapGesturRecognizer1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(AccountsPrepaid:)];
    [self.PayViews addGestureRecognizer:tapGesturRecognizer1];
    
    UITapGestureRecognizer *tapGesturRecognizer2=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(RechargeRecord:)];
    [self.RecordViews addGestureRecognizer:tapGesturRecognizer2];
}

- (void)AccountsPrepaid:(UIButton *)sender {
    AccountsPrepaidController * AccountsPrepaid = [[AccountsPrepaidController alloc]init];
    [self.navigationController pushViewController:AccountsPrepaid animated:YES];
}

- (void)RechargeRecord:(UIButton *)sender {
    RechargeRecordController * RechargeRecord = [[RechargeRecordController alloc]init];
    [self.navigationController pushViewController:RechargeRecord animated:YES];
}
@end
