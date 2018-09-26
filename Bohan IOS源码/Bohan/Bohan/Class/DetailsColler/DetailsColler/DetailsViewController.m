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
#import "DetailsTableViewCell.h"
#import "EquipmentCell.h"
#import "CostIntroducedCell.h"
@interface DetailsViewController ()<UITableViewDelegate, UITableViewDataSource>

//baidumap //百度地图
//iosamap //高德地图
//comgooglemaps //谷歌地图
//qqmap //腾讯地图



@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = Localize(@"付费充电");
//    ChargingStatusController * ChargingStatus = [[ChargingStatusController alloc]init];
//    [self presentViewController:ChargingStatus animated:YES completion:nil];
    [self.tableview registerNib:[UINib nibWithNibName:@"DetailsTableViewCell" bundle:nil] forCellReuseIdentifier:@"DetailsTableViewCell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"EquipmentCell" bundle:nil] forCellReuseIdentifier:@"EquipmentCell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"CostIntroducedCell" bundle:nil] forCellReuseIdentifier:@"CostIntroducedCell"];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;  //隐藏tableview多余的线条
    self.edgesForExtendedLayout = UIRectEdgeNone; // 设置tabbar底部高度
    
}

//3.设置cell之间headerview的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return 5;
    }else {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        DetailsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DetailsTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;  //取消Cell点击变灰效果、
        cell.NavigationButBlock = ^(id NavigationBut) {
            ZPLog(@"点击了导航按钮");
        };
        cell.CorrectionButBlock = ^(id CorrectionBut) {
            ZPLog(@"点击了纠错按钮");
        };
        return cell;
    }else
        if (indexPath.section == 1) {
            EquipmentCell * cell = [tableView dequeueReusableCellWithIdentifier:@"EquipmentCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;  //取消Cell点击变灰效果、
            return cell;
        }else {
            CostIntroducedCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CostIntroducedCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;  //取消Cell点击变灰效果、
            return cell;
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 125;
    }else
        if (indexPath.section == 1) {
            return 400;
        }else {
            
        return 280;
    }
}

// 扫描
- (IBAction)ScanningBUt:(UIButton *)sender {
//    DetailsPayController *  DetailsPay = [[DetailsPayController alloc]init];
//    DetailsPay.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController: DetailsPay animated:YES];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];  // 隐藏返回按钮上的文字
    ScanViewController *ScanView = [[ScanViewController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSLog(@"设备具备相机");
        ScanView.type = 2;
    ScanView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:ScanView animated:YES];
    }else {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:Localize(@"提示") message:Localize(@"您的设备暂时不支持扫码") delegate:nil cancelButtonTitle:Localize(@"确定") otherButtonTitles:nil, nil];
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
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];  // 隐藏返回按钮上的文字
    
}

@end
