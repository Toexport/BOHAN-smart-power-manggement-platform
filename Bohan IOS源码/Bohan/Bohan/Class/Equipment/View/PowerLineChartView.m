//
//  PowerLineChartView.m
//  Bohan
//
//  Created by Yang Lin on 2018/2/4.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import "PowerLineChartView.h"
#import "Bohan-Bridging-Header.h"
#import "PowerModel.h"
#import "DebuggingANDPublishing.pch"
@interface PowerLineChartView ()
@property (nonatomic, strong) LineChartView *lineChartView;
@property (nonatomic, strong) UILabel *name;

@end

@implementation PowerLineChartView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUp];
    }
    
    return self;
}

- (void)setUp
{
    
    [self addSubview:self.lineChartView];
    
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
    [self.lineChartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.name.mas_bottom).offset(15);
        make.left.right.bottom.equalTo(weakSelf).offset(0);
//        make.bottom.equalTo(weakSelf).offset(20);
//        make.edges.equalTo(weakSelf).insets(UIEdgeInsetsMake(40, 10, 20, 10));
    }];
    
}


- (void)setupBarLineChartView:(LineChartView *)chartView
{
    
    ChartDescription *descrip = [[ChartDescription alloc] init];
    [descrip setYOffset:-30];
    [chartView setChartDescription:descrip];
    chartView.chartDescription.enabled = YES;//不显示x轴描述
    chartView.descriptionTextColor = kTextColor;
    chartView.descriptionFont = Font(12);
    chartView.descriptionTextAlign = NSTextAlignmentRight;
    chartView.descriptionText = Localize(@"(手势左右滑动查看每小时的平均用电功率)时");
//    chartView.noDataText = @"(暂无数据)";
    chartView.drawGridBackgroundEnabled = NO;//不显示图表背景色

    chartView.dragEnabled = YES;//不可拖拽
    [chartView setScaleEnabled:NO];//不可缩放
    chartView.pinchZoomEnabled = NO;//不可手势放大
//        chartView.minOffset = 40;//最小边距
    
    //设置图表上下左右边距
//    [chartView setViewPortOffsetsWithLeft:30 top:20 right:20 bottom:40];
    [chartView setExtraOffsetsWithLeft:10 top:0 right:15 bottom:25];

    
    //    chartView.xAxis.gridColor = [UIColor getColor:@"f2f2f2"];
    //X轴设置
    ChartXAxis *xAxis = chartView.xAxis;
 
    //X轴文字设置
    //    xAxis.labelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.f];
    xAxis.labelFont = EFont(9);
    xAxis.labelTextColor = [UIColor getColor:@"333333"];
    
    xAxis.labelPosition = XAxisLabelPositionBottom;//X轴显示显示在底部
    xAxis.drawAxisLineEnabled = NO;//是否显示X轴
    xAxis.avoidFirstLastClippingEnabled = NO;//是否避免第一个和最后一个被截断，设置为YES则分别靠左边、右边显示，设置为NO则居中显示
    xAxis.gridLineWidth = 0.5;//X轴线条宽度
    xAxis.gridColor = [UIColor getColor:@"f2f2f2"];//X轴线条颜色
    xAxis.axisMinimum = 0;
    
//    xAxis
//    xAxis.axisMinValue = 1;
//    xAxis.axisMinValue = 1;
    
//    xAxis.spaceMin = 1;//最小间距
//    xAxis.spaceMax = 1;//最大间距
    
    
    //Y上半轴设置
    
    chartView.leftAxis.enabled = YES;//Y上半轴左边刻度线不显示，设置为YES则显示Y轴
    chartView.rightAxis.enabled = NO;//Y上半轴右边刻度线不显示，设置为YES则显示Y轴
//    chartView.leftAxis.spaceTop = 0.98;//Y上半轴最大值占百分比
//    chartView.leftAxis.spaceBottom = 0.1;//Y上半轴最小值占百分比
    chartView.leftAxis.labelFont = EFont(9);
    chartView.leftAxis.drawGridLinesEnabled = NO;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterOrdinalStyle;
    formatter.maximumFractionDigits = 0;
    formatter.maximumIntegerDigits = 0;
    chartView.descriptionText = @"W";


    chartView.rightAxis.valueFormatter = [[ChartDefaultAxisValueFormatter alloc] initWithFormatter:formatter];//X轴数据值

    
    //不显示底部图表说明
    ChartLegend *legend = _lineChartView.legend;
    [legend setEnabled:NO];
    
    
    //折线条设置
    LineChartDataSet *lineDataSet = [[LineChartDataSet alloc] initWithValues:@[] label:@""];
    lineDataSet.drawCubicEnabled = NO;
    lineDataSet.drawSteppedEnabled = NO;
    [lineDataSet setColor:[UIColor getColor:@"efc632"]];//折线条颜色
    lineDataSet.drawFilledEnabled = YES;//显示折线填充色
    lineDataSet.lineWidth = 2;//折线条框度
    lineDataSet.valueTextColor = [UIColor getColor:@"999999"];//数值颜色
    lineDataSet.valueFont = EFont(9);//数值字体
    
//    lineDataSet.drawCircleHoleEnabled = YES;
    [lineDataSet setCircleColor:[UIColor getColor:@"efc632"]];//折线条点颜色
    lineDataSet.circleRadius = 5;//折线点半径
    lineDataSet.circleHoleRadius = 5;//折线点空心半径
    lineDataSet.circleHoleColor = [UIColor getColor:@"efc632"];//折线点空心颜色
    
    
    NSArray *gradientColors = @[
                                (id)RGBColor(233, 163, 58, 0.2).CGColor,
                                (id)RGBColor(255, 153, 0, 1.0).CGColor
                                ];
    CGGradientRef gradient = CGGradientCreateWithColors(nil, (CFArrayRef)gradientColors, nil);//填充色渐变颜色

    lineDataSet.fillAlpha = 0.3f;//填充色透明度
    lineDataSet.fill = [ChartFill fillWithLinearGradient:gradient angle:90.f];

    CGGradientRelease(gradient);
    
    NSArray<id <IChartDataSet>> *lineDataSets = @[lineDataSet];
    
    //折线数据对象
    LineChartData *data = [[LineChartData alloc] initWithDataSets:lineDataSets];
    
    _lineChartView.data = data;//数据源
    
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
//    [self hideEmptyView];
    
    NSMutableArray *yVals = [NSMutableArray array];
    NSMutableArray *xVals = [NSMutableArray array];
    
    for (int i = 0; i< self.datas.count; i++) {
        
        PowerModel *model = self.datas[i];
        
        ChartDataEntry *entry = [[ChartDataEntry alloc] initWithX:i+1 y:[model.avgPowerData floatValue]*1000 icon: [UIImage imageNamed:@""]];
        
        [yVals addObject:entry];
        [xVals addObject:[NSString stringWithFormat:@"%d",i+1]];
    }
    
//    ChartIndexAxisValueFormatter *formatter = [ChartIndexAxisValueFormatter withValues:xVals];
//
//    _lineChartView.xAxis.valueFormatter = formatter;//X轴数据值
    _lineChartView.xAxis.axisRange = self.datas.count;//x轴刻度范围
//    _lineChartView.visibleXRange = self.datas.count/2;

    _lineChartView.xAxis.labelCount = self.datas.count/3;//x轴刻度个数

    LineChartDataSet *lineDataSet = nil;
    if (_lineChartView.data.dataSetCount > 0)
    {
        lineDataSet = (LineChartDataSet *)_lineChartView.data.dataSets[0];
        lineDataSet.values = yVals;//y轴数据值
        [_lineChartView.data notifyDataChanged];//数据更新通知
        [_lineChartView notifyDataSetChanged];
        
    }
    
    if (self.datas.count>0) {

//        [_lineChartView resetZoom];
        [_lineChartView setVisibleXRangeMaximum:self.datas.count/3];
//        [_lineChartView zoomWithScaleX:2 scaleY:1 x:0 y:0];

    }

    
    //x方向动画
    [_lineChartView animateWithXAxisDuration:2 easingOption:ChartEasingOptionEaseInQuad];
    
    
}

#pragma mark - getter and setter

- (LineChartView *)lineChartView
{
    if (!_lineChartView) {
        _lineChartView = [[LineChartView alloc] init];
//        _lineChartView.userInteractionEnabled = NO;
        
        [self setupBarLineChartView:_lineChartView];
        
    }
    
    return _lineChartView;
}



- (void)setDatas:(NSArray *)datas
{
    if (_datas != datas) {
        _datas = [datas copy];
        
        [self setNeedsLayout];
        [self layoutIfNeeded];
    }
}

- (void)setTitle:(NSString *)title
{
    [self.name setText:title];
    if ([title containsString:Localize(@"每小时")]) {
        self.lineChartView.descriptionText = Localize(@"(手势左右滑动查看每小时的平均用电功率)时");
    }else if ([title containsString:Localize(@"每日")])
    {
        self.lineChartView.descriptionText = Localize(@"(手势左右滑动查看每天的平均用电功率)天");
    }

}


@end
