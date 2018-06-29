//
//  SliderView.m
//  UFA
//
//  Created by YangLin on 2017/8/4.
//  Copyright © 2017年 UFA. All rights reserved.
//

#import "SliderView.h"
#import "DebuggingANDPublishing.pch"
@interface SliderView ()
{
//    UIView *flageView;
    NSMutableArray *itemBtns;
    UIButton *rightBtn;
    NSUInteger currentIndex;
}
@property (nonatomic, strong)UIScrollView *scroll;
@property (nonatomic, strong)UIView *flageView;

@end

@implementation SliderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame datas:(NSArray *)datas
{
    _datas = datas;

    self = [super initWithFrame:frame];
    
    if (self) {
        
        _datas = datas;

        if (_datas.count > 0) {
            
            [self setUp];

        }
    }
    return self;
    
}


- (void)setUp
{
    
    if (self.scroll.superview) {
        
        [self.scroll removeFromSuperview];
    }
    itemBtns = [NSMutableArray array];
    [self addSubview:self.scroll];
    
    CGFloat originX = 0;
    for (int i = 0; i < self.datas.count; i ++) {
        
        NSString *name = self.datas[i];
        CGSize size = getTextSize(Font(15), name, ScreenWidth);
        
        UIButton *btn = [self.scroll viewWithTag:600 +i];
        
        if (!btn) {
            btn = [[UIButton alloc] initWithFrame:CGRectMake(originX, 0, size.width + 15, self.scroll.frame.size.height - 2)];
            [btn.titleLabel setFont:Font(15)];
            [btn setTitleColor:[UIColor getColor:@"333333"] forState:UIControlStateNormal];
            [btn setTitleColor:kDefualtColor forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(btnSelected:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTag:600 +i];

        }
//        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(originX, 0, size.width + 15, self.scroll.frame.size.height - 2)];
//        [btn setBackgroundColor:[UIColor blueColor]];
        [btn setTitle:name forState:UIControlStateNormal];
        
        if (btn.superview != self.scroll) {
            [self.scroll addSubview:btn];
        }
        
        [itemBtns addObject:btn];
        originX = btn.frame.origin.x + btn.frame.size.width;
        
        if (i == 0) {
            btn.selected = YES;
        }
    }
    
//    UIButton *firstBtn = [itemBtns firstObject];
    UIButton *lastBtn = [itemBtns lastObject];
    
    [self.scroll setContentSize:CGSizeMake(lastBtn.frame.origin.x + lastBtn.frame.size.width, self.scroll.frame.size.height)];
    
    if (self.scroll.contentSize.width > self.frame.size.width) {
        
        [self.scroll setFrame:CGRectChangeWidth(self.scroll.frame, self.frame.size.width - 35)];
        rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 35, 0, 35, self.frame.size.height)];
        [rightBtn setImage:[UIImage imageNamed:@"btn_orderlist_pull"] forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(moreClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:rightBtn];
        
    }else if(self.scroll.contentSize.width < self.frame.size.width)
    {
        [self.scroll setContentSize:CGSizeMake(self.frame.size.width, self.scroll.frame.size.height)];
        CGFloat width = self.scroll.frame.size.width / itemBtns.count;
        for (int i = 0; i < itemBtns.count; i++) {
            UIButton *btn = itemBtns[i];
            [btn setFrame:CGRectMake(i * width, 0, width, btn.frame.size.height)];
        }
    }

    if (self.flageView.superview != self.scroll) {
        [self.scroll addSubview:self.flageView];
    }
    
}



- (void)btnSelected:(UIButton *)btn
{
    if (btn.selected) {
        return;
    }
    
    currentIndex = btn.tag - 600;
    if (self.block) {
        self.block(currentIndex);
    }
    for (UIButton *buttom in itemBtns) {
        
        buttom.selected = NO;
    }
    btn.selected = YES;

    [UIView animateWithDuration:0.25 animations:^{
        [self.flageView setCenter:CGPointMake(btn.center.x, self.flageView.center.y)];
    }];

    [self.scroll scrollRectToVisible:CGRectMake(btn.center.x - self.scroll.frame.size.width/2, 0, self.scroll.frame.size.width, self.scroll.frame.size.height) animated:YES];
}


- (void)moreClick
{
    if (self.moreBlock) {
        self.moreBlock(currentIndex);
    }
}


- (void)selectedWithIndex:(NSUInteger)index
{
    [self btnSelected:itemBtns[index]];
}

#pragma mark - setter and getter

- (UIScrollView *)scroll
{
    if (!_scroll) {
        _scroll = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scroll.showsHorizontalScrollIndicator = NO;
        if (@available(iOS 11.0, *)){
            [_scroll setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
        }
//        [_scroll setBackgroundColor:[UIColor whiteColor]];

//        _scroll.pagingEnabled = YES;
    }
    
    return _scroll;
}

- (UIView *)flageView
{
    if (!_flageView) {
        _flageView = [[UIView alloc] initWithFrame:CGRectMake(0, self.scroll.frame.size.height - 2, self.scroll.contentSize.width/itemBtns.count, 2)];
        [_flageView setBackgroundColor:kDefualtColor];

    }
    return _flageView;
}

- (void)setDatas:(NSArray *)datas
{
    if (_datas != datas) {
        _datas = datas;
        
        [self setUp];
    }
}


@end
