//
//  DetailsTableViewCell.m
//  Bohan
//
//  Created by summer on 2018/9/17.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import "DetailsTableViewCell.h"

@implementation DetailsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

// 导航
- (IBAction)NavigationBut:(UIButton *)sender {
    self.NavigationButBlock(self.NavigationBut);
}

// 纠错
- (IBAction)CorrectionBut:(UIButton *)sender {
    self.CorrectionButBlock(self.ContactBut);
}

// 分享
- (IBAction)ShareBut:(UIButton *)sender {
    self.ShareButBlock(self.ShareBut);
}

// 联系
- (IBAction)ContactBut:(UIButton *)sender {
    
}


@end
