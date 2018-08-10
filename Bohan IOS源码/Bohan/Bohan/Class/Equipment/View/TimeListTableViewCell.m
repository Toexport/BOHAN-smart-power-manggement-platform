//
//  TimeListTableViewCell.m
//  Bohan
//
//  Created by Yang Lin on 2018/1/17.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import "TimeListTableViewCell.h"
#import "TimeSettingModel.h"
#import "DebuggingANDPublishing.pch"
@interface TimeListTableViewCell () {
    __weak IBOutlet UILabel *startTime;
    __weak IBOutlet UILabel *endTime;
    __weak IBOutlet UILabel *status;
    __weak IBOutlet UILabel *week;
    __weak IBOutlet UISwitch *openSwitch;
    
}
@end

@implementation TimeListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setModel:(TimeSettingModel *)model {
    if (_model != model) {
        _model = model;
        
        [self setNeedsLayout];
        
    }
}
- (IBAction)openOrClose:(UISwitch *)sender {
    _model.open = sender.on;
    
    [startTime setText:_model.startTime];
    [endTime setText:_model.endTime];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [startTime setText:_model.startTime];
    [endTime setText:_model.endTime];
    [week setText:[_model.week loopWeekByHex]];
    
    NSString *start = [_model.startTime stringByReplacingOccurrencesOfString:@":" withString:@""];
    NSString *end = [_model.endTime stringByReplacingOccurrencesOfString:@":" withString:@""];
    NSString *week = [Utils getBinaryByHex:_model.week];

    if (!([end integerValue] > [start integerValue]) || [[week substringFromIndex:1] isEqualToString:@"0000000"]) {
        [status setText:Localize(@"未开启")];
    }else {
        [status setText:Localize(@"已开启")];
    }
//    [status setText:_model.open?Localize(@"已开启"):Localize(@"未开启")];
    [openSwitch setOn:_model.open];

}



@end
