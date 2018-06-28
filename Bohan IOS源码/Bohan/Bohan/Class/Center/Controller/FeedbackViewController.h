//
//  FeedbackViewController.h
//  Bohan
//
//  Created by Yang Lin on 2018/2/5.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import "BaseViewController.h"
//#import "EdgetTextField.h"
@interface FeedbackViewController : BaseViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *typeLab;

@property (weak, nonatomic) IBOutlet UILabel *placeHolder;
@property (weak, nonatomic) IBOutlet UITextView *emotiontext;
//@property (weak, nonatomic) IBOutlet EdgetTextField *contactTF;
- (IBAction)submitAction;
- (IBAction)selectAction;

@end
