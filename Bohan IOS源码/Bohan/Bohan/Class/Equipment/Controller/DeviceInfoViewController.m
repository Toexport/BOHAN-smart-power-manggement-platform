//
//  DeviceInfoViewController.m
//  Bohan
//
//  Created by Yang Lin on 2018/1/16.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import "DeviceInfoViewController.h"
#import "RealTimeParamViewController.h"
#import "MeteringViewController.h"
#import "TimeSettingViewController.h"
#import "ParamsSettingViewController.h"
#import "CountDownViewController.h"
#import "StatisticsViewController.h"
#import "DeviceModel.h"
#import "DeviceInfoCollectionCell.h"
#import "DebuggingANDPublishing.pch"
#import "MultipleSwitchViewController.h"

#define ItemWidth  (ScreenWidth -1)/2.0
static NSString *const reuseIdentifier = @"DeviceInfoCollectionCell";


@interface DeviceInfoViewController ()
{
    __weak IBOutlet UILabel *status;
    __weak IBOutlet UIImageView *statusImg;
    BOOL isOnline;
    __weak IBOutlet UIButton *refreashBtn;
    __weak IBOutlet UICollectionView *deviceInfoCollection;
    NSArray *datas;
    NSString *electrictyModel;
    NSDateFormatter *formatter;
    
}
@end

@implementation DeviceInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = Localize(@"设备信息");
    [self initUI];
    
    
//    if ([strin containsString:@"68"] || [strin containsString:@"66"]) {
//        datas = @[@{@"image" :@"ic_launch", @"name": Localize(@"实时参数")}, @{@"image" :@"ic_l", @"name": Localize(@"增值服务")}, @{@"image" :@"ic_laun", @"name": Localize(@"定时计量")}, @{@"image" :@"menu_summery", @"name": Localize(@"用电统计")}, @{@"image" :@"ic_launcher2", @"name": Localize(@"时段设置")}, @{@"image" :@"ic_launch1", @"name": Localize(@"延时/定时开关")},];
//        [self loadData];
//    }
    
    formatter = [[NSDateFormatter alloc] init];
    
    refreashBtn.titleLabel.numberOfLines = 2;
    UICollectionViewFlowLayout *lay = [[UICollectionViewFlowLayout alloc] init];
    lay.minimumLineSpacing = 1;
    lay.minimumInteritemSpacing = 1;
    lay.itemSize = CGSizeMake(ItemWidth, 120);
    [deviceInfoCollection setCollectionViewLayout:lay];
    [deviceInfoCollection registerNib:[UINib nibWithNibName:@"DeviceInfoCollectionCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    [deviceInfoCollection setBackgroundColor:kBackBackroundColor];
    [deviceInfoCollection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@(deviceInfoCollection.collectionViewLayout.collectionViewContentSize.height));
        make.width.mas_equalTo(@(ScreenWidth));
    }];
    [deviceInfoCollection reloadData];
    
    [self deviceStatus];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateStauts:) name:CHANGETIMEMODEL object:nil];
}

// UI
- (void)initUI {
    NSString * string = self.model.id;
    NSString * str = [string substringWithRange:NSMakeRange(0, 2)];
    ZPLog(@"%@",str);
    if ([str containsString:@"61"] || [str containsString:@"62"] || [str containsString:@"63"]){
        datas = @[@{@"image" :@"ic_launch", @"name": Localize(@"实时参数")}, @{@"image" :@"ic_l", @"name": Localize(@"增值服务")}, @{@"image" :@"ic_laun", @"name": Localize(@"定时计量")}, @{@"image" :@"menu_summery", @"name": Localize(@"用电统计")}, @{@"image" :@"ic_launch1", @"name": Localize(@"延时/定时开关")}];
    }else {
        datas = @[@{@"image" :@"ic_launch", @"name": Localize(@"实时参数")}, @{@"image" :@"ic_l", @"name": Localize(@"增值服务")}, @{@"image" :@"ic_laun", @"name": Localize(@"定时计量")}, @{@"image" :@"menu_summery", @"name": Localize(@"用电统计")}, @{@"image" :@"ic_launcher2", @"name": Localize(@"时段设置")}, @{@"image" :@"ic_launch1", @"name": Localize(@"延时/定时开关")}];
    }
}

- (void)updateStauts:(NSNotification *)noti {
    NSDictionary *dic = noti.object;
    electrictyModel = dic?@"03":@"00";
    [deviceInfoCollection reloadData];
}

