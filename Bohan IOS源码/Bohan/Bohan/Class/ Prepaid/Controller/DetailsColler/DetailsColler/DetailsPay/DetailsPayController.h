//
//  DetailsPayController.h
//  Bohan
//
//  Created by summer on 2018/9/7.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailsPayController : UIViewController
//@property (nonatomic, assign) NSInteger type; // 识别号
@property (weak, nonatomic) IBOutlet UITableView *Tableview;
@property (nonatomic, strong) NSString * DataId;
@end
