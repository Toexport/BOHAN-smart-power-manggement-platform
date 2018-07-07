//
//  EquipmentTableViewCell.m
//  Bohan
//
//  Created by Yang Lin on 2017/12/26.
//  Copyright © 2017年 Bohan. All rights reserved.
//

#import "EquipmentTableViewCell.h"
#import "DebuggingANDPublishing.pch"
@interface EquipmentTableViewCell ()
{
    __weak IBOutlet UIButton *openBtn;
    __weak IBOutlet UIButton *closeBtn;
    
}
@end

@implementation EquipmentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.accessoryView.tintColor = kBackBackroundColor;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)openAction:(UIButton *)sender {
    if (sender.tag == 100) {
    //全开
        if (self.delegate && [self.delegate respondsToSelector:@selector(openAndCloseAll: name:)]) {
            [self.delegate openAndCloseAll:YES name:self.name.text];
        }
    }else {
        //全关
        if (self.delegate && [self.delegate respondsToSelector:@selector(openAndCloseAll: name:)]) {
            [self.delegate openAndCloseAll:NO name:self.name.text];
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [openBtn setTitle:Localize(@"全开") forState:UIControlStateNormal];
    [closeBtn setTitle:Localize(@"全关") forState:UIControlStateNormal];
}

@end
