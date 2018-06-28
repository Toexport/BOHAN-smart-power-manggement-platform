//
//  ShareView.m
//  Bohan
//
//  Created by Yang Lin on 2018/1/25.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import "ShareView.h"
#import "YLSheetView.h"
@implementation ShareView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (IBAction)cancelAction {
    
    [[YLSheetView sharedInstace] closeView];
}

- (IBAction)okAction {
    
    if (tel.text.length == 0) {
        [HintView showHint:@"请输入手机号码"];
    }else if (pwd.text.length == 0)
    {
        [HintView showHint:@"请输入手机号码"];
    }else if (![Utils isMobileNumber:tel.text])
    {
        [HintView showHint:@"手机号码格式错误"];
    }else
    {
        if (self.submitBlock) {
            self.submitBlock(tel.text, pwd.text);
        }
    }
    
}
@end
