//
//  DeviceDetailListCell.m
//  Bohan
//
//  Created by Yang Lin on 2018/1/9.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import "DeviceDetailListCell.h"
#import "DeviceModel.h"
@interface DeviceDetailListCell ()
{
    __weak IBOutlet UILabel *name;
    __weak IBOutlet UILabel *deviceId;
    __weak IBOutlet UILabel *type;
    __weak IBOutlet UILabel *pos;
    __weak IBOutlet UIImageView *typeImg;
    __weak IBOutlet UIImageView *posImg;
    __weak IBOutlet UIImageView *onlineImg;

    __weak IBOutlet UIImageView *statusImg;
    __weak IBOutlet UILabel *online;
    __weak IBOutlet UILabel *status;
    
    __weak IBOutlet UILabel *power;
    __weak IBOutlet UISwitch *openSwitch;
    
}
@end

@implementation DeviceDetailListCell

- (void)setModel:(DeviceModel *)model
{
    _model = model;
    [self setNeedsLayout];
}
- (IBAction)openAction:(UISwitch *)sender {
    
    
    if (sender.isOn) {

        openSwitch.backgroundColor = [UIColor getColor:@"54d76a"];
    }else
    {
        openSwitch.backgroundColor = [UIColor redColor];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSwitchOpen:withIndexPath:)]) {
        
        [self.delegate didSwitchOpen:sender.on withIndexPath:self.indexPath];
    }
}

- (void)prepareForReuse
{
    [super prepareForReuse];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    openSwitch.layer.cornerRadius = 16;

    [name  setText:self.model.name];
    [deviceId  setText:[NSString stringWithFormat:@"%@%@",Localize(@"设备号："),self.model.id]];
    [type  setText:self.model.type];
    [pos  setText:self.model.position];
    
    if (self.model.powerinfo && self.model.powerinfo.length>0) {
        
        [online setText:Localize(@"在线")];
        typeImg.highlighted = YES;
        posImg.highlighted = YES;
        onlineImg.highlighted = YES;
        [openSwitch setOn:self.model.isOpen];
        openSwitch.enabled = YES;

        NSString *statusStr = [self.model.powerinfo status];
        
        if (self.model.isOpen) {
            
            openSwitch.backgroundColor = [UIColor getColor:@"54d76a"];
            [statusImg setImage:[UIImage imageNamed:@"open_open"]];

        }else
        {
            openSwitch.backgroundColor = [UIColor redColor];
            [statusImg setImage:[UIImage imageNamed:@"open_close"]];

        }
//
//        switch ([statusStr integerValue]) {
//            case 5:
//            case 6:
//            {
//                [statusImg setImage:[UIImage imageNamed:@"open_close"]];
////                openSwitch.backgroundColor = [UIColor redColor];
//            }
//                break;
//
//            default:
//            {
//                [statusImg setImage:[UIImage imageNamed:@"open_open"]];
////                openSwitch.backgroundColor = [UIColor getColor:@"54d76a"];
//
//            }
//                break;
//        }
//        @"设备已断电(设备超负荷)"
        
        NSString *str = [Utils getBinaryByHex:[self.model.powerinfo substringToIndex:2]];
        if (!self.model.isOpen && [[str substringWithRange:NSMakeRange(1, 1)] isEqualToString:@"1"]) {
            [status setText:Localize(@"设备已断电(超负荷断电)")];
            
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:status.text];
            
            NSUInteger length = Localize(@"超负荷断电").length;
            [attr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(attr.length - length - 1, length)];
            status.attributedText = attr;

        }else
        {
            [status setText:[statusStr statusString]];
        }
        [power setText:[self.model.powerinfo power]];
        
    }else
    {
        typeImg.highlighted = NO;
        posImg.highlighted = NO;
        onlineImg.highlighted = NO;
        openSwitch.on = NO;
        openSwitch.enabled = NO;
        [statusImg setImage:[UIImage imageNamed:@"open_offline"]];
        openSwitch.backgroundColor = [UIColor getColor:@"e4e4e4"];

        [online setText:Localize(@"离线")];
        [status setText:Localize(@"设备已离线")];
        [power setText:@"0.00W"];
    }
    
}


@end
