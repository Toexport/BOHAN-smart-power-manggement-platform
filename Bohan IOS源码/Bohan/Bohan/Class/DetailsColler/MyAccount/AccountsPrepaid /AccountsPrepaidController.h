//
//  AccountsPrepaidController.h
//  Bohan
//
//  Created by summer on 2018/9/4.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountsPrepaidController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *Tableview;
@property (nonatomic, strong) NSString * PriceStr;
@property (nonatomic, strong) NSString * PayWayStr;

@end