- (void) viewWillAppear:(BOOL)animated {
    if ([self.sortt containsString:@"YC"] || [self.sortt containsString:@"YC10"] || [self.sortt containsString:@"YC16 "] || [self.sortt containsString:@"YCGP10"] || [self.sortt containsString:@"YCGP16"] || [self.sortt containsString:@"QC"] || [self.sortt containsString:@"QC10"] || [self.sortt containsString:@"QC16"] || [self.sortt containsString:@"YC13"] || [self.sortt containsString:@"QC13"] || [self.sortt containsString:@"YC15"] || [self.sortt containsString:@"QC15"]) {
        [self loadData];
    }else {
        
    }
}

- (void)loadData {
    WebSocket *socket = [WebSocket socketManager];
    CommandModel *model = [[CommandModel alloc] init];
    model.command = @"0008";
    model.deviceNo = self.model.id;
    MyWeakSelf
    [socket sendSingleDataWithModel:model resultBlock:^(id response, NSError *error) {
        [weakSelf.view stopLoading];
        if (!error) {
            
            if (((NSString *)response).length == 120) {
                NSString *content = [response substringWithRange:NSMakeRange(((NSString *)response).length - 96, 92)];
                
                electrictyModel = [content substringFromIndex:content.length - 2];
                
                if ([electrictyModel isEqualToString:@"00"] || [electrictyModel isEqualToString:@"01"]) {
                    [self countDownTime];
                }else {
                    [deviceInfoCollection reloadData];
                }
            }
        }
    }];
}

- (void)deviceStatus {
    WebSocket *socket = [WebSocket socketManager];
    CommandModel *model = [[CommandModel alloc] init];
    model.command = @"0002";
    model.deviceNo = self.model.id;
    [self.view startLoading];
    
    MyWeakSelf
    [socket sendSingleDataWithModel:model resultBlock:^(id response, NSError *error) {
        [weakSelf.view stopLoading];
        if (!error) {
            isOnline = YES;
            BOOL open = YES;
            if (((NSString *)response).length>26) {
                NSString *string = [response substringWithRange:NSMakeRange(24, 2)];
                NSString *binary = [Utils getBinaryByHex:string];
                NSString *left = [binary substringWithRange:NSMakeRange(binary.length - 3, 1)];
                NSString *center = [binary substringWithRange:NSMakeRange(binary.length - 2, 1)];
                NSString *right = [binary substringFromIndex:binary.length - 1];
                
                //一位插座
                if ([self.model.id hasPrefix:@"61"]) {
                    if ([center isEqualToString:@"0"]) {
                        open = NO;
                    }else
                    {
                        open = YES;
                    }
                    //二位插座
                }else if ([self.model.id hasPrefix:@"62"])
                {
                    if ([left isEqualToString:@"0"] || [right isEqualToString:@"0"]) {
                        open = NO;
                    }else
                    {
                        open = YES;
                    }
                    //三位插座
                }else if ([self.model.id hasPrefix:@"63"])
                {
                    if ([left isEqualToString:@"0"] || [right isEqualToString:@"0"] || [center isEqualToString:@"0"]) {
                        open = NO;
                    }else
                    {
                        open = YES;
                    }
                }else
                {
                    if ([string isEqualToString:@"00"]) {
                        open = NO;
                    }else
                    {
                        open = YES;
                    }
                }
            }
            
            if (!open) {
                [statusImg setImage:[UIImage imageNamed:@"open_open"]];
                [status setText:Localize(@"设备正处于开启状态")];
            }else {
                [statusImg setImage:[UIImage imageNamed:@"open_close"]];
                [status setText:Localize(@"设备正处于关闭状态")];
            }
        }else {
            isOnline = NO;
            [statusImg setImage:[UIImage imageNamed:@"open_offline"]];
            [status setText:Localize(@"设备正处于离线状态")];
        }
        
        ZPLog(@"--------%@",response);
    }];
    
}

//倒计时时间
- (void)countDownTime {
    WebSocket *socket = [WebSocket socketManager];
    CommandModel *model = [[CommandModel alloc] init];
    model.command = @"0012";
    model.deviceNo = self.model.id;
    
    //    MyWeakSelf
    [socket sendSingleDataWithModel:model resultBlock:^(id response, NSError *error) {
        
        if (!error) {
            NSString *content = [response substringWithRange:NSMakeRange(((NSString *)response).length - 16, 12)];
            [formatter setDateFormat:@"yyMMddHHmmss"];
            NSDate *startDate = [formatter dateFromString:content];
            
            NSComparisonResult result =[startDate compare:[NSDate date]];
            if (!startDate || [content hasPrefix:@"00"] || result != NSOrderedDescending) {
                electrictyModel = nil;
                [status setText:Localize(@"设备已结束倒计时模式")];
            }
        }
        [deviceInfoCollection reloadData];
        ZPLog(@"--------%@",response);
    }];
}


