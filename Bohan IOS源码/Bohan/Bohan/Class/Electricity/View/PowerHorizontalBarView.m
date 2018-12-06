//
//  PowerHorizontalBarView.m
//  Bohan
//
//  Created by Yang Lin on 2018/2/2.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import "PowerHorizontalBarView.h"
#import "Bohan-Bridging-Header.h"
#import "PowerModel.h"
#import "DebuggingANDPublishing.pch"
@interface PowerHorizontalBarView()

@property (nonatomic, strong)HorizontalBarChartView *chartBarView;
@property (nonatomic, strong) UILabel *name;
@end

@implementation PowerHorizontalBarView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUp];
    }
    
    return self;
}

- (void)setUp {
    
    [self addSubview:self.chartBarView];
    
    self.name = [[UILabel alloc] init];
    [self.name setTextColor:kTextColor];
    [self.name setFont:Font(14)];
    [self.name setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:self.name];
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.equalTo(@10);
    }];
    [self.name setText:self.title];
    [self setBackgroundColor:[UIColor whiteColor]];
    MyWeakSelf
    [self.chartBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.name.mas_bottom).offset(15);
        make.left.right.bottom.equalTo(weakSelf).offset(0);
//        make.right.equalTo(weakSelf).offset(-10);
//        make.bottom.equalTo(weakSelf).offset(-10);
//        make.edges.equalTo(weakSelf).insets(UIEdgeInsetsMake(40, 10, 20, 10));
    }];
}

