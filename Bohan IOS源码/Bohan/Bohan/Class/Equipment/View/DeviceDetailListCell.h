//
//  DeviceDetailListCell.h
//  Bohan
//
//  Created by Yang Lin on 2018/1/9.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DeviceModel;
@class DeviceDetailListCellDelegate;

@protocol DeviceDetailListCellDelegate <NSObject>

@required
- (void)didSwitchOpen:(BOOL)isOpen withIndexPath:(NSIndexPath *)indexPath;

@end

@interface DeviceDetailListCell : UITableViewCell

@property (nonatomic, strong)DeviceModel *model;
@property (nonatomic, weak) id<DeviceDetailListCellDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;
@end
