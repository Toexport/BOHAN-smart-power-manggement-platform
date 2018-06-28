//
//  CustomInputView.m
//  Bohan
//
//  Created by Yang Lin on 2017/12/31.
//  Copyright © 2017年 Bohan. All rights reserved.
//

#import "CustomInputView.h"
#import "SGActionView.h"
@interface CustomInputView ()
{
    IBOutlet UIView *view;
}

@end

@implementation CustomInputView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    
    [self setUp];
}

- (void)setUp
{
    //此处是为了解决在storyboard中加载此xib文件
    [[NSBundle mainBundle] loadNibNamed:@"CustomInputView" owner:self options:nil];
    self.frame = view.frame;
    [self addSubview:view];
}


- (IBAction)selectAction:(UIButton *)sender {
    
    
    [SGActionView showSheetWithTitle:nil itemTitles:self.datas itemSubTitles:nil selectedIndex:[self.datas indexOfObject:self.contentTF.text] selectedHandle:^(NSInteger index) {
        
        self.contentTF.text = self.datas[index];
        
    }];
}

@end
