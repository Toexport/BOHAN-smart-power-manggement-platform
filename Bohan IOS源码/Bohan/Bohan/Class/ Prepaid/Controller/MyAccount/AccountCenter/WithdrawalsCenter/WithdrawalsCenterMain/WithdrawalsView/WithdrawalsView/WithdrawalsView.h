//
//  WithdrawalsView.h
//  Bohan
//
//  Created by summer on 2018/9/20.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WithdrawalsView : UIView
@property (weak, nonatomic) IBOutlet UIView *buttomView;
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;
@property (weak, nonatomic) IBOutlet UITableView *Ttableview;

@property (nonatomic, strong) NSArray *titles;//string数组
@property (nonatomic, strong) NSArray * images;
typedef void (^SelectValue)(NSInteger selectIndex);//数值
//typedef void (^ClickBlock)(NSString *ClickBut);//点击事件
@property (nonatomic, copy) SelectValue selectValue;
//@property (nonatomic, copy) ClickBlock ClickBut;

/**
  *空白VIEW
 */
-(instancetype)initWithDateStyle:(NSInteger)datePickerStyle BlankBlock:(SelectValue)completeBlock;

-(void)show;

@end

