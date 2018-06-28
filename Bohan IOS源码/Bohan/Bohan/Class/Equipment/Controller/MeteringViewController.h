//
//  MeteringViewController.h
//  Bohan
//
//  Created by Yang Lin on 2018/1/17.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import "BaseViewController.h"

@interface MeteringViewController : BaseViewController

@property (nonatomic, copy) NSString *deviceNo;

- (IBAction)timeSelect:(UIButton *)sender;
- (IBAction)startAction;
@end
