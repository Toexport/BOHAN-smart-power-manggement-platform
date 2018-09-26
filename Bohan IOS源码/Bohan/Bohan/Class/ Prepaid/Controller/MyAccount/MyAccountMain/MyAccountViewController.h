//
//  MyAccountViewController.h
//  Bohan
//
//  Created by summer on 2018/9/4.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyAccountViewController : UIViewController
@property (nonatomic, copy) NSString * deviceId;
@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;
@property (weak, nonatomic) IBOutlet UITableView *Tableview;


@end
