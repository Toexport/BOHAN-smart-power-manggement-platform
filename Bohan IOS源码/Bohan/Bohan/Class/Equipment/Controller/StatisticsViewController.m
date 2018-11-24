//
//  StatisticsViewController.m
//  Bohan
//
//  Created by Yang Lin on 2018/1/26.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import "StatisticsViewController.h"
#import "SliderView.h"
#import "PowerHorizontalBarView.h"
#import "PowerLineChartView.h"
#import "PowerModel.h"
#import "DeviceModel.h"
#import "UIImage+Color.h"
#import "DebuggingANDPublishing.pch"
@interface StatisticsViewController ()
{
    NSArray * dataArray;
    NSUInteger currentIndex;
    NSDateFormatter * formatter;
    NSArray * urls;
    NSArray * formatters;
    NSArray * keys;
    NSDate * selectedDate;
}
@property(nonatomic,strong)UIView * infoView;
@property(nonatomic,strong)SliderView * sliderView;
@property(nonatomic,strong)UIView * headerView;
@property(nonatomic,strong)UILabel * dateLable;
@property(nonatomic,strong)UIView * selectView;
@property(nonatomic,strong)PowerHorizontalBarView * barView;
@property(nonatomic,strong)PowerLineChartView * lineView;
@property(nonatomic,copy)NSArray * titles;
@property(nonatomic,copy)NSArray * titles2;

@end

@implementation StatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = Localize(@"用电统计");
    urls = @[GET_DAY_DETAIL_POWER, GET_MONTH_DETAIL_POWER, GET_YERA_DETAIL_POWER];
    formatters = @[@"yyyyMMdd", @"yyyyMM", @"yyyy"];
    keys = @[@"strYearMonthDay", @"strYearMonth", @"strYear"];
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    selectedDate = [NSDate date];
    [self.view addSubview:self.infoView];
    [self.view addSubview:self.sliderView];
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.selectView];
    [self.view addSubview:self.barView];
    [self.view addSubview:self.lineView];

    MyWeakSelf
    [self.barView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.selectView.mas_bottom);
        make.left.right.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view.mas_bottomMargin);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.selectView.mas_bottom);
        make.left.right.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view.mas_bottomMargin);
    }];
    self.lineView.hidden = YES;

    [self loadData];
}

- (void)loadData {
    [self.view startLoading];
    
    NSString *url = urls[currentIndex];
    [formatter setDateFormat:formatters[currentIndex]];
    NSDictionary *dic = @{@"deviceCode":self.model.id,keys[currentIndex]:[formatter stringFromDate:selectedDate]};
    
    [[NetworkRequest sharedInstance] requestWithUrl:url parameter:dic completion:^(id response, NSError *error) {

        [self.view stopLoading];
        ZPLog(@"%@",response);
        if (!error) {
            dataArray = [NSArray yy_modelArrayWithClass:[PowerModel class] json:response[@"content"]];
            
        }else
        {
            [HintView showHint:error.localizedDescription];
            dataArray = nil;
        }
        [dataArray enumerateObjectsUsingBlock:^(PowerModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
            ZPLog(@"%@-%@-%@",model.avgPowerData,model.powerData,model.date);
        }];
        [self.barView setDatas:dataArray];
        [self.lineView setDatas:dataArray];
        
    }];
}