- (void)setupBarLineChartView:(HorizontalBarChartView *)chartView {
    chartView.chartDescription.enabled = YES;//显示x轴描述
    chartView.maxVisibleCount = 31;

//    ChartDescription *descrip = [[ChartDescription alloc] init];
//    [descrip setYOffset:-15];
//    [descrip setXOffset:-10];

    
    ChartDescription *descrip = [[ChartDescription alloc] init];
    [descrip setYOffset:-25];
    [descrip setXOffset:-5];
    [chartView setChartDescription:descrip];

    
//    [chartView setChartDescription:descrip];
    chartView.descriptionTextColor = kTextColor;
    chartView.descriptionFont = EFont(9);
    chartView.descriptionTextAlign = NSTextAlignmentRight;
    chartView.descriptionText = @"kWh";
//    chartView.noDataText = @"(暂无数据)";
    
    chartView.drawGridBackgroundEnabled = NO;//不显示图表背景色
    
    chartView.dragEnabled = YES;//不可拖拽
    [chartView setScaleEnabled:NO];//不可缩放
    chartView.pinchZoomEnabled = NO;//不可手势放大
    //    chartView.minOffset = 20;//最小边距
    
    //设置图表上下左右边距
    [chartView setExtraOffsetsWithLeft:10 top:0 right:15 bottom:15];
    
    //    chartView.xAxis.gridColor = [UIColor getColor:@"f2f2f2"];
    //X轴设置
    ChartXAxis *xAxis = chartView.xAxis;
//    xAxis.granularity = 0.000001;

    //X轴文字设置
    //    xAxis.labelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.f];
    xAxis.labelFont = EFont(9);
    xAxis.labelTextColor = [UIColor getColor:@"333333"];
    
    xAxis.labelPosition = XAxisLabelPositionBottom;//X轴显示显示在底部
//    xAxis.drawAxisLineEnabled = YES;//是否显示X轴
    xAxis.drawGridLinesEnabled = YES;
    xAxis.avoidFirstLastClippingEnabled = NO;//是否避免第一个和最后一个被截断，设置为YES则分别靠左边、右边显示，设置为NO则居中显示
//    xAxis.gridLineWidth = 0.5;//X轴线条宽度
    xAxis.gridColor = [UIColor getColor:@"f2f2f2"];//X轴线条颜色
    //    //很重要，不这样设置显示不正常
        xAxis.spaceMin = 1;//最小间距
//    xAxis.spaceMax = 5;
//        xAxis.spaceMax = 20;//最大间距
    
    
    //Y上半轴设置
//     异常问题View
    chartView.leftAxis.enabled = NO;//Y上半轴左边刻度线不显示，设置为YES则显示Y轴
    chartView.leftAxis.axisMinimum = 0.00;
//    chartView

    chartView.rightAxis.enabled = YES;//Y上半轴右边刻度线不显示，设置为YES则显示Y轴
    chartView.rightAxis.labelFont = EFont(9);
    
//    chartView.rightAxis.spaceTop = 0.98;//Y上半轴最大值占百分比
    chartView.rightAxis.spaceBottom = 0.01;//Y上半轴最小值占百分比
    chartView.rightAxis.axisMinimum = 0.00; // 不知道是不是对的，反正现在暂时没问题
    chartView.rightAxis.drawGridLinesEnabled = NO;
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.maximumFractionDigits = 2;
    formatter.minimumFractionDigits = 0;
    
    chartView.rightAxis.valueFormatter = [[ChartDefaultAxisValueFormatter alloc] initWithFormatter:formatter];//X轴数据值
//            _chartBarView.rightAxis.axisRange = self.datas.count -1;//x轴刻度范围
//    chartView.rightAxis.labelCount = 6;//x轴刻度个数
    chartView.rightAxis.spaceMin = 0.01;
//    chartView.rightAxis.axisRange = 0.1;
    
    //不显示底部图表说明
    ChartLegend *legend = _chartBarView.legend;
    [legend setEnabled:NO];
    
    BarChartDataSet *dataSets = [[BarChartDataSet alloc] initWithValues:@[] label:@""];
    NSArray<id <IChartDataSet>> *barDataSets = @[dataSets];
    
    BarChartData *data = [[BarChartData alloc] initWithDataSets:barDataSets];
    [data setValueFont:EFont(9)];
    
    [data setValueFormatter:[[ChartDefaultValueFormatter alloc] initWithFormatter:formatter]];
    
    _chartBarView.data = data;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSMutableArray *yVals = [NSMutableArray array];
    NSMutableArray *xVals = [NSMutableArray array];
    for (int i = 0; i< self.datas.count; i++) {
    
        PowerModel *model = self.datas[i];
        BarChartDataEntry *entry = [[BarChartDataEntry alloc] initWithX:i+1 y:[model.powerData floatValue] icon: [UIImage imageNamed:@""]];
        
        [xVals addObject:model.powerData];
        [yVals addObject:entry];
    }
    
    _chartBarView.xAxis.labelCount = self.datas.count;
//            _chartBarView.xAxis.axisRange = self.datas.count;
//    _chartBarView.xAxis.labelCount = self.datas.count/2;//x轴刻度个数

    BarChartDataSet *barDataSet = nil;
    if (_chartBarView.data.dataSetCount > 0) {
        barDataSet = (BarChartDataSet *)_chartBarView.data.dataSets[0];
        barDataSet.values = yVals;//y轴数据值
        
        [_chartBarView.data notifyDataChanged];//数据更新通知
        [_chartBarView notifyDataSetChanged];
        
    }
    if (self.datas.count>0) {
        if (_chartBarView.frame.size.height < self.datas.count *15 + 20) {
//            [_chartBarView setVisibleXRangeMinimum:self.datas.count/2];

//            _chartBarView.xAxis.labelCount = self.datas.count *_chartBarView.frame.size.height/(self.datas.count *(15 + _chartBarView.xAxis.spaceMin) + 30);//x轴刻度个数
            [_chartBarView setVisibleXRangeMinimum:self.datas.count /ceilf((self.datas.count *15)/(1.0*_chartBarView.frame.size.height -20))];
            NSLog(@"----%f",self.datas.count /ceilf((self.datas.count *15)/(1.0*_chartBarView.frame.size.height -20)));
                                                
                                                
            [_chartBarView setVisibleXRangeMaximum:self.datas.count /ceilf((self.datas.count *15)/(1.0*_chartBarView.frame.size.height -20))];
            
            NSLog(@"---%f",self.datas.count /ceilf((self.datas.count *15)/(1.0*_chartBarView.frame.size.height -20)));
            
//            [_chartBarView setVisibleXRangeMinimum:self.datas.count *_chartBarView.frame.size.height/(1.0 * self.datas.count *(15 + _chartBarView.xAxis.spaceMin) + 30)];

        }else {
//            [_chartBarView setVisibleXRangeMaximum:self.datas.count+1];
            [_chartBarView setVisibleXRangeMinimum:2];
            ZPLog(@"g=%f",ceilf((self.datas.count *15)/(1.0*_chartBarView.frame.size.height -20)));
//            _chartBarView.xAxis.labelCount = self.datas.count;//x轴刻度个数
//            [_chartBarView setVisibleXRangeMaximum:self.datas.count];
        }
    }
    //x方向动画
    [_chartBarView animateWithYAxisDuration:2 easingOption:ChartEasingOptionEaseInQuad];

}

#pragma mark - getter and setter
- (HorizontalBarChartView *)chartBarView {
    if (!_chartBarView) {
        _chartBarView = [[HorizontalBarChartView alloc] init];
//        _chartBarView.userInteractionEnabled = NO;
        
        [self setupBarLineChartView:_chartBarView];
    }
    return _chartBarView;
}

- (void)setDatas:(NSArray *)datas {
    if (_datas != datas) {
        _datas = [datas copy];
        
        [self setNeedsLayout];
        [self layoutIfNeeded];
    }
}

- (void)setTitle:(NSString *)title {
    [self.name setText:title];
}

@end
