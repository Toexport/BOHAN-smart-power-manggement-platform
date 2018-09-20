//
//  WithdrawalsView.h
//  Bohan
//
//  Created by summer on 2018/9/20.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "NSDate+Extension.h"

@interface WithdrawalsView : UIView
/**
 空白VIEW
 */
-(instancetype)initWithDateStyle:(WSDateStyle)datePickerStyle BlankBlock:(void(^)(NSDate *))completeBlock;

-(void)show;

@end

