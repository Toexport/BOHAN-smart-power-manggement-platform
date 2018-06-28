//
//  DeviceTableViewCell.m
//  Bohan
//
//  Created by Yang Lin on 2018/1/1.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import "DeviceTableViewCell.h"
#import "DeviceModel.h"

@interface DeviceTableViewCell ()
{
    __weak IBOutlet UILabel *name;
    __weak IBOutlet UILabel *deviceId;
    __weak IBOutlet UILabel *type;
    __weak IBOutlet UILabel *pos;
    
}
@end

@implementation DeviceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(DeviceModel *)model
{
    if (_model != model) {
        _model = model;
        [self setNeedsLayout];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [name  setText:[NSString stringWithFormat:@"%@：%@",Localize(@"名称"),self.model.name]];
    [deviceId  setText:[NSString stringWithFormat:@"ID：%@",self.model.id]];
    [type  setText:[NSString stringWithFormat:@"%@：%@",Localize(@"类型"),self.model.type]];
    [pos  setText:[NSString stringWithFormat:@"%@：%@",Localize(@"位置"),self.model.position]];
    
}
@end
