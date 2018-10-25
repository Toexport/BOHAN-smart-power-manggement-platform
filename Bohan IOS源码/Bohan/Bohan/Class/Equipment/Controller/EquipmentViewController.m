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
//IP地址需求库
#import <sys/socket.h>
#import <sys/sockio.h>
#import <sys/ioctl.h>
#import <net/if.h>
#import <arpa/inet.h>


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
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];  // 隐藏返回按钮上的文字
}

//  生命周期
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadData];
//    [self deviceWANIPAddress];
//    [self getDeviceIPAddresses];
//    [self testS];
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
            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];  // 隐藏返回按钮上的文字
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

- (void)testS {
    WebSocket *socket = [WebSocket socketManager];
    CommandModel *command = [[CommandModel alloc] init];
    command.command = @"+RECV:0,E7661801090006000100008F0D";
    [socket sendMultiDataWithModel:command resultBlock:^(id response, NSError *error) {
        ZPLog(@"--------%@",response);
        if (!error) {
        }else {
            [HintView showHint: error.localizedDescription];// 后台返回的提示
        }
    }];

}

//获取设备IP地址
-(NSString *)getDeviceIPAddresses {
    int sockfd = socket(AF_INET,SOCK_DGRAM, 0);
    // if (sockfd <</span> 0) return nil; //这句报错，由于转载的，不太懂，注释掉无影响，懂的大神欢迎指导
    NSMutableArray *ips = [NSMutableArray array];
    
    int BUFFERSIZE =4096;
    
    struct ifconf ifc;
    
    char buffer[BUFFERSIZE], *ptr, lastname[IFNAMSIZ], *cptr;
    
    struct ifreq *ifr, ifrcopy;
    
    ifc.ifc_len = BUFFERSIZE;
    
    ifc.ifc_buf = buffer;
    
    if (ioctl(sockfd,SIOCGIFCONF, &ifc) >= 0){
        
        for (ptr = buffer; ptr < buffer + ifc.ifc_len; ){
            
            ifr = (struct ifreq *)ptr;
            
            int len =sizeof(struct sockaddr);
            
            if (ifr->ifr_addr.sa_len > len) {
                len = ifr->ifr_addr.sa_len;
            }
            
            ptr += sizeof(ifr->ifr_name) + len;
            
            if (ifr->ifr_addr.sa_family !=AF_INET) continue;
            
            if ((cptr = (char *)strchr(ifr->ifr_name,':')) != NULL) *cptr =0;
            
            if (strncmp(lastname, ifr->ifr_name,IFNAMSIZ) == 0)continue;
            
            memcpy(lastname, ifr->ifr_name,IFNAMSIZ);
            
            ifrcopy = *ifr;
            
            ioctl(sockfd,SIOCGIFFLAGS, &ifrcopy);
            
            if ((ifrcopy.ifr_flags &IFF_UP) == 0)continue;
            NSString *ip = [NSString stringWithFormat:@"%s",inet_ntoa(((struct sockaddr_in *)&ifr->ifr_addr)->sin_addr)];
            [ips addObject:ip];
        }
    }
    close(sockfd);
    
    NSString *deviceIP =@"";
    for (int i=0; i < ips.count; i++){
        if (ips.count >0){
            deviceIP = [NSString stringWithFormat:@"%@",ips.lastObject];
        }
    }
    return deviceIP;
//    192.168.3.225
}


// 查询外网ip
-(NSString *)deviceWANIPAddress {
    NSURL *ipURL = [NSURL URLWithString:@"http://ip.taobao.com/service/getIpInfo.php?ip=myip"];
    NSData *data = [NSData dataWithContentsOfURL:ipURL];
    NSDictionary *ipDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil]; 
    NSString *ipStr = nil;
    if (ipDic && [ipDic[@"code"] integerValue] == 0) { //获取成功
        ipStr = ipDic[@"data"][@"ip"];
        ZPLog(@"%@",ipStr);
    }
    return (ipStr ? ipStr : @"");
}


@end
