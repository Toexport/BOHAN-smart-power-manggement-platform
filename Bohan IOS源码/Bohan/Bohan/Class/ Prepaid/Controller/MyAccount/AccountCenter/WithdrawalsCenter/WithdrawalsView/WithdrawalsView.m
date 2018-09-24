//
//  WithdrawalsView.m
//  Bohan
//
//  Created by summer on 2018/9/20.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import "WithdrawalsView.h"

@interface WithdrawalsView ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate> {
    
    NSDate *_startDate;
}
//bottomConstraint

typedef void(^doneBlock)(NSDate *data);
@property (nonatomic,strong)doneBlock doneBlock;
@property (nonatomic,assign)NSInteger datePickerStyle;

@end

@implementation WithdrawalsView


/**
 空白VIEW
 */
-(instancetype)initWithDateStyle:(NSInteger)datePickerStyle BlankBlock:(void(^)(NSDate *))completeBlock {
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] lastObject];
        [self setupUI];
        if (completeBlock) {
            self.doneBlock = ^(NSDate *selectDate) {
                completeBlock(selectDate);
            };
        }
    }
    return self;
}


-(void)setupUI {
    self.buttomView.layer.cornerRadius = 10;
    self.buttomView.layer.masksToBounds = YES;
//    self.doneButtonColor = RGB(247, 133, 51);
    self.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);

    //点击背景是否影藏
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    [self layoutIfNeeded];

    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];

//    [self.showYearView addSubview:self.datePicker];

}

#pragma mark - Action
-(void)show {
    self.alpha = 0;
    self.buttomView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 0);
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:.3 animations:^{
        self.alpha = 1;
        self.buttomView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-319, [UIScreen mainScreen].bounds.size.width, 319);
        [self layoutIfNeeded];
    }];
}

-(void)dismiss {
    [UIView animateWithDuration:.3 animations:^{
        self.alpha = 0;
        self.buttomView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 0);
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self removeFromSuperview];
    }];
}

- (IBAction)bun:(UIButton *)sender {
    self.doneBlock(_startDate);
    [self dismiss];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}


@end
