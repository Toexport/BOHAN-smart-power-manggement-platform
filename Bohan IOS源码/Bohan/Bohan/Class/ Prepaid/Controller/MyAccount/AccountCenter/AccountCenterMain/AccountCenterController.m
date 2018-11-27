//
//  AccountCenterController.m
//  Bohan
//
//  Created by summer on 2018/9/13.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import "AccountCenterController.h"
#import "AccountCenterCell.h"
#import "RemindTableViewCell.h"
#import "EarningsTableViewCell.h"
#import "AbnormalStatisticsCell.h"
#import "PrefixHeader.pch"
#import "AccountsPrepaidController.h"
#import "WithdrawalsController.h"
//#import "MarqueeView.h"

@interface AccountCenterController () <UITableViewDelegate, UITableViewDataSource>{
    NSTimer * timer;
    UIScrollView * scrollViewText;
    NSString * AmountStr;
}
@property (nonatomic, strong) NSArray * arrData;
//@property (nonatomic, strong) MarqueeView *marqueeView;
@end

@implementation AccountCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = Localize(@"账户信息");
    [self initUI];
    
}

// UI
- (void)initUI {
//     [self.view addSubview:self.marqueeView];
    static NSString *AccountCenter = @"AccountCenterCell";
    static NSString * Remind = @"RemindTableViewCell";
    static NSString * Earnings = @"EarningsTableViewCell";
    static NSString * AbnormalStatistics = @"AbnormalStatisticsCell";
    [self.tableview registerNib:[UINib nibWithNibName:AccountCenter bundle:nil] forCellReuseIdentifier:AccountCenter];
    [self.tableview registerNib:[UINib nibWithNibName:Remind bundle:nil] forCellReuseIdentifier:Remind];
    [self.tableview registerNib:[UINib nibWithNibName:Earnings bundle:nil] forCellReuseIdentifier:Earnings];
    [self.tableview registerNib:[UINib nibWithNibName:AbnormalStatistics bundle:nil] forCellReuseIdentifier:AbnormalStatistics];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;  //隐藏tableview多余的线条
}

//#pragma Lazy Methods
//- (MarqueeView *)marqueeView{
//
//    if (!_marqueeView) {
//        MarqueeView *marqueeView =[[MarqueeView alloc]initWithFrame:CGRectMake(10, 20, 400, 30) withTitle:@[@"1.我觉得封装好好玩",@"2.经常玩玩可以锻炼自己的技术耶",@"3.所以要经常经常玩玩，这样才能更加完美",@"4.你说对不对",@"end"]];
//        marqueeView.titleColor = [UIColor blueColor];
//        marqueeView.titleFont = [UIFont systemFontOfSize:16];
//        marqueeView.backgroundColor = [UIColor yellowColor];
//        __weak MarqueeView *marquee = marqueeView;
//        marqueeView.handlerTitleClickCallBack = ^(NSInteger index){
//
//            NSLog(@"%@----%zd",marquee.titleArr[index-1],index);
//        };
//        _marqueeView = marqueeView;
//    }
//    return _marqueeView;
//
//}

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
        static NSString *AccountCenter = @"AccountCenterCell";
        AccountCenterCell * cell = [tableView dequeueReusableCellWithIdentifier:AccountCenter];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;  //取消Cell点击变灰效果、
        cell.StoredValueBlockBlock = ^(id StoredValueView) {
            ZPLog(@"储值");
            AccountsPrepaidController * AccountsPrepaid = [[AccountsPrepaidController alloc]init];
            [self.navigationController pushViewController:AccountsPrepaid animated:YES];
            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];  // 隐藏返回按钮上的文字
        };
        cell.ExtractBlockBlock = ^(id ExtractView) {
            NSLog(@"提款");
            WithdrawalsController * Withdrawals = [[WithdrawalsController alloc]init];
            AmountStr = cell.PriceLabel.text;
            Withdrawals.AmountStr = [NSString stringWithFormat:@"%@",AmountStr];
            [self.navigationController pushViewController:Withdrawals animated:YES];
            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];  // 隐藏返回按钮上的文字
        };
        return cell;
    }else
       if (indexPath.section == 1) {
        static NSString * Remind = @"RemindTableViewCell";
        RemindTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:Remind];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;  //取消Cell点击变灰效果、
        return cell;
       }else
           if (indexPath.section == 2) {
          static NSString * Earnings = @"EarningsTableViewCell";
           EarningsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:Earnings];
           cell.selectionStyle = UITableViewCellSelectionStyleNone;  //取消Cell点击变灰效果、
           return cell;
           }else {
              static NSString * AbnormalStatistics = @"AbnormalStatisticsCell";
               AbnormalStatisticsCell * cell = [tableView dequeueReusableCellWithIdentifier:AbnormalStatistics];
               cell.selectionStyle = UITableViewCellSelectionStyleNone;  //取消Cell点击变灰效果、
               return cell;
           }
}
// cell的大小
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 175;
    }else
        if (indexPath.section == 1) {
            return 50;
        }else
            if (indexPath.section == 2) {
                return 325;
            }else {
                return 430;
            }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

// cell之间的距离
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return 10;
//}

// cell的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if (indexPath.section == 0) {
//        AccountCenterController * AccountCenter = [[AccountCenterController alloc]init];
//        [self.navigationController pushViewController:AccountCenter animated:YES];
//        //        return;
//    }else
//        if (indexPath.section == 1) {
//            AccountsPrepaidController * AccountsPrepaid = [[AccountsPrepaidController alloc]init];
//            [self.navigationController pushViewController:AccountsPrepaid animated:YES];
//        }else
//            if (indexPath.section == 2) {
//                PrepaidRecordsController * RechargeRecord = [[PrepaidRecordsController alloc]init];
//                [self.navigationController pushViewController:RechargeRecord animated:YES];
//            }else {
//                RechargeRecordController * RechargeRecord = [[RechargeRecordController alloc]init];
//                [self.navigationController pushViewController:RechargeRecord animated:YES];
//            }
}
@end
