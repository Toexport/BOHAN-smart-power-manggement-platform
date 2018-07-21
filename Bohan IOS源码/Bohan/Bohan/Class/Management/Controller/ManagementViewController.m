//
//  ManagementViewController.m
//  Bohan
//
//  Created by Yang Lin on 2017/12/24.
//  Copyright © 2017年 Bohan. All rights reserved.
//

#import "ManagementViewController.h"
#import "UIScrollView+Refresh.h"
#import "DeviceModel.h"
#import "DeviceTableViewCell.h"
#import "UIViewController+NavigationBar.h"
#import "UpdateDeviceInfoViewController.h"
#import "ShareView.h"
#import "YLSheetView.h"
#import "NSBundle+AppLanguageSwitch.h"
#import "DebuggingANDPublishing.pch"
static const CGFloat SHAREBTNHIGHT = 50;
@interface ManagementViewController ()<UITableViewDelegate, UITableViewDataSource, NoDataViewDelegate>

@property (nonatomic, strong) UITableView *deviceTable;
@property (nonatomic, strong) NSMutableArray *datas;
//@property (nonatomic,strong)UIButton *bottomView;
@property (nonatomic, strong) UIView * ShareView;
@property(nonatomic,strong)ShareView *shareView;

@end
static NSString *deviceCellIdentifier = @"DeviceTableViewCell";

@implementation ManagementViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageChange) name:AppLanguageDidChangeNotification object:nil];

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageChange) name:AppLanguageDidChangeNotification object:nil];

    self.title = Localize(@"设备管理");
    self.datas = [NSMutableArray array];
    [self.view addSubview:self.deviceTable];
    
//    if (@available(iOS 11.0, *)){
//        [self.deviceTable setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
//    }else
//    {
//        self.automaticallyAdjustsScrollViewInsets = NO;
//    }

    
//    self.navigationItem.rightBarButtonItem.enabled = NO;

    [self rightBarImage:@"manage_device_share2" action:@selector(editAction:)];
//    [self.deviceTable mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.bottom.left.right.equalTo(@0);
//    }];
    
    [self.view startLoading];
    [self loadData];
    
}

- (void)languageChange {
    self.title = Localize(@"设备管理");
    [self.deviceTable reloadData];
}

- (void)editAction:(UIBarButtonItem *)btn {
    CGFloat origalY;

    if (!self.ShareView.superview) {
        [self.view addSubview:self.ShareView];
    }

    if ([btn.title isEqualToString:Localize(@"取消")]) {
        
        btn.image = [UIImage imageNamed:@"manage_device_share2"];
        btn.title = @"";
        [self.deviceTable setEditing:NO animated:YES];
        origalY = ScreenHeight - kTabBarHeight;
    }else {
        btn.title = Localize(@"取消");
        btn.image = nil;
        [self.deviceTable setEditing:YES animated:YES];
        origalY = ScreenHeight - kTabBarHeight - SHAREBTNHIGHT;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.ShareView setFrame:CGRectMake(self.ShareView.frame.origin.x, origalY, self.ShareView.frame.size.width, SHAREBTNHIGHT)];
        [self.deviceTable setFrame:CGRectChangeHeight(self.deviceTable.frame, origalY)];
    }];
    [self.deviceTable reloadData];

}

- (void)shareAction {
    
    [[YLSheetView sharedInstace] showFromCenter:self.shareView];
}

//  生命周期
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadData];
}

// 获取当前所有
- (void)loadData {
    
    [[NetworkRequest sharedInstance] requestWithUrl:GET_DEVICE_LIST_URL parameter:nil completion:^(id response, NSError *error) {
        
        [self.view stopLoading];
        
        ZPLog(@"%@",response);
        if (!error) {
            self.datas = [[NSArray yy_modelArrayWithClass:[DeviceModel class] json:response[@"content"]] mutableCopy];

            if (self.datas.count == 0) {
                self.deviceTable.noDataTitle = Localize(@"暂无数据");
                self.deviceTable.noDataDetail = Localize(@"过会再来吧");
            }
        }else {
            self.deviceTable.noDataTitle = error.localizedDescription;
            self.deviceTable.noDataDetail = Localize(@"请稍后再试吧！");
        }
        [self.deviceTable changeState];
        [self.deviceTable reloadData];
        [self.deviceTable noDataReload];

    }];
}

// 分享设备
- (void)shareDeviceWithTel:(NSString *)tel pwd:(NSString *)pwd {
    
    NSMutableArray *devices = [NSMutableArray array];
    for (NSIndexPath *indexPath in _deviceTable.indexPathsForSelectedRows) {
        
        DeviceModel *model = self.datas[indexPath.row];
        [devices addObject:model.id];
        
    }
    NSString *shareDevices = [devices componentsJoinedByString:@","];
    NSDictionary *dic = @{@"deviceCodes":shareDevices,@"mobileNum":tel, @"password":pwd};
    [[NetworkRequest sharedInstance] requestWithUrl:SHARE_DEVICE_URL parameter:dic completion:^(id response, NSError *error) {
        
        [self.view stopLoading];
        ZPLog(@"%@",response);
        if (!error) {
            [HintView showHint:Localize(@"分享成功")];
            [self editAction:self.navigationItem.rightBarButtonItem];
            [[YLSheetView sharedInstace] closeView];
            
        }else {
            [HintView showHint:error.localizedDescription];
        }
        
    }];
}

