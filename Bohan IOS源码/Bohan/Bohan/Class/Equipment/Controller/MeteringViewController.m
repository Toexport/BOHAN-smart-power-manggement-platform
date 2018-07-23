//
//  MeteringViewController.m
//  Bohan
//
//  Created by Yang Lin on 2018/1/17.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import "MeteringViewController.h"
#import "DebuggingANDPublishing.pch"
@interface MeteringViewController ()
{
    __weak IBOutlet UIView *lastView;
    __weak IBOutlet UILabel *startTime;
    __weak IBOutlet UILabel *startDate;
    __weak IBOutlet UILabel *endDate;
    __weak IBOutlet UILabel *endTime;
    __weak IBOutlet UILabel *totalTime;
    __weak IBOutlet UILabel *totalElec;
    
    __weak IBOutlet UILabel *cStartDate;
    __weak IBOutlet UILabel *cStartTime;
    __weak IBOutlet UILabel *cEndDate;
    __weak IBOutlet UILabel *cEndTime;
    __weak IBOutlet UILabel *cTotalTime;
    NSDateFormatter *formatter;
    NSString *start;
    NSString *end;

}
@end

@implementation MeteringViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = Localize(@"定时计量");
    
    formatter = [[NSDateFormatter alloc] init];
    [self loadData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidLayoutSubviews
{
//    [modelCollectionView.superview setFrame:CGRectChangeHeight(modelCollectionView.superview.frame, modelCollectionView.contentSize.height + 72)];
//    [modelCollectionView setFrame:CGRectChangeHeight(modelCollectionView.frame, 260)];
    
    [(UIScrollView *)self.view setContentSize:CGSizeMake(ScreenWidth, 550)];
}


- (IBAction)timeSelect:(UIButton *)sender {
    
    NSString *string;
    if (sender.tag == 300) {

        if (![cStartDate.text isEqualToString:Localize(@"选择开始时间")]) {

            string = [cStartDate.text stringByAppendingString:[NSString stringWithFormat:@" %@",cStartTime.text]];
        }
    }else
    {
        if (![cEndDate.text isEqualToString:Localize(@"选择结束时间")]) {

            string = [cEndDate.text stringByAppendingString:[NSString stringWithFormat:@" %@",cEndTime.text]];
        }

    }
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDayHourMinute scrollToDate:[formatter dateFromString:string] CompleteBlock:^(NSDate *selectDate) {
        
        if (sender.tag == 300)
        {
            [formatter setDateFormat:@"yyyy-MM-dd"];
            [cStartDate setText:[formatter stringFromDate:selectDate]];
            
            [formatter setDateFormat:@"HH:mm:ss"];
            [cStartTime setText:[formatter stringFromDate:selectDate]];
            
            [formatter setDateFormat:@"yyMMddHHmmss"];
            start = [formatter stringFromDate:selectDate];
            
        }else
        {
            [formatter setDateFormat:@"yyyy-MM-dd"];
            [cEndDate setText:[formatter stringFromDate:selectDate]];
            
            [formatter setDateFormat:@"HH:mm:ss"];
            [cEndTime setText:[formatter stringFromDate:selectDate]];
            
            [formatter setDateFormat:@"yyMMddHHmmss"];
            end = [formatter stringFromDate:selectDate];
            
        }
        
        if (start.length>0 && end.length>0) {

            [cTotalTime setText:[Utils gapDateFrom:[formatter dateFromString:start] toDate:[formatter dateFromString:end]]];
        }
    }];

    datepicker.hideBackgroundYearLabel = YES;
    datepicker.dateLabelColor = kDefualtColor;
    datepicker.doneButtonColor = kDefualtColor;
    [datepicker show];
    
}

- (void)loadData{
    
    WebSocket *socket = [WebSocket socketManager];
    CommandModel *model = [[CommandModel alloc] init];
    model.command = @"0007";
    model.deviceNo = self.deviceNo;
    [self.view startLoading];
    
    MyWeakSelf
    [socket sendSingleDataWithModel:model resultBlock:^(id response, NSError *error) {
        [weakSelf.view stopLoading];
        
        if (!error) {
            
            if (((NSString *)response).length>56) {
                
                [formatter setDateFormat:@"yyMMddHHmmss"];

                NSDate *startD = [formatter dateFromString:[response substringWithRange:NSMakeRange(24, 12)]];
                NSDate *endD = [formatter dateFromString:[response substringWithRange:NSMakeRange(36, 12)]];
                NSString *elecStr = [response substringWithRange:NSMakeRange(48, 8)];
                
                [formatter setDateFormat:@"yyyy-MM-dd"];
                [startDate setText:[formatter stringFromDate:startD]];
                [endDate setText:[formatter stringFromDate:endD]];

                [formatter setDateFormat:@"HH:mm:ss"];
                [startTime setText:[formatter stringFromDate:startD]];
                [endTime setText:[formatter stringFromDate:endD]];
                
                [totalTime setText:[Utils gapDateFrom:startD toDate:endD]];
                [totalElec setText:[NSString stringWithFormat:@"%d.%02dkWh",[[elecStr substringToIndex:6] intValue],[[elecStr substringFromIndex:2] intValue]]];

            }

            
        }else
        {
            [HintView showHint:error.localizedDescription];
        }
        
        ZPLog(@"--------%@",response);
    }];
}

- (IBAction)startAction {
    
    
    if ([cStartDate.text isEqualToString:Localize(@"选择开始时间")] || [cEndDate.text isEqualToString:Localize(@"选择结束时间")]) {

        [HintView showHint:Localize(@"选择时间")];
        return;
    }else{
        
        [formatter setDateFormat:@"yyMMddHHmmss"];
        
        if ([[formatter dateFromString:start] isEarlierThanDate:[NSDate date]]){
        [HintView showHint:Localize(@"开始时间必须大于当前时间")];
        return;
            
        }else if ([[formatter dateFromString:end] isEarlierThanDate:[formatter dateFromString:start]])
        {
            [HintView showHint:Localize(@"结束时间必须大于开始时间")];
            return;
        }
    }
    WebSocket *socket = [WebSocket socketManager];
    CommandModel *model = [[CommandModel alloc] init];
    model.command = @"0006";
    model.deviceNo = self.deviceNo;
    
    model.content = [start stringByAppendingString:end];
    [self.view startLoading];
    
    MyWeakSelf
    [socket sendSingleDataWithModel:model resultBlock:^(id response, NSError *error) {
        [weakSelf.view stopLoading];
        
        if (!error) {
            [HintView showHint:Localize(@"定时计量已提交")];
        }else
        {
            [HintView showHint:error.localizedDescription];
        }
        
    }];
}
@end
