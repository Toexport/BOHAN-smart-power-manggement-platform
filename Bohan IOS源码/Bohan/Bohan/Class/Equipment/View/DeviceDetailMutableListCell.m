//
//  DeviceDetailMutableListCell.m
//  Bohan
//
//  Created by Yang Lin on 2018/5/12.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import "DeviceDetailMutableListCell.h"
#import "DeviceModel.h"
#import "DebuggingANDPublishing.pch"
@interface DeviceDetailMutableListCell ()
{
__weak IBOutlet UILabel *name;
__weak IBOutlet UILabel *deviceId;
__weak IBOutlet UILabel *type;
__weak IBOutlet UILabel *pos;
__weak IBOutlet UIImageView *typeImg;// 第一个图片
__weak IBOutlet UIImageView *posImg;
__weak IBOutlet UIImageView *onlineImg;

//    __weak IBOutlet UIImageView *statusImg;
__weak IBOutlet UILabel *online;
//    __weak IBOutlet UILabel *status;

__weak IBOutlet UILabel *power;
__weak IBOutlet UISwitch *openSwitch1;
__weak IBOutlet UILabel *name1;
__weak IBOutlet UISwitch *openSwitch2;
__weak IBOutlet UILabel *name2;

__weak IBOutlet UISwitch *openSwitch3;
__weak IBOutlet UILabel *name3;
NSArray *switchs;

}
@end

@implementation DeviceDetailMutableListCell


- (void)awakeFromNib
{
[super awakeFromNib];
switchs = @[openSwitch1, openSwitch2, openSwitch3];

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

if(self)
{
    switchs = @[openSwitch1, openSwitch2, openSwitch3];
}

return self;
}

- (void)setModel:(DeviceModel *)model
{
_model = model;
[self setNeedsLayout];
}
- (IBAction)openAction:(UISwitch *)sender {


if (sender.isOn) {
    sender.backgroundColor = [UIColor getColor:@"54d76a"];
}else {
    sender.backgroundColor = [UIColor redColor];
}

if (self.delegate && [self.delegate respondsToSelector:@selector(didSwitchOpen:switchCode:withIndexPath:)]) {
    NSString *code = [NSString stringWithFormat:@"10000%@%@%@",openSwitch3.on?@"0":@"1", openSwitch2.on?@"0":@"1", openSwitch1.on?@"0":@"1"];
    
    [self.delegate didSwitchOpen:sender.on switchCode:[Utils getHexByBinary:code] withIndexPath:self.indexPath];
}
}

- (void)prepareForReuse {
[super prepareForReuse];
}

- (void)layoutSubviews {
[super layoutSubviews];
//    openSwitch.layer.cornerRadius = 16;

if([self.model.id hasPrefix:@"61"]) {
    openSwitch1.hidden = YES;
    openSwitch3.hidden = YES;
    openSwitch2.hidden = NO;
    
}else if ([self.model.id hasPrefix:@"62"]) {
    openSwitch1.hidden = NO;
    openSwitch3.hidden = NO;
    openSwitch2.hidden = YES;
    
}else if ([self.model.id hasPrefix:@"63"]) {
    openSwitch1.hidden = NO;
    openSwitch3.hidden = NO;
    openSwitch2.hidden = NO;
}

[name  setText:self.model.name];
[deviceId  setText:[NSString stringWithFormat:@"%@%@",Localize(@"设备号："),self.model.id]];
[type  setText:self.model.type];
[pos  setText:self.model.position];

    
//     判断设备是否在线
if (self.model.powerinfo && self.model.powerinfo.length>0) { // powerinfo 是用电
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
    
    NSString *str = [Utils getBinaryByHex:[self.model.powerinfo substringToIndex:2]];
    for (UISwitch *theSwitch in switchs) {
        theSwitch.enabled = YES;
        
        BOOL isOpen = ![[str substringWithRange:NSMakeRange(str.length - 1 - (theSwitch.tag - 600), 1)] boolValue];
        
        [theSwitch setOn:isOpen];
        if (isOpen) {
            theSwitch.backgroundColor = [UIColor getColor:@"54d76a"];
        }else {
            theSwitch.backgroundColor = [UIColor redColor];
        }
    }
    //         一二三位开关位置
    NSString * string =  self.model.id;
    NSString * stringg = string;
    if ([stringg hasPrefix:@"61"] || [stringg hasPrefix:@"63"]) {
        [power setText:[self.model.powerinfo poweer]];
    }else
    if ([stringg hasPrefix:@"62"]){
    [power setText:[self.model.powerinfo powweer]];
    }
}else {
    if ([self.model.sort containsString:@"QK01"] || [self.model.sort containsString:@"QK02"] || [self.model.sort containsString:@"QK03"] || [self.model.sort containsString:@"K"]) {
        typeImg.image = [UIImage imageNamed:@"Switch-close"];
    }
    if ([self.model.sort containsString:@"CDMT10"] || [self.model.sort containsString:@"CDMT16"] || [self.model.sort containsString:@"QC10"] || [self.model.sort containsString:@"QC13"] || [self.model.sort containsString:@"QC15"] || [self.model.sort containsString:@"QC16"] || [self.model.sort containsString:@"YC10"] || [self.model.sort containsString:@"YCGP10"] || [self.model.sort containsString:@"YC13"] || [self.model.sort containsString:@"YC15"] || [self.model.sort containsString:@"YC16"] || [self.model.sort containsString:@"YCGP16"] || [self.model.sort containsString:@"YC"] || [self.model.sort containsString:@"QC"]) {
        typeImg.image = [UIImage imageNamed:@"device_list_socket_no"];
    }
    if ([self.model.sort containsString:@"CDMT60"] || [self.model.sort containsString:@"GP1P"] || [self.model.sort containsString:@"WFMT"]) {
        typeImg.image = [UIImage imageNamed:@"Electric-meter.png"];
    }
    if ([self.model.sort containsString:@"YFMT"] || [self.model.sort containsString:@"YFGPMT"]) {
        typeImg.image = [UIImage imageNamed:@"purse_grey.png"];
    }
    if ([self.model.sort containsString:@"MC"]) {
        typeImg.image = [UIImage imageNamed:@"purse_grey.png"];
    }
    typeImg.highlighted = NO;
    posImg.highlighted = NO;
    onlineImg.highlighted = NO;
    for (UISwitch *theSwitch in switchs) {
        theSwitch.on = NO;
        theSwitch.enabled = NO;
        theSwitch.backgroundColor = [UIColor getColor:@"e4e4e4"];
    }
    [online setText:Localize(@"离线")];
    [power setText:@"0.00W"];
}

}
@end
