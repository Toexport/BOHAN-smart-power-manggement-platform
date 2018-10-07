//
//  DetailsViewController.h
//  Bohan
//
//  Created by summer on 2018/9/4.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailsViewController : UIViewController
@property (nonatomic, copy) NSString * deviceNo;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong) NSString * type;

@end
