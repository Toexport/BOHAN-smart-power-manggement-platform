//
//  shareView.h
//  Bohan
//
//  Created by summer on 2018/9/27.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface shareView : UIView
@property (weak, nonatomic) IBOutlet UIView *ButtomView; // 背景View
@property (weak, nonatomic) IBOutlet UIView *WeChatFriendsView; // 微信好友
@property (weak, nonatomic) IBOutlet UIView *WeChatCircleOfFriendsView; // 微信朋友圈
@property (weak, nonatomic) IBOutlet UIView *QQFriendsView; // QQ好友
@property (weak, nonatomic) IBOutlet UIView *QQSpaceView; // QQ空间

typedef void (^SelectValue)(NSInteger selectIndex);//数值
@property (nonatomic, copy) SelectValue selectValue;
/**
 *空白VIEW
 */
- (instancetype)initWithDateStyle:(NSInteger)datePickerStyle BlankBlock:(SelectValue)completeBlock;

-(void)show;

@end
