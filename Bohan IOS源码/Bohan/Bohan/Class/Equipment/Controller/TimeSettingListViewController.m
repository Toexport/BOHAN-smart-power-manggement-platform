//
//  TimeSettingListViewController.m
//  Bohan
//
//  Created by Yang Lin on 2018/1/17.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import "TimeSettingListViewController.h"
#import "UIScrollView+Refresh.h"
#import "TimeListTableViewCell.h"
#import "UIViewController+NavigationBar.h"
#import "TimeSelectViewController.h"
#import "TimeSettingModel.h"
#import "DebuggingANDPublishing.pch"
@interface TimeSettingListViewController ()<UITableViewDelegate, UITableViewDataSource> {
    NSDateFormatter *formatter;
}
@property (nonatomic, strong) UITableView *mainTable;
@property(nonatomic,strong)UIButton *bottomView;

@end

static NSString *timeCellIdentifier = @"TimeListTableViewCell";

@implementation TimeSettingListViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = Localize(@"时段设置");
    [self rightBarTitle:Localize(@"确定") color:[UIColor whiteColor] action:@selector(openAction)];
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    [self.view addSubview:self.mainTable];
    [_mainTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(@0);
    }];
    [self loadData];
}

- (void)changeModel:(NSString *)content {
    
    WebSocket * socket = [WebSocket socketManager];
    CommandModel * model = [[CommandModel alloc] init];
    model.command = @"0009";
    model.deviceNo = self.deviceNo;
    model.content = content;
    [self.view startLoading];
    MyWeakSelf
    [socket sendSingleDataWithModel:model resultBlock:^(id response, NSError *error) {
        [weakSelf.view stopLoading];
        if (!error) {
            [HintView showHint:Localize(@"操作成功")];
            [[NSNotificationCenter defaultCenter] postNotificationName:CHANGETIMEMODEL object:@""];
        }else {
            [HintView showHint:error.localizedDescription];
        }
    }];
}

// 获取数据
- (void)loadData {
    WebSocket * socket = [WebSocket socketManager];
    CommandModel * model = [[CommandModel alloc] init];
    model.command = @"0008";
    model.deviceNo = self.deviceNo;
    [self.view startLoading];
    MyWeakSelf
    [socket sendSingleDataWithModel:model resultBlock:^(id response, NSError *error) {
        [weakSelf.view stopLoading];
        if (!error) {
             NSString * Power = [response substringWithRange:NSMakeRange(52, 2)];
            ZPLog(@"%@",Power);

        }else {
            [HintView showHint:Localize(@"加载数据失败")];
        }
        ZPLog(@"--------%@",response);
    }];
}


- (void)openAction {
    NSString *contentStr = @"";
    BOOL isClose = YES;
    for (TimeSettingModel *model in self.datas) {
        NSString *week = [Utils getBinaryByHex:model.week];
        
        if (model.open) {
            isClose = NO;
            if (![[formatter dateFromString:model.endTime] isLaterThanDate:[formatter dateFromString:model.startTime]] &&
                !([[formatter dateFromString:model.startTime] isLaterThanDate:[formatter dateFromString:@"11:59"]]&&
                  [model.endTime isEqualToString:@"00:00"])) {
                    [HintView showHint:Localize(@"结束时间必须大于开始时间")];
                    return;
                }
            if ([[week substringFromIndex:1] isEqualToString:@"0000000"]) {
                [HintView showHint:Localize(@"请设置星期")];
                return;
            }
        }
        NSString *item = [model.startTime stringByReplacingOccurrencesOfString:@":" withString:@""];
        item = [item stringByAppendingString:[model.endTime stringByReplacingOccurrencesOfString:@":" withString:@""]];
        if (self.isParentModel) {
            week = [week stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:model.open?@"1":@"0"];
            model.week = [Utils getHexByBinary:week];
        }
        item = [item stringByAppendingString:model.week];
        contentStr = [contentStr stringByAppendingString:item];
    }

    if (isClose) {
        [self cancel];
    }else {
        [self changeModel:contentStr];
    }
}

//全部关闭则取消时段设置
- (void)cancel {
    [CommonOperation cancelDeviceRunModel:self.deviceNo result:^(id response, NSError *error) {
        if (!error) {
            [HintView showHint:Localize(@"操作成功")];
            [[NSNotificationCenter defaultCenter] postNotificationName:CHANGETIMEMODEL object:nil];
        }else {
            [HintView showHint:error.localizedDescription];
        }
        
    }];
}

- (UITableView *)mainTable {
    if (!_mainTable) {
        _mainTable = [[UITableView alloc] init];
        [_mainTable registerNib:[UINib nibWithNibName:@"TimeListTableViewCell" bundle:nil] forCellReuseIdentifier:timeCellIdentifier];
        _mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_mainTable setBackgroundColor:kBackBackroundColor];
        _mainTable.delegate = self;
        _mainTable.dataSource = self;
        _mainTable.rowHeight = 100;
        UIView * header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 5)];
        UIView * footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 5)];
        _mainTable.tableHeaderView = header;
        _mainTable.tableFooterView = footer;
        [_mainTable shouldRefresh:NO shouldPage:NO];
    }
    return _mainTable;
}

- (UIButton *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIButton alloc] initWithFrame:CGRectMake(0, ScreenHeight - kTabBarHeight, ScreenWidth, 60)];
        [_bottomView setTitle:Localize(@"确认修改") forState:UIControlStateNormal];
        [_bottomView setBackgroundColor:[UIColor whiteColor]];
        [_bottomView.titleLabel setFont:Font(15)];
        [_bottomView setTitleColor:kTextColor forState:UIControlStateNormal];
        [_bottomView addTarget:self action:@selector(updateAction) forControlEvents:UIControlEventTouchUpInside];
        _bottomView.layer.shadowColor = [UIColor getColor:@"f2f2f2"].CGColor;
        _bottomView.layer.shadowOffset = CGSizeMake(0.0f, -1.0f);
        _bottomView.layer.shadowOpacity = 1.0f;
    }
    return _bottomView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TimeListTableViewCell  *cell = (TimeListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:timeCellIdentifier];
    [cell setModel:self.datas[indexPath.row]];
    return cell;
}

#pragma mark 按钮的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    TimeSelectViewController *select = [[TimeSelectViewController alloc] init];
    select.model = self.datas[indexPath.row];
    MyWeakSelf
    select.timeBlock = ^(TimeSettingModel *model) {
        
        [weakSelf.datas replaceObjectAtIndex:indexPath.row withObject:model];
        [tableView reloadData];
    };
    [self.navigationController pushViewController:select animated:YES];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];  // 隐藏返回按钮上的文字
}


@end
