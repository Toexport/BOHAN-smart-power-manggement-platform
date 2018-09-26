//
//  DeviceDetailListViewController.m
//  Bohan
//
//  Created by Yang Lin on 2018/1/9.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import "DeviceDetailListViewController.h"
#import "DeviceDetailListCell.h"
#import "DeviceDetailMutableListCell.h"
#import "UIScrollView+Refresh.h"
#import "DeviceModel.h"
#import "DeviceInfoViewController.h"
#import "NSTimer+Action.h"
#import "DebuggingANDPublishing.pch"
#import "UIViewController+NavigationBar.h"
static const CGFloat SHAREBTNHIGHT = 50;

@interface DeviceDetailListViewController ()<UITableViewDelegate, UITableViewDataSource, NoDataViewDelegate, DeviceDetailListCellDelegate, DeviceDetailMutableListCellDelegate> {
    BOOL shouldNotUpdate;
}
@property (nonatomic,strong)UITableView *table;
@property (nonatomic, strong) NSMutableArray *datas; // 所有设备列表
@property (nonatomic, strong) NSMutableArray * online; // 在线设备
@property (nonatomic, strong) NSMutableArray * offline; // 不在线设备数组
@property (nonatomic, strong) NSMutableArray * idArray; // 不在线设备数组
@property (nonatomic, strong) NSMutableArray * lastArray; // 不在线设备数组
@property (nonatomic, strong) NSMutableArray * lisArr;
@property (nonatomic, strong) NSString * sort;

@property (nonatomic, strong) NSArray *status;
@property (nonatomic, weak) NSTimer *timer;

@end

static NSString *deviceDetailCellIdentifier = @"DeviceDetailListCell";
static NSString *deviceDetailMutableCellIdentifier = @"DeviceDetailMutableListCell";



@implementation DeviceDetailListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = Localize(self.name);
    self.datas = [NSMutableArray array]; // 所有
    [self rightBarTitle:Localize(@"编辑") action:@selector(editAction:)];
    _status = [NSArray array];
    [self.view addSubview:self.table];
    [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(@0);
    }];
    [self.view startLoading];
    [self loadData];
    MyWeakSelf
    self.timer = [NSTimer scheduledTimerWithTimeInterval:8 block:^{ // 列表设置8秒自动刷新
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf deviceStatus];
    } repeats:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [_timer pauseTimer];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_timer resumeTimerAfterTimeInterval:0.02];
    [self loadData];
}

- (void)dealloc {
    [self removeTimer];
}

//移除定时器
- (void)removeTimer {
    if (_timer == nil) return;
    [_timer invalidate];
    _timer = nil;
}

- (void)loadData {
    NSString *key = self.isPos?@"PosName":@"LoadName";
    [[NetworkRequest sharedInstance] requestWithUrl:GET_DEVICE_LIST_URL parameter:@{key:self.name} completion:^(id response, NSError *error) {
        [self.view stopLoading];
        
        if (!error) {
            self.datas = [[NSArray yy_modelArrayWithClass:[DeviceModel class] json:response[@"content"]] mutableCopy];
            
            for (DeviceModel *model in self.datas) {
                
                for (NSString *content in _status) {
                    if ([content hasPrefix:model.id]) {
                        model.powerinfo = [content substringFromIndex:model.id.length];
                        model.isOpen = [model.powerinfo isOn];
                    }
                }
            }
            
            if (self.datas.count == 0) {
                self.table.noDataTitle = Localize(@"暂无数据");
                self.table.noDataDetail = Localize(@"过会再来吧");
            }
        }else {
            self.table.noDataTitle = error.localizedDescription;
            self.table.noDataDetail = Localize(@"请稍后再试吧！");
        }
        
        [self.table changeState];
        [self.table reloadData];
        [self.table noDataReload];
    }];
}

