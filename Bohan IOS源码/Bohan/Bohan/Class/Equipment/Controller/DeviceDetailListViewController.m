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
@interface DeviceDetailListViewController ()<UITableViewDelegate, UITableViewDataSource, NoDataViewDelegate, DeviceDetailListCellDelegate, DeviceDetailMutableListCellDelegate>
{
//    dispatch_semaphore_t finished;
    
    BOOL shouldNotUpdate;
}
@property (nonatomic,strong)UITableView *table;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) NSArray *status;
@property (nonatomic, weak) NSTimer *timer;

@end

static NSString *deviceDetailCellIdentifier = @"DeviceDetailListCell";
static NSString *deviceDetailMutableCellIdentifier = @"DeviceDetailMutableListCell";



@implementation DeviceDetailListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = Localize(self.name);
    self.datas = [NSMutableArray array];
    _status = [NSArray array];
    [self.view addSubview:self.table];
//    finished = dispatch_semaphore_create(0);
    [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(@0);
    }];
    
    [self.view startLoading];
    
    [self loadData];
    [self deviceStatus];

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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_timer resumeTimerAfterTimeInterval:0.5];
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)dealloc
{
    [self removeTimer];
}


//移除定时器
- (void)removeTimer
{
    if (_timer == nil) return;
    [_timer invalidate];
    _timer = nil;
}


- (void)loadData
{
    
    NSString *key = self.isPos?@"PosName":@"LoadName";

    [[NetworkRequest sharedInstance] requestWithUrl:GET_DEVICE_LIST_URL parameter:@{key:self.name} completion:^(id response, NSError *error) {
        
        
        dispatch_async(dispatch_queue_create(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                [self.view stopLoading];
                
                ZPLog(@"%@",response);
                
                
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
                }else
                {
                    self.table.noDataTitle = error.localizedDescription;
                    self.table.noDataDetail = Localize(@"请稍后再试吧！");
                }
                
                [self.table changeState];
                [self.table reloadData];
                [self.table noDataReload];

                
            });
            
        });
        
    }];
}

- (void)deviceStatus
{
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
        ZPLog(@"--------%@",response);
        
        weakSelf.status = [response componentsSeparatedByString:@","];
        for (DeviceModel *model in self.datas) {
            
            for (NSString *content in _status) {
                if ([content hasPrefix:model.id]) {
                   
                    model.powerinfo = [content substringFromIndex:model.id.length];
                    model.isOpen = [model.powerinfo isOn];
                }
            }
        }
        
        [self.table reloadData];
//        dispatch_semaphore_signal(finished);
    }];

}


- (UITableView *)table
{
    if (!_table) {
        _table = [[UITableView alloc] init];
        [_table registerNib:[UINib nibWithNibName:@"DeviceDetailListCell" bundle:nil] forCellReuseIdentifier:deviceDetailCellIdentifier];
        [_table registerNib:[UINib nibWithNibName:@"DeviceDetailMutableListCell" bundle:nil] forCellReuseIdentifier:deviceDetailMutableCellIdentifier];
        
        [_table setBackgroundColor:kBackBackroundColor];
        _table.tableFooterView = [[UIView alloc] init];
        _table.separatorInsetZero = YES;
        _table.noDatadelegate = self;
        //        _deviceTable.tintColor = [UIColor getColor:@"dcecfd"];
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
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datas.count;
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DeviceModel *model = self.datas[indexPath.row];
    
    if([model.id hasPrefix:@"61"] || [model.id hasPrefix:@"62"] || [model.id hasPrefix:@"63"])
    {
        DeviceDetailMutableListCell *cell = (DeviceDetailMutableListCell*)[tableView dequeueReusableCellWithIdentifier:deviceDetailMutableCellIdentifier];
        cell.delegate = self;
        cell.indexPath = indexPath;
        [cell setModel:model];
        
        return cell;

    }else
    {
        DeviceDetailListCell *cell = (DeviceDetailListCell*)[tableView dequeueReusableCellWithIdentifier:deviceDetailCellIdentifier];
        cell.delegate = self;
        cell.indexPath = indexPath;
        [cell setModel:model];
        
        return cell;

    }
    
}
#pragma mark 按钮的点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
    if (self.status.count == 0) {
        
        [HintView showHint:Localize(@"当前设备离线不可控制")];
        return;
    }
    DeviceInfoViewController *info = [[DeviceInfoViewController alloc] init];
    DeviceModel *model = self.datas[indexPath.row];
    info.model = model;
    info.sortt = model.sort;
    ZPLog(@"%@",model.sort);
    [self.navigationController pushViewController:info animated:YES];
}



#pragma mark - NoDataViewDelegate
- (void)reloadDidClick
{
    [self loadData];
    [self deviceStatus];
}

- (BOOL)shouldShowNoDataView
{
    if (self.datas.count == 0) {
        return YES;
    }
    return NO;
}


#pragma mark - DeviceDetailListCellDelegate

- (void)didSwitchOpen:(BOOL)isOpen withIndexPath:(NSIndexPath *)indexPath
{
    shouldNotUpdate = YES;

    DeviceModel *model = self.datas[indexPath.row];
    
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
                
            }else
            {
                if (model.powerinfo.length>0) {
                    model.powerinfo = @"0105000000";
                }
            }
            model.isOpen = isOpen;
            [weakSelf.table reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];


        }else
        {
            shouldNotUpdate = NO;
            [HintView showHint:error.localizedDescription];
            model.isOpen = !isOpen;
            
            [weakSelf.table reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    }];

}

- (void)didSwitchOpen:(BOOL)isOpen switchCode:(NSString *)code withIndexPath:(NSIndexPath *)indexPath
{
    shouldNotUpdate = YES;
    
    DeviceModel *model = self.datas[indexPath.row];
    
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
            
            
        }else
        {
            shouldNotUpdate = NO;
            [HintView showHint:error.localizedDescription];
//            model.isOpen = !isOpen;
            
            [weakSelf.table reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    }];

}

@end
