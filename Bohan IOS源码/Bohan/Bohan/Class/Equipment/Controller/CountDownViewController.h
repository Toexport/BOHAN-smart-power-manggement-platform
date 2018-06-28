//
//  CountDownViewController.h
//  Bohan
//
//  Created by Yang Lin on 2018/1/26.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import "BaseViewController.h"

@interface CountDownViewController : BaseViewController

@property (nonatomic, copy) NSString *deviceNo;
@property (nonatomic, assign) BOOL *isCountDownModel;
- (IBAction)cancelAction;

@end