- (void)deviceStatus {
    WebSocket *socket = [WebSocket socketManager];
    CommandModel *model = [[CommandModel alloc] init];
    model.command = @"1001";
    model.content = USERNAME;
    MyWeakSelf
    [socket sendMultiDataWithModel:model resultBlock:^(id response, NSError *error) {
        if (shouldNotUpdate) {
            shouldNotUpdate = NO;
            return ;
        }
        weakSelf.online = [NSMutableArray array]; // 在线设备
        weakSelf.offline = [NSMutableArray array]; // 不在线
        weakSelf.idArray = [[NSMutableArray alloc]init];
        ZPLog(@"--------%@",response);
        weakSelf.status = [response componentsSeparatedByString:@","];
        for (DeviceModel *model in self.datas) {
            for (NSString *content in _status) {
                if ([content hasPrefix:model.id]) {
                    model.powerinfo = [content substringFromIndex:model.id.length];
                    model.isOpen = [model.powerinfo isOn];
                    ZPLog(@"在线长度---%@",model.powerinfo);
                    if (model.powerinfo && model.powerinfo.length>0) {
                        ZPLog(@"%@,在线",model.powerinfo);
                        ZPLog(@"%@",model.powerinfo);
                        [weakSelf.idArray addObject:model.id];
                        [weakSelf.online addObject:model];
                    }
                }
            }
        }
        
        for (DeviceModel * model in weakSelf.datas) {
            if (![weakSelf.idArray containsObject:model.id]) {
                model.isOpen = [model.powerinfo isOn];
                [weakSelf.offline addObject:model];
            }
        }
        [weakSelf.table reloadData];
    }];
}

- (UITableView *)table {
    if (!_table) {
        _table = [[UITableView alloc] init];
        [_table registerNib:[UINib nibWithNibName:@"DeviceDetailListCell" bundle:nil] forCellReuseIdentifier:deviceDetailCellIdentifier];
        [_table registerNib:[UINib nibWithNibName:@"DeviceDetailMutableListCell" bundle:nil] forCellReuseIdentifier:deviceDetailMutableCellIdentifier];
        
        [_table setBackgroundColor:kBackBackroundColor];
        _table.tableFooterView = [[UIView alloc] init];
        _table.separatorInsetZero = YES;
        _table.noDatadelegate = self;
        _table.delegate = self;
        _table.dataSource = self;
        _table.rowHeight = 120;
        MyWeakSelf
        _table.loadBlock = ^{
            MyStrongSelf
            [strongSelf  loadData];
            [strongSelf  deviceStatus];
            
        };
        [_table shouldRefresh:YES shouldPage:NO];
    }
    return _table;
}

#pragma mark - UITableView
// 分组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (section == 0) {
        //   在线数据;
        return self.online.count;
    }else {
        //   离线的数据
        return self.offline.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        //        在线数据
        DeviceModel *model = self.online[indexPath.row];
        if([model.id hasPrefix:@"61"] || [model.id hasPrefix:@"62"] || [model.id hasPrefix:@"63"]) {
            DeviceDetailMutableListCell * cell = (DeviceDetailMutableListCell*)[tableView dequeueReusableCellWithIdentifier:deviceDetailMutableCellIdentifier];
            cell.delegate = self;
            cell.indexPath = indexPath;
            [cell setModel:model];
            return cell;
        }else {
            DeviceDetailListCell * cell = (DeviceDetailListCell*)[tableView dequeueReusableCellWithIdentifier:deviceDetailCellIdentifier];
            cell.delegate = self;
            cell.indexPath = indexPath;
            [cell setModel:model];
            return cell;
        }
    } else {
        //        不在线
        DeviceModel * model = self.offline[indexPath.row];
        if([model.id hasPrefix:@"61"] || [model.id hasPrefix:@"62"] || [model.id hasPrefix:@"63"]) {
            DeviceDetailMutableListCell * cell = (DeviceDetailMutableListCell*)[tableView dequeueReusableCellWithIdentifier:deviceDetailMutableCellIdentifier];
            cell.delegate = self;
            cell.indexPath = indexPath;
            [cell setModel:model];
            return cell;
            //        这个是两个cell，一个是三个按钮，一个是一个按钮
        }else {
            DeviceDetailListCell *cell = (DeviceDetailListCell*)[tableView dequeueReusableCellWithIdentifier:deviceDetailCellIdentifier];
            cell.delegate = self;
            cell.indexPath = indexPath;
            [cell setModel:model];
            return cell;
        }
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

#pragma mark 按钮的点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
        DeviceInfoViewController * info = [[DeviceInfoViewController alloc] init];
        DeviceModel *model = self.online[indexPath.row];
        info.model = model;
        info.sortt = model.sort;
        info.type = model.id;
        [self.navigationController pushViewController:info animated:YES]; // 设备离线不跳转
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];  // 隐藏返回按钮上的文字
        return;
    }else {
        [HintView showHint:Localize(@"当前设备离线不可控制")];
    }
}


