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
#import "MyAccountTableViewCell.h"
#import "AccountsPrepaidTableViewCell.h"
#import "PrepaidRecordsTableViewCell.h"
#import "RechargeRecordTableViewCell.h"
#import "PrepaidRecordsController.h"
#import "gesturesPasswordController.h"
#import "AccountCenterController.h"
@interface MyAccountViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation MyAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = Localize(@"我的账户");
    self.TitleLabel.text = USERNAME;
    [self Registered];
}
//- (void) gesturesPassword {
//    gesturesPasswordController * gesturesPassword = [[gesturesPasswordController alloc]init];
//    
//}
// 注册Cell
- (void)Registered {
    static NSString * MyAccount = @"MyAccountTableViewCell";
    static NSString * AccountsPrepaid = @"AccountsPrepaidTableViewCell";
    static NSString * PrepaidRecords = @"PrepaidRecordsTableViewCell";
    static NSString * RechargeRecord = @"RechargeRecordTableViewCell";
    [self.Tableview registerNib:[UINib nibWithNibName:MyAccount bundle:nil] forCellReuseIdentifier:MyAccount];
    [self.Tableview registerNib:[UINib nibWithNibName:AccountsPrepaid bundle:nil] forCellReuseIdentifier:AccountsPrepaid];
    [self.Tableview registerNib:[UINib nibWithNibName:PrepaidRecords bundle:nil] forCellReuseIdentifier:PrepaidRecords];
    [self.Tableview registerNib:[UINib nibWithNibName:RechargeRecord bundle:nil] forCellReuseIdentifier:RechargeRecord];
    self.Tableview.separatorStyle = UITableViewCellSeparatorStyleNone;  //隐藏tableview多余的线条
}

#pragma mark -- tabeView delegate
// cell分组
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
// Cell的个数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * MyAccount = @"MyAccountTableViewCell";
    static NSString * AccountsPrepaid = @"AccountsPrepaidTableViewCell";
    static NSString * PrepaidRecords = @"PrepaidRecordsTableViewCell";
    static NSString * RechargeRecord = @"RechargeRecordTableViewCell";
    if (indexPath.section == 0) {
        MyAccountTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:MyAccount];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;  //取消Cell点击变灰效果、
        return cell;
    }else
        if (indexPath.section == 1) {
            AccountsPrepaidTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:AccountsPrepaid];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;  //取消Cell点击变灰效果、
            return cell;
        }else
            if (indexPath.section == 2) {
            PrepaidRecordsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:PrepaidRecords];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;  //取消Cell点击变灰效果、
            return cell;
            }else {
                RechargeRecordTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:RechargeRecord];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;  //取消Cell点击变灰效果、
                return cell;
            }
}
// cell的大小
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 55;
    }else
        if (indexPath.section == 1) {
            return 55;
        }else
            if (indexPath.section == 2) {
                
                return 55;
            }else {
                
            return 55;
        }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

// cell之间的距离
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 2.0f;
    }else
        if (section == 1) {
            return 2.0f;
        }else
            if (section == 2) {
                return 2.0f;
            }else {
                
            return 2.0f;
        }
}

// cell的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        AccountCenterController * AccountCenter = [[AccountCenterController alloc]init];
        [self.navigationController pushViewController:AccountCenter animated:YES];
//        return;
    }else
        if (indexPath.section == 1) {
            AccountsPrepaidController * AccountsPrepaid = [[AccountsPrepaidController alloc]init];
            [self.navigationController pushViewController:AccountsPrepaid animated:YES];
        }else
             if (indexPath.section == 2) {
            PrepaidRecordsController * RechargeRecord = [[PrepaidRecordsController alloc]init];
            [self.navigationController pushViewController:RechargeRecord animated:YES];
             }else {
                 RechargeRecordController * RechargeRecord = [[RechargeRecordController alloc]init];
                 [self.navigationController pushViewController:RechargeRecord animated:YES];
    }
}
@end
