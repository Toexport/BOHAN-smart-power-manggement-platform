//
//  TimeSelectViewController.m
//  Bohan
//
//  Created by Yang Lin on 2018/1/17.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import "TimeSelectViewController.h"
#import "TimeSettingModel.h"
#import "SGActionView.h"
#import "DebuggingANDPublishing.pch"
@interface TimeSelectViewController ()
{
    NSDateFormatter *formatter;

}
@end

@implementation TimeSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = Localize(@"时间选择");
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];

//    if (@available(iOS 11.0, *)){
//        [(UIScrollView *)self.view setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
//    }else
//    {
//        self.automaticallyAdjustsScrollViewInsets = NO;
//    }

    
    [self configView];

    
}


- (void)configView
{
    if (self.model) {
        
        [startTime setText:self.model.startTime];
        [endTime setText:self.model.endTime];
        
        NSString *week = [Utils getBinaryByHex:self.model.week];
        
        for (int i = 1; i< 8; i++) {
            int bit = 7-i;
            if (i == 7) {
                bit = 7;
            }
            NSString *value = [week substringWithRange:NSMakeRange(bit, 1)];
            
            UIButton *btn = [self.view viewWithTag:700+i];
            btn.selected = [value boolValue];
            
        }
        
    }
}
//- (void)viewDidLayoutSubviews
//{
////    NSLog(@"((UIScrollView *)self.view).contentSize.height=%f",((UIScrollView *)self.view).contentSize.height);
//    [(UIScrollView *)self.view setContentSize:CGSizeMake(ScreenWidth, MIN(((UIScrollView *)self.view).contentSize.height, 503))];
//}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)startTimeAction {
    
    WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowHourMinute scrollToDate:[formatter dateFromString:startTime.text] CompleteBlock:^(NSDate *selectDate) {
        [startTime setText:[formatter stringFromDate:selectDate]];

    }];
    datepicker.hideBackgroundYearLabel = YES;
    datepicker.dateLabelColor = kDefualtColor;
    datepicker.doneButtonColor = kDefualtColor;
    [datepicker show];
    
}

- (IBAction)endTimeAction {
    
    
    WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowHourMinute scrollToDate:[formatter dateFromString:endTime.text] CompleteBlock:^(NSDate *selectDate) {
        [endTime setText:[formatter stringFromDate:selectDate]];

    }];
    datepicker.hideBackgroundYearLabel = YES;
    datepicker.dateLabelColor = kDefualtColor;
    datepicker.doneButtonColor = kDefualtColor;
    [datepicker show];


}

- (IBAction)checkAction:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
}

- (IBAction)resetAction {
    
    [self configView];
    
}

- (IBAction)cancelAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)okAction {
    
    
    if (![[formatter dateFromString:endTime.text] isLaterThanDate:[formatter dateFromString:startTime.text]])
    {
        [HintView showHint:Localize(@"结束时间必须大于开始时间")];
        return;
    }
    
    
//    NSString *week = [Utils getBinaryByHex:_model.week];
//
//    if ([[week substringFromIndex:1] isEqualToString:@"0000000"]) {
//
//    }
    
    if (self.timeBlock) {
        
        NSString *str = @"";
        for (int i = 6; i>0; i--) {
            
            UIButton *btn = [self.view viewWithTag:700+i];
            str = [str stringByAppendingString:[@(btn.selected) stringValue]];
        }
        
        str = [str stringByAppendingString:[@(((UIButton *)[self.view viewWithTag:707]).selected) stringValue]];
        
        NSString *week = [Utils getBinaryByHex:self.model.week];
        
        week = [week stringByReplacingCharactersInRange:NSMakeRange(1, 7) withString:str];
        
        self.model.startTime = startTime.text;
        self.model.endTime = endTime.text;
        self.model.open = YES;
        
        self.model.week = [Utils getHexByBinary:week];
        self.timeBlock(self.model);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
