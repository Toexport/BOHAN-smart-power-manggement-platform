//
//  TimeSelectViewController.h
//  Bohan
//
//  Created by Yang Lin on 2018/1/17.
//  Copyright © 2018年 Bohan. All rights reserved.
//



#import "BaseViewController.h"
@class TimeSettingModel;

typedef void(^TimeBlock)(TimeSettingModel *model);


@interface TimeSelectViewController : BaseViewController
{
    __weak IBOutlet UILabel *startTime;
    __weak IBOutlet UILabel *endTime;
    
}
@property (nonatomic, strong) TimeSettingModel *model;
@property (nonatomic, copy) TimeBlock timeBlock;
@property (nonatomic, assign) BOOL isParentModel;

- (IBAction)startTimeAction;
- (IBAction)endTimeAction;

- (IBAction)checkAction:(UIButton *)sender;
- (IBAction)resetAction;
- (IBAction)cancelAction;
- (IBAction)okAction;

@end
