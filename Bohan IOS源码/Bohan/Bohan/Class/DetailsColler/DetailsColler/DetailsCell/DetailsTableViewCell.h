//
//  DetailsTableViewCell.h
//  Bohan
//
//  Created by summer on 2018/9/17.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *NavigationBut;  // 导航
typedef void (^NavigationButBlock)(id NavigationBut);
@property (nonatomic , copy) NavigationButBlock NavigationButBlock;

@property (weak, nonatomic) IBOutlet UIButton *CorrectionBut; // 纠错
typedef void (^CorrectionButBlock)(id CorrectionBut);
@property (nonatomic , copy) CorrectionButBlock CorrectionButBlock;

@property (weak, nonatomic) IBOutlet UIButton *ShareBut; // 分享
typedef void (^ShareButBlock)(id ShareBut);
@property (nonatomic , copy) ShareButBlock ShareButBlock;

@property (weak, nonatomic) IBOutlet UIButton *ContactBut; // 联系
@property (weak, nonatomic) IBOutlet UILabel *TitleLabelS;  // 名字
@property (weak, nonatomic) IBOutlet UILabel *DistanceLabelS; // 距离
@property (weak, nonatomic) IBOutlet UILabel *SiteLocationLabelS; // 地点
@property (weak, nonatomic) IBOutlet UILabel *IdLabelS; // 编号
@property (weak, nonatomic) IBOutlet UILabel *YMDLabelS; // 年月日
@property (weak, nonatomic) IBOutlet UILabel *TimeLabelS; // 时间

@end
