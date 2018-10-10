//
//  WithdrawalsView.m
//  Bohan
//
//  Created by summer on 2018/9/20.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import "WithdrawalsView.h"
#import "UIColor+JGHexColor.h"
#import "NewFinancialCARDSController.h"
#import "NormalCustomCell.h"
#import "CustomTableViewCell.h"

@interface WithdrawalsView ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate> {
    NSDate *_startDate;
}

typedef void(^doneBlock)(NSDate *data);
@property (nonatomic,strong)doneBlock doneBlock;
@property (nonatomic,assign)NSInteger datePickerStyle;

@end

@implementation WithdrawalsView

/**
 空白VIEW
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
    self.Ttableview.separatorStyle = UITableViewCellSeparatorStyleNone;  //隐藏tableview多余的线条
    _images = @[@"AlpayPay",@"WechatPay"];
    _titles = @[@"支付宝",@"微信"];
    self.buttomView.layer.cornerRadius = 10;
    self.buttomView.layer.masksToBounds = YES;
    self.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
                
    [self.Ttableview registerNib:[UINib nibWithNibName:@"NormalCustomCell" bundle:nil] forCellReuseIdentifier:@"NormalCustomCell"];
    [self.Ttableview registerNib:[UINib nibWithNibName:@"CustomTableViewCell" bundle:nil] forCellReuseIdentifier:@"CustomTableViewCell"];

//    //点击背景是否影藏
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
//    tap.delegate = self;
//    [self addGestureRecognizer:tap];
    [self layoutIfNeeded];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];
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
    [self dismiss];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
    NormalCustomCell * cell = [tableView dequeueReusableCellWithIdentifier:@"NormalCustomCell"];
    cell.TitleLabelS.text = _titles[indexPath.row];
    cell.imageS.image = [UIImage imageNamed:_images[indexPath.row]];
    return cell;
    }else {
        CustomTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CustomTableViewCell"];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (self.selectValue) {
            self.selectValue(indexPath.row);
        }
        [self dismiss];
    }else {
        ZPLog(@"111");
    }
}

@end
