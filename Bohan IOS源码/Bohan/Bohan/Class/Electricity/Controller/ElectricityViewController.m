//
//  ElectricityViewController.m
//  Bohan
//
//  Created by JIA LIU on 2017/12/24.
//  Copyright © 2017年 Bohan. All rights reserved.
//

#import "ElectricityViewController.h"
#import "SliderView.h"
#import "PowerHorizontalBarView.h"
#import "PowerModel.h"
#import "NSBundle+AppLanguageSwitch.h"
#import "DebuggingANDPublishing.pch"
@interface ElectricityViewController () {
    NSArray *dataArray;
    NSUInteger currentIndex;
    NSDateFormatter *formatter;
    NSArray *urls;
    NSArray *formatters;
    NSArray *keys;
    NSDate *selectedDate;
}

@property(nonatomic,strong)SliderView *sliderView;
@property(nonatomic,strong)UIView *headerView;
@property(nonatomic,strong)UILabel *dateLable;
@property(nonatomic,strong)PowerHorizontalBarView *barView;
@property(nonatomic,copy)NSArray *titles;

@end

@implementation ElectricityViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageChange) name:AppLanguageDidChangeNotification object:nil];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (@available(iOS 11.0, *)){
//        [self.tableView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageChange) name:AppLanguageDidChangeNotification object:nil];

    self.title = Localize(@"所有用电");
    urls = @[GET_DAY_TOTAL_POWER, GET_MONTH_TOTAL_POWER, GET_YEAR_TOTAL_POWER];
    formatters = @[@"yyyyMMdd", @"yyyyMM", @"yyyy"];
    keys = @[@"strYearMonthDay", @"strYearMonth", @"strYear"];
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    selectedDate = [NSDate date];
    [self.view addSubview:self.sliderView];
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.barView];
    MyWeakSelf
    [self.barView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.headerView.mas_bottom);
        make.left.right.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view).offset(-kTabBarHeight);
    }];
    [self loadData];
}

- (void)loadData {
    [self.view startLoading];
    NSString *url = urls[currentIndex];
    [formatter setDateFormat:formatters[currentIndex]];
    NSDictionary *dic = @{keys[currentIndex]:[formatter stringFromDate:selectedDate]};
    
    [[NetworkRequest sharedInstance] requestWithUrl:url parameter:dic completion:^(id response, NSError *error) {
        
        [self.view stopLoading];
        
        ZPLog(@"%@",response);
        if (!error) {
            dataArray = [NSArray yy_modelArrayWithClass:[PowerModel class] json:response[@"content"]];
            
        }else {
            [HintView showHint:error.localizedDescription];
            dataArray = nil;
        }
        [self.barView setDatas:dataArray];

    }];
    
    
}

- (void)selectAction {
    MyWeakSelf
    WSDateStyle type;
    if (currentIndex == 0) {
        type = DateStyleShowYearMonthDay;
    }else if (currentIndex == 1) {
        type = DateStyleShowYearMonth;
    }else {
        type = DateStyleShowYear;
    }
    
    WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:type scrollToDate:[formatter dateFromString:self.dateLable.text] CompleteBlock:^(NSDate *selectDate) {
        
        selectedDate = selectDate;
        [formatter setDateFormat:formatters[currentIndex]];
        [weakSelf.dateLable setText:[formatter stringFromDate:selectedDate]];
        [weakSelf loadData];
    }];
    datepicker.hideBackgroundYearLabel = YES;
    datepicker.dateLabelColor = kDefualtColor;
    datepicker.doneButtonColor = kDefualtColor;
    [datepicker show];

}

- (void)languageChange {
    self.title = Localize(@"所有用电");
    [_sliderView setDatas:@[Localize(@"日数据"), Localize(@"月数据"), Localize(@"年数据")]];

    UILabel *title = [_headerView viewWithTag:800];
    [title setText:Localize(@"历史数据")];
    
    ZPLog(@"---%@",self.titles);
    [_barView setTitle:self.titles[currentIndex]];

}

//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//
//    self.title = Localize(@"所有用电");
//    [_sliderView setDatas:@[Localize(@"日数据"), Localize(@"月数据"), Localize(@"年数据")]];
//
//    UILabel *title = [_headerView viewWithTag:800];
//    [title setText:Localize(@"历史数据")];
//    [_barView setTitle:self.titles[currentIndex]];
//
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)titles {
    return @[Localize(@"所有设备当日每小时用电量（kWh）"), Localize(@"所有设备当月每日用电量（kWh）"), Localize(@"所有设备当年每月用电量（kWh）")];
}

- (SliderView *)sliderView {
    if (!_sliderView) {
        _sliderView = [[SliderView alloc] initWithFrame:CGRectMake(0, kTopHeight, ScreenWidth, 45) datas:@[Localize(@"日数据"), Localize(@"月数据"), Localize(@"年数据")]];
        [_sliderView setBackgroundColor:kBackBackroundColor];
        MyWeakSelf
        
        __weak typeof(NSDateFormatter *) weakFormatter = formatter;
        __weak typeof(NSArray *) weakFormatters = formatters;
//        __weak typeof(NSUInteger) weakIndex = currentIndex;

        _sliderView.block = ^(NSUInteger index) {
            
            currentIndex = index;
            [weakFormatter setDateFormat:weakFormatters[index]];
            [weakSelf.dateLable setText:[weakFormatter stringFromDate:selectedDate]];
            [weakSelf.barView setTitle:weakSelf.titles[index]];

            [weakSelf loadData];
//            [weakSelf loadData];
//            [weakSelf.pageCollection setContentOffset:CGPointMake(currentIndex *ScreenWidth, 0) animated:YES];
        };
    }
    
    return _sliderView;
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.sliderView.frame.origin.y + self.sliderView.frame.size.height, self.sliderView.frame.size.width, 45)];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _sliderView.frame.size.width, 20)];
        [title setText:Localize(@"历史数据")];
        [title setFont:Font(12)];
        [title setTextColor:kDefualtColor];
        [title setTextAlignment:NSTextAlignmentCenter];
        [title setTag:800];
        [_headerView addSubview:title];
        
        _dateLable = [[UILabel alloc] initWithFrame:CGRectMake(0, title.frame.origin.y + title.frame.size.height, _headerView.frame.size.width, 25)];
        [_dateLable setFont:Font(12)];
        [_dateLable setTextAlignment:NSTextAlignmentCenter];
        [_dateLable setTextColor:kTextColor];
        [_headerView addSubview:_dateLable];
        
        UIButton *selectBtn = [[UIButton alloc] initWithFrame:_headerView.bounds];
        [selectBtn setBackgroundColor:[UIColor clearColor]];
        [selectBtn addTarget:self action:@selector(selectAction) forControlEvents:UIControlEventTouchUpInside];
        [_headerView addSubview:selectBtn];

    }
    [_dateLable setText:[formatter stringFromDate:selectedDate]];

    return _headerView;
}

- (PowerHorizontalBarView *)barView {
    if (!_barView) {
        _barView = [[PowerHorizontalBarView alloc] init];
        [_barView setTitle:self.titles[0]];
    }
    
    return _barView;
}

@end
