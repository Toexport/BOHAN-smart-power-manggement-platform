//
//  WithdrawalsView.m
//  Bohan
//
//  Created by summer on 2018/9/20.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import "WithdrawalsView.h"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kPickerSize self.datePicker.frame.size
#define RGBA(r, g, b, a) ([UIColor colorWithRed:(r / 255.0) green:(g / 255.0) blue:(b / 255.0) alpha:a])
#define RGB(r, g, b) RGBA(r,g,b,1)
// 判断是否是iPhone X
#define isiPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
// home indicator
#define bottom_height (isiPhoneX ? 34.f : 10.f)


#define MAXYEAR 2099
#define MINYEAR 1000

@interface WithdrawalsView ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate> {
    
    NSDate *_startDate;
}
@property (weak, nonatomic) IBOutlet UIView *buttomView;
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;
@property (weak, nonatomic) IBOutlet UITableView *Ttableview;
//bottomConstraint

typedef void(^doneBlock)(NSDate *data);
@property (nonatomic,strong)doneBlock doneBlock;
@property (nonatomic,assign)WSDateStyle datePickerStyle;

@end

@implementation WithdrawalsView


/**
 空白VIEW
 */
-(instancetype)initWithDateStyle:(WSDateStyle)datePickerStyle BlankBlock:(void(^)(NSDate *))completeBlock {
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
    self.frame=CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    
    //点击背景是否影藏
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    self.backgroundColor = RGBA(0, 0, 0, 0);
    [self layoutIfNeeded];
    
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];
    
//    [self.showYearView addSubview:self.datePicker];
    
}

#pragma mark - Action
-(void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:.3 animations:^{
        self.backgroundColor = RGBA(0, 0, 0, 0.4);
        [self layoutIfNeeded];
    }];
}

-(void)dismiss {
    [UIView animateWithDuration:.3 animations:^{
        self.backgroundColor = RGBA(0, 0, 0, 0);
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
