//
//  CustomInputView.m
//  Bohan
//
//  Created by Yang Lin on 2017/12/31.
//  Copyright © 2017年 Bohan. All rights reserved.
//

#import "CustomInputView.h"
#import "SGActionView.h"
#import "DebuggingANDPublishing.pch"
@interface CustomInputView ()
{
    IBOutlet UIView *view;
}

@end

@implementation CustomInputView


- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUp];
}

- (void)setUp {
    //此处是为了解决在storyboard中加载此xib文件
    [[NSBundle mainBundle] loadNibNamed:@"CustomInputView" owner:self options:nil];
    self.frame = view.frame;
    [self addSubview:view];
}


- (IBAction)selectAction:(UIButton *)sender {
//     点击按钮弹出视图
    [SGActionView showSheetWithTitle:nil itemTitles:self.datas itemSubTitles:nil selectedIndex:[self.datas indexOfObject:self.contentTF.text] selectedHandle:^(NSInteger index) {
        self.contentTF.text = self.datas[index];
        
    }];
}

@end
