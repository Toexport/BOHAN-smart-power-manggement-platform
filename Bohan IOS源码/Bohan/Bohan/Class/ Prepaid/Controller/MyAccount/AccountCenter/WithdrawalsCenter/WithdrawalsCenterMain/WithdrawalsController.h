//
//  WithdrawalsController.h
//  Bohan
//
//  Created by summer on 2018/9/18.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WithdrawalsController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *Tableview;
@property (nonatomic, assign) BOOL isRegist;
@property (nonatomic, strong) NSString * AmountStr;
//@property (nonatomic, strong) NSString * StringId;

@end
