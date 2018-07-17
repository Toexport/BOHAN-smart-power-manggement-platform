//
//  DeviceDetailListCell.m
//  Bohan
//
//  Created by Yang Lin on 2018/1/9.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import "DeviceDetailListCell.h"
#import "DeviceModel.h"
#import "DebuggingANDPublishing.pch"
@interface DeviceDetailListCell () {
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
}else {
    
    openSwitch.backgroundColor = [UIColor redColor];
}

if (self.delegate && [self.delegate respondsToSelector:@selector(didSwitchOpen:withIndexPath:)]) {
    
    [self.delegate didSwitchOpen:sender.on withIndexPath:self.indexPath];
}
}

- (void)prepareForReuse {
[super prepareForReuse];
}

- (void)layoutSubviews {
[super layoutSubviews];
openSwitch.layer.cornerRadius = 16;
[name setText:self.model.name];
[deviceId  setText:[NSString stringWithFormat:@"%@%@",Localize(@"设备号："),self.model.id]];
[type  setText:self.model.type];
[pos  setText:self.model.position];

if (self.model.powerinfo && self.model.powerinfo.length>0) {
    [online setText:Localize(@"在线")];
    if ([self.model.sort containsString:@"QK01"] || [self.model.sort containsString:@"QK02"] || [self.model.sort containsString:@"QK03"] || [self.model.sort containsString:@"K"]) {
        typeImg.image = [UIImage imageNamed:@"Switch-open.png"];
    }
        if ([self.model.sort containsString:@"CDMT10"] || [self.model.sort containsString:@"CDMT16"] || [self.model.sort containsString:@"QC10"] || [self.model.sort containsString:@"QC13"] || [self.model.sort containsString:@"QC15"] || [self.model.sort containsString:@"QC16"] || [self.model.sort containsString:@"YC10"] || [self.model.sort containsString:@"YCGP10"] || [self.model.sort containsString:@"YC13"] || [self.model.sort containsString:@"YC15"] || [self.model.sort containsString:@"YC16"] || [self.model.sort containsString:@"YCGP16"] || [self.model.sort containsString:@"YC"] || [self.model.sort containsString:@"QC"]) {
            typeImg.image = [UIImage imageNamed:@"device_list_socket"];
        }
            if ([self.model.sort containsString:@"CDMT60"] || [self.model.sort containsString:@"GP1P"] || [self.model.sort containsString:@"WFMT"]) {
                typeImg.image = [UIImage imageNamed:@"Electric-meter.png"];
            }
                if ([self.model.sort containsString:@"YFMT"] || [self.model.sort containsString:@"YFGPMT"]) {
                    typeImg.image = [UIImage imageNamed:@"purse.png"];
            }
                if ([self.model.sort containsString:@"MC"]) {
                    typeImg.image = [UIImage imageNamed:@"Electric-meter.png"];
                }
    typeImg.highlighted = YES;
    posImg.highlighted = YES;
    onlineImg.highlighted = YES;
    [openSwitch setOn:self.model.isOpen];
    openSwitch.enabled = YES;

    NSString *statusStr = [self.model.powerinfo status];
    
    if (self.model.isOpen) {
        openSwitch.backgroundColor = [UIColor getColor:@"54d76a"];
        [statusImg setImage:[UIImage imageNamed:@"open_open"]];

    }else {
        openSwitch.backgroundColor = [UIColor redColor];
        [statusImg setImage:[UIImage imageNamed:@"open_close"]];
    }
    
    NSString * str = [Utils getBinaryByHex:[self.model.powerinfo substringToIndex:2]];
    if (!self.model.isOpen && [[str substringWithRange:NSMakeRange(1, 1)] isEqualToString:@"1"]) {
        [status setText:Localize(@"设备已断电(超负荷断电)")];
        
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:status.text];
        
        NSUInteger length = Localize(@"超负荷断电").length;
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(attr.length - length - 1, length)];
        status.attributedText = attr;

    }else {
        [status setText:[statusStr statusString]];
    }
    NSString * strin = self.model.sort;
    NSString * string = self.model.id;
    if ([string substringToIndex:2]) {
        NSString * stringg = string;
        if ([stringg hasPrefix:@"68"] || [string hasPrefix:@"67"]) {
            ZPLog(@"包含");
            [power setText:[self.model.powerinfo power]];  //用电信息
        }
            if ([stringg hasPrefix:@"64"]) {
                if ([strin containsString:@"CDMT60"]) {
                    ZPLog(@"带小数点");
                    [power setText:[self.model.powerinfo powerr]];
                }else {
                    ZPLog(@"不带带小数点");
                    [power setText:[self.model.powerinfo powerrNo]];
                }
            }else
                if ([stringg hasPrefix:@"66"]) {
                    if ([strin containsString:@"WFMT"]) {
                        ZPLog(@"有小数点");
                        [power setText:[self.model.powerinfo powerrr]];  //用电信息
                    }else {
                        ZPLog(@"没有数点");
                        [power setText:[self.model.powerinfo powerNo]];
                    }
                    
                }else if ([stringg hasPrefix:@"65"]){
                    if ([strin containsString:@"GP1P"]) {
                        ZPLog(@"有小数点");
                        [power setText:[self.model.powerinfo powerrrr]];
                    }else {
                        ZPLog(@"没有小数点");
                        [power setText:[self.model.powerinfo powerrrrNo]];
                    }
                }else
                    if ([stringg hasPrefix:@"60"]) {
                    if ([strin containsString:@"YFMT"]) {
//                        [power setText:[self.model.powerinfo powwerrrrNo]];
                        ZPLog(@"没有小数点");
                    }else {
//                        [power setText:[self.model.powerinfo powerrrrNo]];
                        ZPLog(@"有小数点");
                    } if ([strin containsString:@"YFGPMT"]) {
                        [power setText:[self.model.powerinfo powwerrrrNo]];
                        ZPLog(@"没有小数点");
                    }else {
//                        [power setText:[self.model.powerinfo powerrrr]];
                        ZPLog(@"有小数点");
                }
                    
                }
    }
}else
{
    if ([self.model.sort containsString:@"QK01"] || [self.model.sort containsString:@"QK02"] || [self.model.sort containsString:@"QK03"] || [self.model.sort containsString:@"K"]) {
        typeImg.image = [UIImage imageNamed:@"Switch-close.png"];
    }
        if ([self.model.sort containsString:@"CDMT10"] || [self.model.sort containsString:@"CDMT16"] || [self.model.sort containsString:@"QC10"] || [self.model.sort containsString:@"QC13"] || [self.model.sort containsString:@"QC15"] || [self.model.sort containsString:@"QC16"] || [self.model.sort containsString:@"YC10"] || [self.model.sort containsString:@"YCGP10"] || [self.model.sort containsString:@"YC13"] || [self.model.sort containsString:@"YC15"] || [self.model.sort containsString:@"YC16"] || [self.model.sort containsString:@"YCGP16"] || [self.model.sort containsString:@"YC"] || [self.model.sort containsString:@"QC"]) {
            typeImg.image = [UIImage imageNamed:@"device_list_socket_no"];
        }
            if ([self.model.sort containsString:@"CDMT60"] || [self.model.sort containsString:@"GP1P"] || [self.model.sort containsString:@"WFMT"]) {
                typeImg.image = [UIImage imageNamed:@"Electric-meterGrey.png"];
            }
                if ([self.model.sort containsString:@"YFMT"] || [self.model.sort containsString:@"YFGPMT"]) {
                    typeImg.image = [UIImage imageNamed:@"purse_grey.png"];
            }
                if ([self.model.sort containsString:@"MC"]) {
                    typeImg.image = [UIImage imageNamed:@"Electric-meterGrey.png"];
            }
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