- (IBAction)refreashAction {
    [self deviceStatus];
    
}

#pragma mark - UICollectionView Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return datas.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DeviceInfoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    NSDictionary *dic = datas[indexPath.row];
    cell.imgV.image = [UIImage imageNamed:dic[@"image"]];
    cell.name.text = dic[@"name"];
    if (indexPath.row == 5 && ([electrictyModel isEqualToString:@"00"] || [electrictyModel isEqualToString:@"01"])) {
        //倒计时模式
        if (indexPath.row == 5) {
            cell.discb.text = [electrictyModel isEqualToString:@"00"]?@"设备正处于倒计时关模式":@"设备正处于倒计时开模式";
        }
    }else if (indexPath.row == 4 && ([electrictyModel isEqualToString:@"03"] || [electrictyModel isEqualToString:@"05"]))
    {
        //运行时段模式、循环通断模式
        if (indexPath.row == 4) {
            cell.discb.text = [electrictyModel isEqualToString:@"03"]?Localize(@"设备正处于时段运行模式"):Localize(@"设备正处于循环通断模式");
        }
    }else
    {
        cell.discb.text = @"";
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (!isOnline) {
        
        [HintView showHint:Localize(@"当前设备离线不可控制")];
        return;
    }
    
    switch (indexPath.row) {
        case 0:
        {
            RealTimeParamViewController *params = [[RealTimeParamViewController alloc] init];
            params.dNo = self.model.id;
            params.CoedID = self.model.sort;
            [self.navigationController pushViewController:params animated:YES];
        }
            break;
        case 1:
        {
            ParamsSettingViewController *params = [[ParamsSettingViewController alloc] init];
            params.dNo = self.model.id;
            params.Coedid = self.model.sort;
            ZPLog(@"%@",self.model.sort);
            [self.navigationController pushViewController:params animated:YES];
        }
            break;
        case 2:
        {
            MeteringViewController *params = [[MeteringViewController alloc] init];
            params.deviceNo = self.model.id;
            [self.navigationController pushViewController:params animated:YES];
        }
            break;
        case 3:
        {
            StatisticsViewController * statistic = [[StatisticsViewController alloc] init];
            statistic.model = self.model;
            [self.navigationController pushViewController:statistic animated:YES];
        }
            break;
        case 4:
        {
            NSString * string = self.model.id;
            NSString * EquipmentID = [string substringWithRange:NSMakeRange(0, 2)];
            ZPLog(@"%@",EquipmentID);
            if ([EquipmentID containsString:@"61"] || [EquipmentID containsString:@"62"] || [EquipmentID containsString:@"63"]) {
                //                CountDownViewController * count = [[CountDownViewController alloc] initWithNibName:@"CountDownViewController" bundle:nil];
                //                count.deviceNo = self.model.id;
                //                [self.navigationController pushViewController:count animated:YES];
                MultipleSwitchViewController * MultipleSwitch = [[MultipleSwitchViewController alloc]init];
                MultipleSwitch.deviceNo = self.model.id;
                [self.navigationController pushViewController:MultipleSwitch animated:YES];
            }else
                //            if ([EquipmentID containsString:@"68"] || [EquipmentID containsString:@"66"] || [EquipmentID containsString:@"65"]) {
                //                TimeSettingViewController * time = [[TimeSettingViewController alloc] init];
                //                time.deviceNo = self.model.id;
                //                [self.navigationController pushViewController:time animated:YES];
                //            }else
            {
                TimeSettingViewController * time = [[TimeSettingViewController alloc] init];
                time.deviceNo = self.model.id;
                [self.navigationController pushViewController:time animated:YES];
            }
        }
            break;
        case 5:
        {
            CountDownViewController * count = [[CountDownViewController alloc] initWithNibName:@"CountDownViewController" bundle:nil];
            [self.navigationController pushViewController:count animated:YES];
            count.deviceNo = self.model.id;
        }
            break;
        default:
            break;
    }
}

@end
