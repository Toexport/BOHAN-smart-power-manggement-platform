//
//  RealTimeParamTableViewCell.m
//  Bohan
//
//  Created by Yang Lin on 2018/1/16.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import "RealTimeParamTableViewCell.h"

@interface RealTimeParamTableViewCell ()
{
    __weak IBOutlet UILabel *name;
    __weak IBOutlet UILabel *content;
    __weak IBOutlet UILabel *unit;
    
}

@end

@implementation RealTimeParamTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
