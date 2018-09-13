//
//  DetailsViewController.m
//  Bohan
//
//  Created by summer on 2018/9/4.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import "DetailsViewController.h"
#import "MyAccountViewController.h"
#import "ScanViewController.h"
#import "DebuggingANDPublishing.pch"
#import "PrefixHeader.pch"
#import "DetailsPayController.h"
#import "MyAccountViewController.h"
#import "ChargingStatusController.h"
@interface DetailsViewController ()

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = Localize(@"付费充电");
//    ChargingStatusController * ChargingStatus = [[ChargingStatusController alloc]init];
//    [self presentViewController:ChargingStatus animated:YES completion:nil];
}

// 扫描
- (IBAction)ScanningBUt:(UIButton *)sender {
//    DetailsPayController *  DetailsPay = [[DetailsPayController alloc]init];
//    DetailsPay.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController: DetailsPay animated:YES];
    ScanViewController *ScanView = [[ScanViewController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSLog(@"设备具备相机");
        ScanView.type = 2;
    ScanView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:ScanView animated:YES];
    }else {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"您的设备暂时不支持扫码", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil, nil];
        [alert show];
        ZPLog(@"没有摄像");
    }
}

// 我的
- (IBAction)MyBUt:(UIButton *)sender {
    MyAccountViewController * MyAccount = [[MyAccountViewController alloc]init];
    //        gestures.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    //        gestures.view.backgroundColor = [UIColor colorWithRed:5/255.0 green:20/255.0 blue:36/255.0 alpha:0.9];
    MyAccount.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController: MyAccount animated:YES];
    
}

@end
