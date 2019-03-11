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
#import "DetailsViewController.h"

#define ItemWidth  (ScreenWidth -1)/2.0
static NSString *const reuseIdentifier = @"DeviceInfoCollectionCell";


@interface DeviceInfoViewController () {
    __weak IBOutlet UILabel *status;
    __weak IBOutlet UIImageView *statusImg;
    BOOL isOnline;
    __weak IBOutlet UIButton *refreashBtn;
    __weak IBOutlet UICollectionView *deviceInfoCollection;
    NSArray *datas;
    NSString *electrictyModel;
    NSDateFormatter *formatter;
    NSTimer *timer;
}
@end

@implementation DeviceInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = Localize(@"设备信息");
    [self initUI];
    [self GetsTime];
    
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateStauts:) name:CHANGETIMEMODEL object:nil];
    self.PayView.hidden = YES;
    self.StateViewLayoutConstraint.constant = - 80;
}

// UI
- (void)initUI {
    if ([self.sortt isEqualToString:@"QK01"] || [self.sortt isEqualToString:@"QK02"] || [self.sortt isEqualToString:@"QK03"]){
        datas = @[@{@"image" :@"ic_launch", @"name": Localize(@"实时参数")}, @{@"image" :@"ic_l", @"name": Localize(@"增值服务")}, @{@"image" :@"ic_laun", @"name": Localize(@"定时计量")}, @{@"image" :@"menu_summery", @"name": Localize(@"用电统计")}, @{@"image" :@"ic_launch1", @"name": Localize(@"延时/定时开关")}];
        self.PayView.hidden = YES;
        self.StateViewLayoutConstraint.constant = - 80;
    }else
        if ([self.sortt isEqualToString:@"YFMT"] ||[self.sortt isEqualToString:@"YFGPMT"]) {
            [self loadData];
            datas = @[@{@"image" :@"ic_launch", @"name": Localize(@"实时参数")}, @{@"image" :@"ic_l", @"name": Localize(@"增值服务")}, @{@"image" :@"ic_laun", @"name": Localize(@"定时计量")}, @{@"image" :@"menu_summery", @"name": Localize(@"用电统计")}, @{@"image" :@"ic_launcher2", @"name": Localize(@"时段设置")}, @{@"image" :@"ic_launch1", @"name": Localize(@"延时/定时开关")},
                      @{@"image" :@"ic_launch1", @"name": Localize(@"充值")}];
            UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TopUpBut:)];
            [self.PayView addGestureRecognizer:tapGesturRecognizer];
        }else {
            [self loadData];
        datas = @[@{@"image" :@"ic_launch", @"name": Localize(@"实时参数")}, @{@"image" :@"ic_l", @"name": Localize(@"增值服务")}, @{@"image" :@"ic_laun", @"name": Localize(@"定时计量")}, @{@"image" :@"menu_summery", @"name": Localize(@"用电统计")}, @{@"image" :@"ic_launcher2", @"name": Localize(@"时段设置")}, @{@"image" :@"ic_launch1", @"name": Localize(@"延时/定时开关")}];
            self.PayView.hidden = YES;
            self.StateViewLayoutConstraint.constant = - 80;
    }
}

- (void)updateStauts:(NSNotification *)noti {
    NSDictionary *dic = noti.object;
    electrictyModel = dic?@"03":@"00";
    [deviceInfoCollection reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [self deviceStatus];
    if ([self.sortt isEqualToString:@"YC"] || [self.sortt isEqualToString:@"YC10"] || [self.sortt isEqualToString:@"YC16 "] || [self.sortt isEqualToString:@"YCGP10"] || [self.sortt isEqualToString:@"YCGP16"] || [self.sortt isEqualToString:@"QC"] || [self.sortt isEqualToString:@"QC10"] || [self.sortt isEqualToString:@"QC16"] || [self.sortt isEqualToString:@"YC13"] || [self.sortt isEqualToString:@"QC13"] || [self.sortt isEqualToString:@"YC15"] || [self.sortt isEqualToString:@"QC15"]) {
        
    }else {
      
    }
}

- (void)loadData {
    WebSocket * socket = [WebSocket socketManager];
    CommandModel * model = [[CommandModel alloc] init];
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
    WebSocket * socket = [WebSocket socketManager];
    CommandModel * model = [[CommandModel alloc] init];
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
                    }else {
                        open = YES;
                    }
                    //二位插座
                }else
                    if ([self.model.id hasPrefix:@"62"]) {
                    if ([left isEqualToString:@"0"] || [right isEqualToString:@"0"]) {
                        open = NO;
                    }else {
                        open = YES;
                    }
                    //三位插座
                }else
                    if ([self.model.id hasPrefix:@"63"]) {
                    if ([left isEqualToString:@"0"] || [right isEqualToString:@"0"] || [center isEqualToString:@"0"]) {
                        open = NO;
                    }else {
                        open = YES;
                    }
                }else {
                    if ([string isEqualToString:@"00"]) {
                        open = NO;
                    }else {
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
//                [status setText:Localize(@"设备已结束倒计时模式")];
            } else {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)([startDate timeIntervalSinceDate:[NSDate date]] * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self loadData];
                });
            }
        }
        [deviceInfoCollection reloadData];
        ZPLog(@"--------%@",response);
    }];
}