- (void)selectAction
{
    MyWeakSelf
    WSDateStyle type;
    if (currentIndex == 0) {
        type = DateStyleShowYearMonthDay;
    }else if (currentIndex == 1)
    {
        type = DateStyleShowYearMonth;
    }else
    {
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

- (void)changeViewAction:(UIButton *)btn {
    if (btn.selected) {
        return;
    }
    btn.selected = YES;
    if (btn.tag == 300) {
        ((UIButton *)[self.selectView viewWithTag:301]).selected = NO;
        self.barView.hidden = NO;
        self.lineView.hidden = YES;
    }else {
        ((UIButton *)[self.selectView viewWithTag:300]).selected = NO;
        self.barView.hidden = YES;
        self.lineView.hidden = NO;
    }
}

- (NSArray *)titles {
    return @[Localize(@"本设备当日每小时用电量（kWh）"), Localize(@"本设备当月每日用电量（kWh）"), Localize(@"本设备当年每月用电量（kWh）")];
}

- (NSArray *)titles2 {
    return @[Localize(@"本设备当日每小时用电功率（W）"), Localize(@"本设备当月每日用电功率（W）"), Localize(@"本设备当年每月用电功率（W）")];
}

- (UIView *)infoView {
    if (!_infoView) {
        _infoView = [[UIView alloc] initWithFrame:CGRectMake(0, kTopHeight, ScreenWidth, 30)];
        NSArray *contens = @[[NSString stringWithFormat:@"%@:%@",Localize(@"名称"),self.model.name], [NSString stringWithFormat:@"%@:%@",Localize(@"位置"),self.model.position], [NSString stringWithFormat:@"ID:%@",self.model.id]];
        for (int i = 0; i<3; i++) {
            
            UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(i*ScreenWidth/3, 0, ScreenWidth/3, _infoView.frame.size.height)];
            [lab setText:contens[i]];
            [lab setTextColor:kTextColor];
            [lab setFont:Font(12)];
            [lab setTextAlignment:NSTextAlignmentCenter];
            [_infoView addSubview:lab];
        }
    }
    return _infoView;
}

- (SliderView *)sliderView {
    if (!_sliderView) {
        _sliderView = [[SliderView alloc] initWithFrame:CGRectMake(0, self.infoView.frame.origin.y + self.infoView.frame.size.height, ScreenWidth, 45) datas:@[Localize(@"日数据"), Localize(@"月数据"), Localize(@"年数据")]];
        [_sliderView setBackgroundColor:kBackBackroundColor];
        MyWeakSelf
        __weak typeof(NSDateFormatter *) weakFormatter = formatter;
        __weak typeof(NSArray *) weakFormatters = formatters;
//        __weak typeof(NSUInteger) weakIndex = currentIndex;
        
        _sliderView.block = ^(NSUInteger index) {
            
            if (index == 2) {
                weakSelf.selectView.hidden = YES;
                weakSelf.lineView.hidden = YES;
                weakSelf.barView.hidden = NO;
                
                [weakSelf.barView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(weakSelf.headerView.mas_bottom);
                    make.left.right.equalTo(weakSelf.view);
                    make.bottom.equalTo(weakSelf.view.mas_bottomMargin);
                }];
                
                [weakSelf.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(weakSelf.headerView.mas_bottom);
                    make.left.right.equalTo(weakSelf.view);
                    make.bottom.equalTo(weakSelf.view.mas_bottomMargin);
                }];

                
            }else {
                weakSelf.selectView.hidden = NO;
                
                ((UIButton *)[weakSelf.selectView viewWithTag:300]).selected = !weakSelf.barView.hidden;
                ((UIButton *)[weakSelf.selectView viewWithTag:301]).selected = !weakSelf.lineView.hidden;

                [weakSelf.barView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(weakSelf.selectView.mas_bottom);
                    make.left.right.equalTo(weakSelf.view);
                    make.bottom.equalTo(weakSelf.view.mas_bottomMargin);
                }];
                
                [weakSelf.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(weakSelf.selectView.mas_bottom);
                    make.left.right.equalTo(weakSelf.view);
                    make.bottom.equalTo(weakSelf.view.mas_bottomMargin);
                }];
            }

            currentIndex = index;
            [weakFormatter setDateFormat:weakFormatters[index]];
            [weakSelf.dateLable setText:[weakFormatter stringFromDate:selectedDate]];
            [weakSelf.barView setTitle:weakSelf.titles[index]];
            [weakSelf.lineView setTitle:weakSelf.titles2[index]];

            [weakSelf loadData];
            
//                        [weakSelf loadData];
//                        [weakSelf.pageCollection setContentOffset:CGPointMake(currentIndex *ScreenWidth, 0) animated:YES];
        };
    }
    
    return _sliderView;
}

- (UIView *)headerView
{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.sliderView.frame.origin.y + self.sliderView.frame.size.height, self.sliderView.frame.size.width, 45)];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _sliderView.frame.size.width, 20)];
        [title setText:Localize(@"历史数据")];
        [title setFont:Font(12)];
        [title setTextColor:kDefualtColor];
        [title setTextAlignment:NSTextAlignmentCenter];
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


- (UIView *)selectView
{
    if(!_selectView){
        
        _selectView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headerView.frame), ScreenWidth, 35)];
        
        
        NSArray *titles = @[Localize(@"用电量"), Localize(@"功率")];
        
        for (int i = 0; i<2; i++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i==0?50:(ScreenWidth - 125), 2.5, 90, 30)];
            [btn setTitle:titles[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor getColor:@"df7d50"] forState:UIControlStateNormal];
            [btn.titleLabel setFont:Font(14)];
            [btn setBackgroundImage:[UIImage createImageWithColor:[UIColor getColor:@"dce760"]] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage createImageWithColor:[UIColor getColor:@"efc632"]] forState:UIControlStateSelected];
            [btn setTag:300+i];
            btn.titleLabel.numberOfLines = 2;
            btn.titleLabel.textAlignment = NSTextAlignmentCenter;
            [btn addTarget:self action:@selector(changeViewAction:) forControlEvents:UIControlEventTouchUpInside];
            [_selectView addSubview:btn];
            if (i== 0) {
                btn.selected = YES;
            }
        }
    }
    
    return  _selectView;
}

- (PowerHorizontalBarView *)barView {
    if (!_barView) {
        _barView = [[PowerHorizontalBarView alloc] init]; // 这个是底部View的View
        [_barView setTitle:self.titles[0]];
//        [_barView setTitle:@"0"];
    }
    return _barView;
}


- (PowerLineChartView *)lineView
{
    if (!_lineView) {
        _lineView = [[PowerLineChartView alloc] init];
        [_lineView setTitle:self.titles2[0]];
    }
    
    return _lineView;
}

@end
