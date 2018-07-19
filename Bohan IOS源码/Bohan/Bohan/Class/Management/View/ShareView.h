//
//  ShareView.h
//  Bohan
//
//  Created by Yang Lin on 2018/1/25.
//  Copyright © 2018年 Bohan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SubmitBlock)(NSString *tel, NSString *pwd);
@interface ShareView : UIView {
    
    __weak IBOutlet UITextField *tel;
    __weak IBOutlet UITextField *pwd;
    __weak IBOutlet UIView *KSKView;
    
    __weak IBOutlet UIButton *QueryBut;
    __weak IBOutlet UIButton *ChargingBut;
    __weak IBOutlet UIButton *LoadThresholdBut;
    __weak IBOutlet UIButton *AllBut;
}

@property (nonatomic, copy)SubmitBlock submitBlock;
- (IBAction)cancelAction;

- (IBAction)okAction;

@end