- (IBAction)refreashAction {
    [self loadData];
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
            cell.discb.text = [electrictyModel isEqualToString:@"00"]?@"设备正处于关模式":@"设备正处于开模式";
        }
    }else
        if (indexPath.row == 4 && ([electrictyModel isEqualToString:@"03"] || [electrictyModel isEqualToString:@"05"])) {
        //运行时段模式、循环通断模式
        if (indexPath.row == 4) {
            cell.discb.text = [electrictyModel isEqualToString:@"03"]?Localize(@"设备正处于时段运行模式"):Localize(@"设备正处于循环通断模式");
        }
    }else {
        cell.discb.text = @"";
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
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
            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];  // 隐藏返回按钮上的文字
        }
            break;
        case 1:
        {
            ParamsSettingViewController *params = [[ParamsSettingViewController alloc] init];
            params.dNo = self.model.id;
            params.Coedid = self.model.sort;
            ZPLog(@"%@",self.model.sort);
            [self.navigationController pushViewController:params animated:YES];
            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];  // 隐藏返回按钮上的文字
        }
            break;
        case 2:
        {
            MeteringViewController *params = [[MeteringViewController alloc] init];
            params.deviceNo = self.model.id;
            [self.navigationController pushViewController:params animated:YES];
            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];  // 隐藏返回按钮上的文字
        }
            break;
        case 3:
        {
            StatisticsViewController * statistic = [[StatisticsViewController alloc] init];
            statistic.model = self.model;
            [self.navigationController pushViewController:statistic animated:YES];
            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];  // 隐藏返回按钮上的文字
        }
            break;
        case 4:
        {
            NSString * string = self.model.id;
            NSString * EquipmentID = [string substringWithRange:NSMakeRange(0, 2)];
            ZPLog(@"%@",EquipmentID);
            if ([EquipmentID containsString:@"61"] || [EquipmentID containsString:@"62"] || [EquipmentID containsString:@"63"]) {
                MultipleSwitchViewController * MultipleSwitch = [[MultipleSwitchViewController alloc]init];
                MultipleSwitch.deviceNo = self.model.id;
                [self.navigationController pushViewController:MultipleSwitch animated:YES];
                self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];  // 隐藏返回按钮上的文字
            }else {
                TimeSettingViewController * time = [[TimeSettingViewController alloc] init];
                time.deviceNo = self.model.id;
                [self.navigationController pushViewController:time animated:YES];
                self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];  // 隐藏返回按钮上的文字
            }
        }
            break;
        case 5:
        {
            CountDownViewController * count = [[CountDownViewController alloc] initWithNibName:@"CountDownViewController" bundle:nil];
            [self.navigationController pushViewController:count animated:YES];
            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];  // 隐藏返回按钮上的文字
            count.deviceNo = self.model.id;
        }
            break;
        default:
            break;
    }
}

- (void)TopUpBut:(UIButton *)sender {
    DetailsViewController * Details = [[DetailsViewController alloc]init];
    [self.navigationController pushViewController:Details animated:YES];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];  // 隐藏返回按钮上的文字
    Details.deviceNo = self.model.id;
    ZPLog(@"1111");
}