// 解绑设备
- (void)unBindDeviceAtIndexPath:(NSIndexPath *)indexPath {
    [self.view startLoading];
    
    DeviceModel *model = self.datas[indexPath.row];
    NSDictionary *dic = @{@"DeviceCode":model.id, @"DeviceKey":model.id};
    [[NetworkRequest sharedInstance] requestWithUrl:UNBINDING_DEVICE_URL parameter:dic completion:^(id response, NSError *error) {
        
        [self.view stopLoading];
        //请求成功
        if (!error) {
            [self.datas removeObject:model];
            [self.deviceTable deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            
        }else {
            [HintView showHint:error.localizedDescription];
        }
    }];
}



- (UITableView *)deviceTable {
    if (!_deviceTable) {
        _deviceTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - kTabBarBottom)];
        [_deviceTable registerNib:[UINib nibWithNibName:@"DeviceTableViewCell" bundle:nil] forCellReuseIdentifier:deviceCellIdentifier];
        _deviceTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _deviceTable.allowsMultipleSelection = YES;
        _deviceTable.allowsMultipleSelectionDuringEditing = YES;
        _deviceTable.noDatadelegate = self;
        _deviceTable.delegate = self;
        _deviceTable.dataSource = self;
        _deviceTable.rowHeight = 74;
        MyWeakSelf
        _deviceTable.loadBlock = ^{
            MyStrongSelf
            [strongSelf  loadData];
        };
        UIView * header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 5)];
        UIView * footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 5)];
        _deviceTable.tableHeaderView = header;
        _deviceTable.tableFooterView = footer;

        [_deviceTable shouldRefresh:YES shouldPage:NO];
    }
    
    return _deviceTable;
}


- (UIView *)ShareView { // 看半天，这个继承的是个按钮，靠。
    if (!_ShareView) {
        _ShareView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight - kTabBarHeight, ScreenWidth, SHAREBTNHIGHT)];
        
        _ShareView.layer.shadowColor = [UIColor getColor:@"f2f2f2"].CGColor;
        _ShareView.layer.shadowOffset = CGSizeMake(0.0f, -1.0f);
        _ShareView.layer.shadowOpacity = 1.0f;
        [_ShareView setBackgroundColor:[UIColor whiteColor]];
//        [_bottomView setTitle:Localize(@"分享") forState:UIControlStateNormal];
//        [_bottomView setImage:[UIImage imageNamed:@"manage_device_share"] forState:UIControlStateNormal];
//        [_bottomView.titleLabel setFont:Font(14)];
//        [_bottomView setTitleColor:kTextColor forState:UIControlStateNormal];
//        [_bottomView addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ShareView;
}

- (ShareView *)shareView {
    if (!_shareView) {
        _shareView = [[[NSBundle mainBundle] loadNibNamed:@"ShareView" owner:nil options:nil] lastObject];
        [_shareView setFrame:CGRectMake(20, (ScreenHeight - 370)/2, ScreenWidth - 40, 370)]; // 分享View大小设置
        
        MyWeakSelf
        _shareView.submitBlock = ^(NSString *tel, NSString *pwd) {
            [weakSelf shareDeviceWithTel:tel pwd:pwd];
        };
    }
    
    return _shareView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DeviceTableViewCell  *cell = (DeviceTableViewCell *)[tableView dequeueReusableCellWithIdentifier:deviceCellIdentifier];
    [cell setModel:self.datas[indexPath.row]];
//    cell.selectedBackgroundView.backgroundColor = [UIColor redColor];//[UIColor getColor:@"dcecfd"];
//    cell.multipleSelectionBackgroundView.backgroundColor = [UIColor redColor];
//    if (tableView.isEditing) {
//        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
//    }else
//    {
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
    return cell;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self unBindDeviceAtIndexPath:indexPath];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return Localize(@"删除");
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark 按钮的点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!tableView.isEditing) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        
        UpdateDeviceInfoViewController *update = [[UpdateDeviceInfoViewController alloc] init];
        update.model = self.datas[indexPath.row];
        update.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:update animated:YES];
    }
}


- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {

}



#pragma mark - NoDataViewDelegate
- (void)reloadDidClick {
    [self loadData];
    
//    UpdateDeviceInfoViewController *update = [[UpdateDeviceInfoViewController alloc] init];
//
//    DeviceModel *model = [[DeviceModel alloc] init];
//    model.id = @"681609050658";
//    model.brand = @"2";
//    model.position = @"4";
//    model.name = @"3";
//    update.model = model;
//    update.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:update animated:YES];

}

- (BOOL)shouldShowNoDataView {
    if (self.datas.count == 0) {
        return YES;
    }
    return NO;
}


@end
