//
//  shareView.m
//  Bohan
//
//  Created by summer on 2018/9/27.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import "shareView.h"
#import "UIColor+JGHexColor.h"
@interface shareView ()<UIGestureRecognizerDelegate> {
    NSDate *_startDate;
}
typedef void(^doneBlock)(NSDate *data);
@property (nonatomic,strong)doneBlock doneBlock;
@property (nonatomic,assign)NSInteger datePickerStyle;

@end

@implementation shareView

/**
 VIEW
 */
-(instancetype)initWithDateStyle:(NSInteger)datePickerStyle BlankBlock:(SelectValue)completeBlock {
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] lastObject];
        [self setupUI];
        self.selectValue = completeBlock;
    }
    return self;
}


-(void)setupUI {
    self.ButtomView.layer.cornerRadius = 10;
    self.ButtomView.layer.masksToBounds = YES;
    self.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    //    //点击背景是否影藏
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
    [self layoutIfNeeded];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];
}

#pragma mark - Action
-(void)show {
    self.alpha = 0;
    self.ButtomView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 0);
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:.3 animations:^{
        self.alpha = 1;
        self.ButtomView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-319, [UIScreen mainScreen].bounds.size.width, 319);
        [self layoutIfNeeded];
    }];
}

-(void)dismiss {
    [UIView animateWithDuration:.3 animations:^{
        self.alpha = 0;
        self.ButtomView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 0);
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self removeFromSuperview];
    }];
}

- (IBAction)CancelButton:(UIButton *)sender {
    [self dismiss];
}

@end
