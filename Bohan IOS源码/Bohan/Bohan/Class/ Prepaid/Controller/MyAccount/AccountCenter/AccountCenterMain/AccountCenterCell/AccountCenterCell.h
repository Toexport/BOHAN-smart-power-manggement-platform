//
//  AccountCenterCell.h
//  Bohan
//
//  Created by summer on 2018/9/13.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountCenterCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *StoredValueView; // 储值View
@property (weak, nonatomic) IBOutlet UIView *ExtractView; //提取View
@property (weak, nonatomic) IBOutlet UILabel *PriceLabel; // 价格
typedef void (^ExtractBlock)(id ExtractView);
@property (nonatomic , copy) ExtractBlock ExtractBlockBlock;
typedef void (^StoredValueBlock)(id StoredValueView);
@property (nonatomic , copy) StoredValueBlock StoredValueBlockBlock;
@end
