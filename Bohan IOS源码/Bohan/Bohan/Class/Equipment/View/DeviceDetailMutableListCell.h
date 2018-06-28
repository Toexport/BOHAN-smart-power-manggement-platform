//
//  DeviceDetailMutableListCell.h
//  Bohan
//
//  Created by Yang Lin on 2018/5/12.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DeviceModel;
@class DeviceDetailMutableListCellDelegate;

@protocol DeviceDetailMutableListCellDelegate <NSObject>

@required
- (void)didSwitchOpen:(BOOL)isOpen switchCode:(NSString *)code withIndexPath:(NSIndexPath *)indexPath;

@end

@interface DeviceDetailMutableListCell : UITableViewCell

@property (nonatomic, strong)DeviceModel *model;
@property (nonatomic, weak) id<DeviceDetailMutableListCellDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end
