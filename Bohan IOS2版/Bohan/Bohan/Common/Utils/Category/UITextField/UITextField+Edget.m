//
//  UITextField+Edget.m
//  UFA
//
//  Created by YangLin on 2018/1/3.
//  Copyright © 2018年 UFA. All rights reserved.
//

#import "UITextField+Edget.h"
#import <objc/runtime.h>
static const void *leftViewSpacingKey = &leftViewSpacingKey;
static const void *rightViewSpacingKey = &rightViewSpacingKey;
static const void *placeHolderSpacingKey = &placeHolderSpacingKey;
static const void *textSpacingKey = &textSpacingKey;
static const void *editSpacingKey = &editSpacingKey;

@implementation UITextField (Edget)


+ (void)load {
    // 获取替换后的类方法
    Method newMethod1 = class_getClassMethod([self class], @selector(edgetLeftViewRectForBounds:));
    Method newMethod2 = class_getClassMethod([self class], @selector(edgetRightViewRectForBounds:));
    Method newMethod3 = class_getClassMethod([self class], @selector(edgetPlaceholderRectForBounds:));
    Method newMethod4 = class_getClassMethod([self class], @selector(edgetTextRectForBounds:));
    Method newMethod5 = class_getClassMethod([self class], @selector(edgetEditingRectForBounds:));

    // 获取替换前的类方法
    Method method1 = class_getClassMethod([self class], @selector(leftViewRectForBounds:));
    Method method2 = class_getClassMethod([self class], @selector(rightViewRectForBounds:));
    Method method3 = class_getClassMethod([self class], @selector(placeholderRectForBounds:));
    Method method4 = class_getClassMethod([self class], @selector(textRectForBounds:));
    Method method5 = class_getClassMethod([self class], @selector(editingRectForBounds:));

    // 然后交换类方法，交换两个方法的IMP指针，(IMP代表了方法的具体的实现）
    method_exchangeImplementations(newMethod1, method1);
    method_exchangeImplementations(newMethod2, method2);
    method_exchangeImplementations(newMethod3, method3);
    method_exchangeImplementations(newMethod4, method4);
    method_exchangeImplementations(newMethod5, method5);
    
    Method imp = class_getInstanceMethod([self class], @selector(initWithCoder:));

    Method myImp = class_getInstanceMethod([self class], @selector(changedInitWithCoder:));

    method_exchangeImplementations(imp, myImp);


}



- (CGFloat)leftViewSpacing
{
    return [objc_getAssociatedObject(self, leftViewSpacingKey) floatValue];
}

- (void)setLeftViewSpacing:(CGFloat)leftViewSpacing
{
    objc_setAssociatedObject(self, leftViewSpacingKey, [NSNumber numberWithFloat:leftViewSpacing], OBJC_ASSOCIATION_ASSIGN);
}


- (CGFloat)rightViewSpacing
{
    return [objc_getAssociatedObject(self, rightViewSpacingKey) floatValue];
}

- (void)setRightViewSpacing:(CGFloat)rightViewSpacing
{
    objc_setAssociatedObject(self, rightViewSpacingKey, [NSNumber numberWithFloat:rightViewSpacing], OBJC_ASSOCIATION_ASSIGN);
}


- (CGFloat)placeHolderSpacing
{
    return [objc_getAssociatedObject(self, placeHolderSpacingKey) floatValue];
}

- (void)setPlaceHolderSpacing:(CGFloat)placeHolderSpacing
{
    objc_setAssociatedObject(self, placeHolderSpacingKey, [NSNumber numberWithFloat:placeHolderSpacing], OBJC_ASSOCIATION_ASSIGN);
}



- (CGFloat)textSpacing
{
    return [objc_getAssociatedObject(self, textSpacingKey) floatValue];
}

- (void)setTextSpacing:(CGFloat)textSpacing
{
    objc_setAssociatedObject(self, textSpacingKey, [NSNumber numberWithFloat:textSpacing], OBJC_ASSOCIATION_ASSIGN);
}



- (CGFloat)editSpacing
{
    return [objc_getAssociatedObject(self, editSpacingKey) floatValue];
}

- (void)setEditSpacing:(CGFloat)editSpacing
{
    objc_setAssociatedObject(self, editSpacingKey, [NSNumber numberWithFloat:editSpacing], OBJC_ASSOCIATION_ASSIGN);
}



- (instancetype)changedInitWithCoder:(NSCoder*)aDecode{

    [self changedInitWithCoder:aDecode];

    if (self) {

//        if(self.tag != ExcaptionTag){
//
////            self.font = [self.font fontWithSize:MFontSize(self.font.pointSize)];
//            [self leftViewRectForBounds:];
//        }
        [self leftViewRectForBounds:self.bounds];
        [self rightViewRectForBounds:self.bounds];
        [self placeholderRectForBounds:self.bounds];
        [self textRectForBounds:self.bounds];
        [self editingRectForBounds:self.bounds];

    }

    return self;

}



- (CGRect)edgetLeftViewRectForBounds:(CGRect)bounds
{
    CGRect iconRect = [self leftViewRectForBounds:bounds];
    iconRect.origin.x += self.leftViewSpacing;
    return iconRect;
}

- (CGRect)edgetRightViewRectForBounds:(CGRect)bounds
{
    CGRect iconRect = [self rightViewRectForBounds:bounds];
    iconRect.origin.x += self.rightViewSpacing;
    return iconRect;
}

- (CGRect)edgetPlaceholderRectForBounds:(CGRect)bounds
{
    CGRect iconRect = [self placeholderRectForBounds:bounds];
    iconRect.origin.x += self.placeHolderSpacing;
    return iconRect;

}

- (CGRect)edgetTextRectForBounds:(CGRect)bounds
{
    CGRect iconRect = [self textRectForBounds:bounds];
    iconRect.origin.x += self.textSpacing;
    return iconRect;
}


- (CGRect)edgetEditingRectForBounds:(CGRect)bounds
{
    CGRect iconRect = [self editingRectForBounds:bounds];
    iconRect.origin.x += self.editSpacing;
    return iconRect;

}

@end
