//
//  CustomInputView.h
//  Bohan
//
//  Created by Yang Lin on 2017/12/31.
//  Copyright © 2017年 Bohan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomInputView : UIView

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UITextField *contentTF;
@property (nonatomic, copy) NSArray *datas;
@end
