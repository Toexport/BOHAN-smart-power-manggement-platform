//
//  MyAccountTableViewCell.h
//  Bohan
//
//  Created by summer on 2018/9/5.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyAccountTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *TitleLabel; // 主标题
@property (weak, nonatomic) IBOutlet UILabel *MoneyLabel; // 价格
@property (weak, nonatomic) IBOutlet UIImageView *imageViewS;

@end
