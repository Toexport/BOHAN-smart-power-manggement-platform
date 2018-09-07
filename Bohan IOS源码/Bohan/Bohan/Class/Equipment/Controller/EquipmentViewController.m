//
//  EquipmentViewController.m
//  Bohan
//
//  Created by Yang Lin on 2017/12/24.
//  Copyright © 2017年 Bohan. All rights reserved.
//

#import "EquipmentViewController.h"
#import "UIViewController+NavigationBar.h"
#import "SliderView.h"
#import "PageCollectionView.h"
#import "TablePageModel.h"
#import "BindingViewController.h"
#import "XMLUtil.h"
#import "DeviceModel.h"
#import "DeviceDetailListViewController.h"
#import "EquipmentTableViewCell.h"
#import "NSBundle+AppLanguageSwitch.h"
#import "DebuggingANDPublishing.pch"
@interface EquipmentViewController ()<NoDataViewDelegate,EquipmentTableViewCellDelegate> {
    NSMutableArray *dataArray;
    NSUInteger currentIndex;
}
@property(nonatomic,strong)SliderView *sliderView;
@property(nonatomic,strong)PageCollectionView *pageCollection;
@end

@implementation EquipmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = Localize(@"设备列表");
    [self rightBarImage:@"qrcode_scan" action:@selector(bindDevice)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageChange) name:AppLanguageDidChangeNotification object:nil];

    dataArray = [NSMutableArray array];

    if (@available(iOS 11.0, *)){
    }else {
        
        self.automaticallyAdjustsScrollViewInsets = NO;
    }    for (int i = 0; i<2; i++) {
        
        TablePageModel * model= [[TablePageModel alloc] init];
        model.datas = [NSMutableArray array];
        model.isload = NO;
        [dataArray addObject:model];
    }

    [self.view addSubview:self.sliderView];
    [self.view addSubview:self.pageCollection];
    [self.pageCollection setDatas:dataArray];

}

- (void)bindDevice {
    BindingViewController *bind = [[BindingViewController alloc] init];
    bind.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:bind animated:YES];
}

//  生命周期
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)loadData {
    TablePageModel *model = dataArray[currentIndex];
    if (model.isload == NO) {
        [model.currentTable startLoading];
    }
    
    NSString *url =currentIndex==0?GET_NAME_LIST_URL:GET_POS_NAME_LIST_URL;
    [[NetworkRequest sharedInstance] requestWithUrl:url parameter:nil completion:^(id response, NSError *error) {
        [model.currentTable stopLoading];
        model.isload = YES;
        model.currentTable.noDatadelegate = self;
        
        ZPLog(@"%@",response);
        if (!error) {
            model.datas = [[response[@"content"] componentsSeparatedByString:@","] mutableCopy];
            if (model.datas.count == 0) {
                model.currentTable.noDataTitle = Localize(@"暂无数据");
                model.currentTable.noDataDetail = Localize(@"过会再来吧");
            }
        }else {
            model.currentTable.noDataTitle = error.localizedDescription;
            model.currentTable.noDataDetail = Localize(@"请稍后再试吧！");
        }
        [self.pageCollection setDatas:dataArray];
        [model.currentTable changeState];
        [model.currentTable noDataReload];
    }];
}

- (void)languageChange {
    self.title = Localize(@"设备列表");
    [_sliderView setDatas:@[Localize(@"名称"), Localize(@"位置")]];
    [self.pageCollection reloadData];
}

- (SliderView *)sliderView {
    if (!_sliderView) {
        _sliderView = [[SliderView alloc] initWithFrame:CGRectMake(0, kTopHeight, ScreenWidth, 45) datas:@[Localize(@"名称"), Localize(@"位置")]];
        [_sliderView setBackgroundColor:kBackBackroundColor];
        MyWeakSelf
        _sliderView.block = ^(NSUInteger index) {
            currentIndex = index;
            [weakSelf loadData];
            [weakSelf.pageCollection setContentOffset:CGPointMake(currentIndex *ScreenWidth, 0) animated:YES];
        };
    }
    return _sliderView;
}

- (PageCollectionView *)pageCollection {
    if (!_pageCollection) {
        _pageCollection = [[PageCollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.sliderView.frame), ScreenWidth, ScreenHeight-CGRectGetMaxY(self.sliderView.frame) - kNavBarHeight) contentClassStr:@"ContentTableView"];
        _pageCollection.actionDelegate = self;
        MyWeakSelf
        _pageCollection.loadBlock = ^(){
        MyStrongSelf
            [strongSelf loadData];
        };
        _pageCollection.indexBlock = ^(NSUInteger index) {
            currentIndex = index;
            [weakSelf loadData];
            [weakSelf.sliderView selectedWithIndex:index];
        };
        _pageCollection.didSelectedBlock = ^(id object) {
            DeviceDetailListViewController *detail = [[DeviceDetailListViewController alloc] init];
            detail.name = (NSString *)object;
            detail.isPos = (currentIndex ==0?NO:YES);
            detail.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:detail animated:YES];
        };
    }
    return _pageCollection;
}

#pragma mark - NoDataViewDelegate
- (void)reloadDidClick {
    [self loadData];
}

- (BOOL)shouldShowNoDataView {
    TablePageModel *model = dataArray[currentIndex];
    if (model.datas.count == 0) {
        return YES;
    }
    return NO;
}

#pragma mark - EquipmentTableViewCellDelegate
- (void)openAndCloseAll:(BOOL)isOpen name:(NSString *)name {
    WebSocket *socket = [WebSocket socketManager];
    CommandModel *command = [[CommandModel alloc] init];
    command.command = @"1002";
//    开关不知道是不是对的，修改的07，原来是01
    NSString * part = @"LoadName";
    NSString * open = isOpen?@"00":@"07";
    if (currentIndex == 1) {
        part = @"PosName";
    }
    command.content = [NSString stringWithFormat:@"%@;%@;%@;%@",USERNAME,part,name,open];
    
    [socket sendMultiDataWithModel:command resultBlock:^(id response, NSError *error) {
        ZPLog(@"--------%@",response);
        if (!error) {
            [HintView showHint:isOpen?Localize(@"已开启"):Localize(@"已关闭")];
        }else {
            [HintView showHint: error.localizedDescription];// 后台返回的提示
        }
    }];
}
@end
