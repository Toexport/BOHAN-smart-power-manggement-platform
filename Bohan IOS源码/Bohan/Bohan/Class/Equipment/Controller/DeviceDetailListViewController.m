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
@interface DeviceDetailListViewController ()<UITableViewDelegate, UITableViewDataSource, NoDataViewDelegate, DeviceDetailListCellDelegate, DeviceDetailMutableListCellDelegate> {
    //    dispatch_semaphore_t finished;
    BOOL shouldNotUpdate;
}
@property (nonatomic,strong)UITableView *table;
@property (nonatomic, strong) NSMutableArray *datas; // 所有设备列表
@property (nonatomic, strong) NSMutableArray * online; // 在线设备
@property (nonatomic, strong) NSMutableArray * offline; // 不在线设备数组
@property (nonatomic, strong) NSMutableArray * idArray; // 不在线设备数组
@property (nonatomic, strong) NSMutableArray * lastArray; // 不在线设备数组
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
    
    _status = [NSArray array];
    [self.view addSubview:self.table];
    //    finished = dispatch_semaphore_create(0);
    [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(@0);
    }];
    
    [self.view startLoading];
    [self loadData];
    //[self deviceStatus];
    
    
    MyWeakSelf
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5 block:^{
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf deviceStatus];
    } repeats:YES];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
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
- (void)removeTimer
{
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
            
            if (!_lastArray) {
                _sort = model.sort;
                [self GetsTheLastWriteTime];
            } else {
                if (![_sort isEqualToString:model.sort]) {
                    [self resetDevice];
                }
            }
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
//    if (self.idArray.count == 0) {
        return YES;
    }
    return NO;
}

#pragma mark - DeviceDetailListCellDelegate
- (void)didSwitchOpen:(BOOL)isOpen withIndexPath:(NSIndexPath *)indexPath {
    shouldNotUpdate = YES;
//    DeviceModel *model = self.datas[indexPath.row];
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
    
//    [self resetDevice];
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
            //            model.isOpen = isOpen;
            [weakSelf.table reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//            [self resetDevice];
        }else {
            [self resetDevice];
            shouldNotUpdate = NO;
            [HintView showHint:error.localizedDescription];
            //            model.isOpen = !isOpen;
            [weakSelf.table reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    }];
}

- (void)resetDevice {
    DeviceModel *model = self.datas.firstObject;
    if (model) {
        WebSocket *socket = [WebSocket socketManager];
        CommandModel *command = [[CommandModel alloc] init];
        command.command = @"002C";
        command.deviceNo = model.id;
        NSMutableString *str = [NSMutableString string];
        for (int i=0; i<_lastArray.count; i++) {
            NSString *s = _lastArray[i];
            [str appendFormat:@"%@FF",s];
        }
        command.content = str;
        [self.view startLoading];
        MyWeakSelf
        [socket sendSingleDataWithModel:command resultBlock:^(id response, NSError *error) {
            [weakSelf.view stopLoading];
//            if (!error) {
//            }else {
//                [HintView showHint:error.localizedDescription];// 后台返回的提示
//            }
        }];
    }
}

// 获取上次写入时间
- (void)GetsTheLastWriteTime {
    DeviceModel *model1 = self.datas.firstObject;
    WebSocket *socket = [WebSocket socketManager];
    CommandModel *model = [[CommandModel alloc] init];
    model.command = @"002D";
    model.deviceNo = model1.id;
    [self.view startLoading];
    _lastArray = [NSMutableArray array];
    MyWeakSelf
    //不一样就显示，一样就隐藏
    //问题是手动或者App内点击关闭按钮，定时界面不会显示设置在执行开启的提示，但是我手动或者App内点击开启设备，定时界面会显示设置正在执行关闭
    //要求就是手动或者App内点击开启关闭，都不显示提示文字.只有点击定时开启或者关闭才显示，如果在定时中按到了开关，定时界面提示不再显示
    [socket sendSingleDataWithModel:model resultBlock:^(id response, NSError *error) {
        [weakSelf.view stopLoading];
        ZPLog(@"--------%@",response);
        if (!error) {
            
            NSString * SituationStr = [response substringWithRange:NSMakeRange(24, 10)];
            NSString * SituationStr2 = [response substringWithRange:NSMakeRange(36, 10)];
            NSString * SituationStr3 = [response substringWithRange:NSMakeRange(48, 10)];
            [_lastArray addObject:SituationStr];
            [_lastArray addObject:SituationStr2];
            [_lastArray addObject:SituationStr3];
//        }else {
//            [HintView showHint:error.localizedDescription];// 后台返回的提示
        }
    }];
}

@end
