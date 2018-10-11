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
#import "PrefixHeader.pch"
#import "DetailsPayController.h"
#import "MyAccountViewController.h"
#import "ChargingStatusController.h"
#import "DetailsTableViewCell.h"
#import "EquipmentCell.h"
#import "CostIntroducedCell.h"
#import "AppLocationManager.h"

@interface DetailsViewController ()<UITableViewDelegate, UITableViewDataSource> {
    NSString * latStr;
    NSString * linStr;
    NSInteger _selectIndex;
    
}

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
    latStr = @"22.944010";
    linStr = @"113.890100";
//    22.948066, 113.890191
//    [AppLocationManager shareAppLocationManager];
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
//            113.896598,22.954302
            [AppLocationManager jumpToMapWithLat:latStr lng:linStr title:@"伯瀚" content:@"Bohan" VC:self];
        };
        cell.CorrectionButBlock = ^(id CorrectionBut) {
            ZPLog(@"点击了纠错按钮");
        };
        cell.ShareButBlock = ^(id ShareBut) {
            ZPLog(@"点击了分享");
//            [self sendUrl:nil To:WXSceneTimeline];
            [self UMShare];
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
//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];  // 隐藏返回按钮上的文字
    ScanViewController *ScanView = [[ScanViewController alloc] init];
    [ScanView getResultStr:^(NSString *result) {
        if (result && result.length>0) {
            
        }
    }];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSLog(@"设备具备相机");
        ScanView.type = 222;
    ScanView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:ScanView animated:YES];
//        [self presentViewController:ScanView animated:YES completion:nil];
//        UINavigationController * nav = [[UINavigationController alloc]   initWithRootViewController:WebView];
//        [self presentViewController:nav animated:YES completion:nil];
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

// 网页分享
//-(void)sendUrl:(NSString*)url To:(enum WXScene)scene{
//    SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
//    req.bText = NO;
//    req.scene = WXSceneTimeline;// 分享到o朋友圈
//    WXMediaMessage *medMessage = [WXMediaMessage message];
//    medMessage.title = @"伯瀚智能用电管理平台"; // 标题
//    medMessage.description = @"伯瀚智能APP——一款智能、安全用电管理APP";// 描述
//    WXWebpageObject *webPageObj = [WXWebpageObject object];
//    [medMessage setThumbImage:[UIImage imageNamed:@"logo"]];// 缩略图
//    webPageObj.webpageUrl = @"https://itunes.apple.com/cn/app/id1384571471?mt=8";
//    medMessage.mediaObject = webPageObj;
//    req.message = medMessage;
//    [WXApi sendReq:req];
//}

//// 分享
- (void)UMShare {
//    //显示分享面板
    [[XMShare shareManager] showWithController:self];
//    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
//        // 根据获取的platformType确定所选平台进行下一步操作
//    }];
}



@end
