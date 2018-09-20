//
//  AccountCenterCell.m
//  Bohan
//
//  Created by summer on 2018/9/13.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import "AccountCenterCell.h"

@implementation AccountCenterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer * TapGestureRecognizer1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(StoredValuealickList)];
    self.StoredValueView.userInteractionEnabled=YES;
    [self.StoredValueView addGestureRecognizer:TapGestureRecognizer1];
    
    UITapGestureRecognizer * TapGestureRecognizer2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(alickList)];
    self.ExtractView.userInteractionEnabled=YES;
    [self.ExtractView addGestureRecognizer:TapGestureRecognizer2];
    
}
- (void)StoredValuealickList {
    self.StoredValueBlockBlock(self.StoredValueView);
}

- (void)alickList{
    self.ExtractBlockBlock(self.ExtractView);
}

@end
