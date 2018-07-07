//
//  TimeModelCollectionViewCell.m
//  Bohan
//
//  Created by Yang Lin on 2018/1/25.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import "TimeModelCollectionViewCell.h"
#import "DebuggingANDPublishing.pch"
@implementation TimeModelCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if (selected) {
        
        self.name.layer.borderColor = RGBColor(61, 141, 241, 0.8).CGColor;
        [self.name setBackgroundColor:RGBColor(61, 141, 241, 0.8)];

    }else
    {
        self.name.layer.borderColor = [UIColor getColor:@"cccccc"].CGColor;
        [self.name setBackgroundColor:[UIColor whiteColor]];
    }
}

@end
