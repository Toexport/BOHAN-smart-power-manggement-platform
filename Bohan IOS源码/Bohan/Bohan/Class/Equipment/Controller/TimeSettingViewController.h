//
//  TimeSettingViewController.h
//  Bohan
//
//  Created by Yang Lin on 2018/1/19.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import "BaseViewController.h"

@interface TimeSettingViewController : BaseViewController
{
    __weak IBOutlet UILabel *status;
    //    __weak IBOutlet UILabel *status;
    __weak IBOutlet UILabel *openCount;
    __weak IBOutlet UILabel *closeCount;
    __weak IBOutlet UICollectionView *modelCollectionView;
    __weak IBOutlet NSLayoutConstraint *modelConstraintHeight;
    __weak IBOutlet UIButton *settingBtn;
    __weak IBOutlet UIView *loopView;
    
}
@property (nonatomic, copy) NSString *deviceNo;
- (IBAction)settingAction;

- (IBAction)openAction;
- (IBAction)cancelAction;
- (IBAction)perideRunCancel;
@end
