//
//  MyAccountViewController.h
//  Bohan
//
//  Created by summer on 2018/9/4.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyAccountViewController : UIViewController
//@property (weak, nonatomic) IBOutlet UILabel *PriceLabel; // 价格
//@property (weak, nonatomic) IBOutlet UIView *PayViews; // 充值View
//@property (weak, nonatomic) IBOutlet UIView *RecordViews; // 记录View
@property (nonatomic, copy) NSString * deviceId;
@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;
@property (weak, nonatomic) IBOutlet UITableView *Tableview;



@end
