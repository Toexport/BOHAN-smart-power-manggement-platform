//
//  EquipmentTableViewCell.h
//  Bohan
//
//  Created by Yang Lin on 2017/12/26.
//  Copyright © 2017年 Bohan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EquipmentTableViewCellDelegate;

@protocol EquipmentTableViewCellDelegate <NSObject>


- (void)openAndCloseAll:(BOOL)isOpen name:(NSString *)name;
@end

@interface EquipmentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (nonatomic, weak) id<EquipmentTableViewCellDelegate> delegate;
@end