- (void)GetsTime {
    NSDate *currentDate = [NSDate date];
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    //  IOS 8 之后
    NSUInteger integer = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dataCom = [currentCalendar components:integer fromDate:currentDate];
    NSInteger year = [dataCom year]; // 年
    NSInteger month = [dataCom month]; // 月
    NSInteger day = [dataCom day]; // 日
    NSInteger week = [dataCom weekday]; // 星期
    NSInteger hour = [dataCom hour]; // 时
    NSInteger minute = [dataCom minute]; // 分
    NSInteger second = [dataCom second]; // 秒
    NSString * Year = [[NSNumber numberWithInteger:year] stringValue];
    self.YearStr = [Year substringFromIndex:2]; // 去掉首字符
    if (month >= 10) {
        self.MonthStr = [[NSNumber numberWithInteger:month] stringValue];
    }else {
        self.MonthStr = [NSString stringWithFormat:@"0%ld",(long)month];
    }
    if (day >= 10) {
        self.DayStr = [[NSNumber numberWithInteger:day] stringValue];
    }else {
        self.DayStr = [NSString stringWithFormat:@"0%ld",(long)day];
    }
    if (hour >= 10) {
        self.HourStr = [[NSNumber numberWithInteger:hour] stringValue];
    }else{
        self.HourStr = [NSString stringWithFormat:@"0%ld",(long)hour];
    }
    if (minute >= 10) {
        self.MinuteStr = [[NSNumber numberWithInteger:minute] stringValue];
    }else {
        self.MinuteStr = [NSString stringWithFormat:@"0%ld",(long)minute];
    }
    if (second >= 10) {
        self.SecondStr = [[NSNumber numberWithInteger:second] stringValue];
    }else {
        self.SecondStr = [NSString stringWithFormat:@"0%ld",(long)second];
    }
    
    //   星期
    NSString *WeekStr = [NSString stringWithFormat:@"%ld",(long)week];
    //    ZPLog(@"%@",WeekStr);
    if ([WeekStr containsString:@"1"]) {
        week = 0;
        if (week >= 10) {
            self.WeekStr = [[NSNumber numberWithInteger:week] stringValue];
        }else {
            self.WeekStr = [NSString stringWithFormat:@"0%ld",(long)week];
        }
    }
    
    if ([WeekStr containsString:@"2"]) {
        week = 1;
        if (week >= 10) {
            self.WeekStr = [[NSNumber numberWithInteger:week] stringValue];
        }else {
            self.WeekStr = [NSString stringWithFormat:@"0%ld",(long)week];
        }
    }
    
    if ([WeekStr containsString:@"3"]) {
        week = 2;
        if (week >= 10) {
            self.WeekStr = [[NSNumber numberWithInteger:week] stringValue];
        }else {
            self.WeekStr = [NSString stringWithFormat:@"0%ld",(long)week];
        }
    }
    
    if ([WeekStr containsString:@"4"]) {
        week = 3;
        if (week >= 10) {
            self.WeekStr = [[NSNumber numberWithInteger:week] stringValue];
        }else {
            self.WeekStr = [NSString stringWithFormat:@"0%ld",(long)week];
        }
    }
    
    if ([WeekStr containsString:@"5"]) {
        week = 4;
        if (week >= 10) {
            self.WeekStr = [[NSNumber numberWithInteger:week] stringValue];
        }else {
            self.WeekStr = [NSString stringWithFormat:@"0%ld",(long)week];
        }
    }
    if ([WeekStr containsString:@"6"]) {
        week = 5;
        if (week >= 10) {
            self.WeekStr = [[NSNumber numberWithInteger:week] stringValue];
        }else {
            self.WeekStr = [NSString stringWithFormat:@"0%ld",(long)week];
        }
    }
    
    if ([WeekStr containsString:@"7"]) {
        week = 6;
        if (week >= 10) {
            self.WeekStr = [[NSNumber numberWithInteger:week] stringValue];
        }else {
            self.WeekStr = [NSString stringWithFormat:@"0%ld",(long)week];
        }
    }
    self.Ymdhms = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",self.YearStr,self.MonthStr,self.DayStr,self.WeekStr,self.HourStr,self.MinuteStr,self.SecondStr];
    [self CheckTime];
}

// 校验时间
- (void)CheckTime {
    WebSocket *socket = [WebSocket socketManager];
    CommandModel *model = [[CommandModel alloc] init];
    model.command = @"0005";
    model.deviceNo = self.model.id;
    model.content = self.Ymdhms;
    //    MyWeakSelf
    [socket sendSingleDataWithModel:model resultBlock:^(id response, NSError *error) {
        ZPLog(@"%@",response);
    }];
}


@end
