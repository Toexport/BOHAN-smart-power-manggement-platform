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
@interface DetailsViewController ()

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = Localize(@"扫码");
}

// 扫描
- (IBAction)ScanningBUt:(UIButton *)sender {
    DetailsPayController * deta = [[DetailsPayController alloc]init];
    [self.navigationController pushViewController:deta animated:YES];
//    ScanViewController *scan = [[ScanViewController alloc] init];
//    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//        NSLog(@"设备具备相机");
//        scan.type = 2;
//        [self.navigationController pushViewController:scan animated:YES];
//        
//    }else {
//        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"您的设备暂时不支持扫码", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil, nil];
//        [alert show];
//        ZPLog(@"没有摄像");
//    }
}

// 我的
- (IBAction)MyBUt:(UIButton *)sender {
    MyAccountViewController * MyAccount = [[MyAccountViewController alloc]init];
    [self.navigationController pushViewController:MyAccount animated:YES];
    MyAccount.deviceId = self.deviceNo;
}

@end