#pragma mark - NoDataViewDelegate
- (void)reloadDidClick {
    [self loadData];
    [self deviceStatus];
}

- (BOOL)shouldShowNoDataView {
    if (self.datas.count == 0) { // 默认
        return YES;
    }
    return NO;
}

#pragma mark - DeviceDetailListCellDelegate
- (void)didSwitchOpen:(BOOL)isOpen withIndexPath:(NSIndexPath *)indexPath {
    shouldNotUpdate = YES;
    DeviceModel *model = self.online[indexPath.row];
    WebSocket *socket = [WebSocket socketManager];
    CommandModel *command = [[CommandModel alloc] init];
    command.command = @"0013";
    command.deviceNo = model.id;
    command.content = isOpen?@"00":@"01";
    MyWeakSelf
    [socket sendSingleDataWithModel:command resultBlock:^(id response, NSError *error) {
        ZPLog(@"--------%@",response);
        if (!error) {
            //******注意：开启成功后，需要重新取实时数据*******
            [HintView showHint:isOpen?Localize(@"已开启"):Localize(@"已关闭")];
            if (isOpen) {
                if (model.powerinfo.length>0) {
                    model.powerinfo = [NSString stringWithFormat:@"0007%@",[model.powerinfo substringFromIndex:4]];
                }
            }else {
                if (model.powerinfo.length>0) {
                    model.powerinfo = @"0105000000";
                }
            }
            model.isOpen = isOpen;
            [weakSelf.table reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }else {
            shouldNotUpdate = NO;
            [HintView showHint:error.localizedDescription];
            model.isOpen = !isOpen;
            
            [weakSelf.table reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    }];
}

- (void)didSwitchOpen:(BOOL)isOpen switchCode:(NSString *)code withIndexPath:(NSIndexPath *)indexPath {
    shouldNotUpdate = YES;
    DeviceModel *model = self.online[indexPath.row];
    WebSocket *socket = [WebSocket socketManager];
    CommandModel *command = [[CommandModel alloc] init];
    command.command = @"0013";
    command.deviceNo = model.id;
    command.content = code;
    MyWeakSelf
    [socket sendSingleDataWithModel:command resultBlock:^(id response, NSError *error) {
        ZPLog(@"--------%@",response);
        if (!error) {
            //******注意：开启成功后，需要重新取实时数据*******
            [HintView showHint:isOpen?Localize(@"已开启"):Localize(@"已关闭")];
            if (model.powerinfo.length>0) {
                model.powerinfo = [NSString stringWithFormat:@"%@%@",code,[model.powerinfo substringFromIndex:2]];
            }
            [weakSelf.table reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }else {
            shouldNotUpdate = NO;
            [HintView showHint:error.localizedDescription];
            [weakSelf.table reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    }];
}

//tableview 排序
- (void)editAction:(UIBarButtonItem *)btn {
    CGFloat origalY;
    if ([btn.title isEqualToString:Localize(@"取消")]) {
        btn.title = Localize(@"编辑");
        [self.table setEditing:NO animated:YES];
        origalY = ScreenHeight - kTabBarHeight;
    }else {
        btn.title = Localize(@"取消");
        btn.image = nil;
        [self.table setEditing:YES animated:YES];
        origalY = ScreenHeight - kTabBarHeight - SHAREBTNHIGHT;
    }
    [self.table reloadData];
    
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    [_lisArr exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
}

@end
