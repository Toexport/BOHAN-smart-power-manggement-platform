//
//  UIFont+Adaptation.m
//  UFA
//
//  Created by YangLin on 2017/12/15.
//  Copyright © 2017年 UFA. All rights reserved.
//

#import "UIFont+Adaptation.h"
#import <objc/runtime.h>
#import "DebuggingANDPublishing.pch"
@implementation UIFont (Adaptation)


+ (void)load {
    // 获取替换后的类方法
    Method newMethod = class_getClassMethod([self class], @selector(adjustFont:));
    // 获取替换前的类方法
    Method method = class_getClassMethod([self class], @selector(systemFontOfSize:));

    // 获取替换后的类方法
    Method newBlodMethod = class_getClassMethod([self class], @selector(adjustBlodFont:));
    // 获取替换前的类方法
    Method boldMethod = class_getClassMethod([self class], @selector(boldSystemFontOfSize:));


    // 然后交换类方法，交换两个方法的IMP指针，(IMP代表了方法的具体的实现）
    method_exchangeImplementations(newMethod, method);
    method_exchangeImplementations(newBlodMethod, boldMethod);

}

+ (UIFont *)adjustFont:(CGFloat)fontSize {
    UIFont *newFont = nil;
    newFont = [UIFont adjustFont:MFontSize(fontSize)];
    return newFont;
}

+ (UIFont *)adjustBlodFont:(CGFloat)fontSize {
    UIFont *newFont = nil;
    newFont = [UIFont adjustBlodFont:MFontSize(fontSize)];
    return newFont;
}

@end


@implementation UILabel (UIFont)



+ (void)load{
    
    Method imp = class_getInstanceMethod([self class], @selector(initWithCoder:));
    
    Method myImp = class_getInstanceMethod([self class], @selector(changedInitWithCoder:));
    
    method_exchangeImplementations(imp, myImp);
    
}



- (instancetype)changedInitWithCoder:(NSCoder*)aDecode{
    
    [self changedInitWithCoder:aDecode];
    
    if (self) {
        
        if(self.tag != ExcaptionTag){
            
            self.font = [self.font fontWithSize:MFontSize(self.font.pointSize)];
        }
        
    }
    
    return self;
    
}



@end




@implementation UIButton (UIFont)



+ (void)load{
    
    Method imp = class_getInstanceMethod([self class], @selector(initWithCoder:));
    
    Method myImp = class_getInstanceMethod([self class], @selector(changedInitWithCoder:));
    
    method_exchangeImplementations(imp, myImp);
    
}



- (instancetype)changedInitWithCoder:(NSCoder*)aDecode{
    
    [self changedInitWithCoder:aDecode];
    
    if (self) {
        
        if(self.tag != ExcaptionTag){

            self.titleLabel.font = [self.titleLabel.font fontWithSize:MFontSize(self.titleLabel.font.pointSize)];
        }
        
    }
    
    return self;
    
}

@end



@implementation UITextField (UIFont)



+ (void)load{
    
    Method imp = class_getInstanceMethod([self class], @selector(initWithCoder:));
    
    Method myImp = class_getInstanceMethod([self class], @selector(changedInitWithCoder:));
    
    method_exchangeImplementations(imp, myImp);
    
}



- (instancetype)changedInitWithCoder:(NSCoder*)aDecode{
    
    [self changedInitWithCoder:aDecode];
    
    if (self) {
        
        if(self.tag != ExcaptionTag){

            self.font = [self.font fontWithSize:MFontSize(self.font.pointSize)];
            
        }
        
    }
    
    return self;
    
}



@end



@implementation UITextView (UIFont)



+ (void)load{
    
    Method imp = class_getInstanceMethod([self class], @selector(initWithCoder:));
    
    Method myImp = class_getInstanceMethod([self class], @selector(changedInitWithCoder:));
    
    method_exchangeImplementations(imp, myImp);
    
}



- (instancetype)changedInitWithCoder:(NSCoder*)aDecode{
    
    [self changedInitWithCoder:aDecode];
    
    if (self) {
        
        if(self.tag != ExcaptionTag){

            self.font = [self.font fontWithSize:MFontSize(self.font.pointSize)];
        }
        
    }
    
    return self;
    
}



@end

