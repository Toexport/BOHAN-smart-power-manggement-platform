//
//  SGActionMenu.h
//  SGActionView
//
//  Created by Sagi on 13-9-3.
//  Copyright (c) 2013年 AzureLab. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "SGTimePick.h"

/**
 *  弹出框样式
 */
typedef NS_ENUM(NSInteger, SGActionViewStyle){
    SGActionViewStyleLight = 0,     // 浅色背景，深色字体
    SGActionViewStyleDark           // 深色背景，浅色字体
};
typedef NS_ENUM(NSInteger, TableStyle){
    NormalStyle = 0,     // 特殊列表
    SpecialStyle           // 普通列表
};
typedef NS_ENUM(NSInteger, ActionSheetType) {
    ActionSheetDate_Picker = 0,
    ActionSheetTimeDate_Picker,
    ActionSheetTime_Picker,
    ActionSheetCity_Picker,
    ActionSheetOther_Picker,
    ActionSheetOtherTowRow_Picker

};
typedef void(^SGMenuActionHandler)(NSInteger index);
typedef void(^SGDateTimePick)(NSDate* selectTime,NSString *selectedItem);

@interface SGActionView : UIView

/**
 *  弹出框样式
 */
@property (nonatomic, assign) SGActionViewStyle style;
@property (nonatomic, strong) NSArray *dataSource;


-(NSArray*)dataSource;
/**
 *  获取单例
 */
+ (SGActionView *)sharedActionView;


/**
 *	选择列表弹出层（指定选中行）
 *
 *	@param 	title           标题
 *	@param 	itemTitles      行标题
 *	@param 	itemSubTitles 	行子标题
 *	@param 	selectedIndex 	选中行index
 *	@param 	handler         回调，index从 0 开始
 */
+ (void)showSheetWithTitle:(NSString *)title
                itemTitles:(NSArray *)itemTitles
             itemSubTitles:(NSArray *)itemSubTitles
             selectedIndex:(NSInteger)selectedIndex
            selectedHandle:(SGMenuActionHandler)handler;

+ (void)showTimeWithTitle:(NSString *)title
                     type:(ActionSheetType)currentType
                 starTime:(NSDate*)starTimeDate withIndex:(NSString*)indexStr
           selectedHandle:(SGDateTimePick)handler;

@end
