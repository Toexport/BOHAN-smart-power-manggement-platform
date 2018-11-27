//
//  RemindTableViewCell.m
//  Bohan
//
//  Created by summer on 2018/9/13.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import "RemindTableViewCell.h"
#import "MarqueeView.h"
@implementation RemindTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self addSubview:self.marqueeView];
}

#pragma Lazy Methods
- (MarqueeView *)marqueeView{
    if (!_marqueeView) {
        MarqueeView *marqueeView =[[MarqueeView alloc]initWithFrame:CGRectMake(35, 0, ZP_Width, 50) withTitle:@[@"一小时内温度-99度,以上报告超过10次",@"桩点故障5次,以上报告超过5次",@"充电故障10次,以上报告超过15次",@"设备离线异常10次,以上报告超过8次",@"充电故障5次,以上报告超过7次"]];
        marqueeView.titleColor = [UIColor blackColor];
        marqueeView.titleFont = [UIFont systemFontOfSize:11];
        __weak MarqueeView *marquee = marqueeView;
        marqueeView.handlerTitleClickCallBack = ^(NSInteger index){
            ZPLog(@"%@----%zd",marquee.titleArr[index-1],index);
        };
        _marqueeView = marqueeView;
    }
    return _marqueeView;
}

@end
