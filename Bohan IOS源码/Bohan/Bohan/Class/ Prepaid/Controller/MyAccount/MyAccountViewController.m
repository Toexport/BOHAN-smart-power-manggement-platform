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
@interface MyAccountViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation MyAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = Localize(@"我的账户");
    [self Registered];
}
//- (void) gesturesPassword {
//    gesturesPasswordController * gesturesPassword = [[gesturesPasswordController alloc]init];
//    
//}
// 注册Cell
- (void)Registered {
    self.TitleLabel.text = USERNAME;
    [self.Tableview registerNib:[UINib nibWithNibName:@"MyAccountTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyAccountTableViewCell"];
    [self.Tableview registerNib:[UINib nibWithNibName:@"AccountsPrepaidTableViewCell" bundle:nil] forCellReuseIdentifier:@"AccountsPrepaidTableViewCell"];
    [self.Tableview registerNib:[UINib nibWithNibName:@"PrepaidRecordsTableViewCell" bundle:nil] forCellReuseIdentifier:@"PrepaidRecordsTableViewCell"];
    [self.Tableview registerNib:[UINib nibWithNibName:@"RechargeRecordTableViewCell" bundle:nil] forCellReuseIdentifier:@"RechargeRecordTableViewCell"];
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
    if (indexPath.section == 0) {
        MyAccountTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MyAccountTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;  //取消Cell点击变灰效果、
        return cell;
    }else
        if (indexPath.section == 1) {
            AccountsPrepaidTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"AccountsPrepaidTableViewCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;  //取消Cell点击变灰效果、
            return cell;
        }else
            if (indexPath.section == 2) {
            PrepaidRecordsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PrepaidRecordsTableViewCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;  //取消Cell点击变灰效果、
            return cell;
            }else {
                RechargeRecordTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RechargeRecordTableViewCell"];
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
        return;
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
