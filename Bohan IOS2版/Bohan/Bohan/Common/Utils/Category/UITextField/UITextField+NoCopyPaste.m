//
//  UITextField+NoCopyPaste.m
//  UFA
//
//  Created by YangLin on 2018/1/3.
//  Copyright © 2018年 UFA. All rights reserved.
//

#import "UITextField+NoCopyPaste.h"
#import <objc/runtime.h>
static const void *noCopyPasteKey = &noCopyPasteKey;


@implementation UITextField (NoCopyPaste)


- (BOOL)noCopyPaste
{
    return [objc_getAssociatedObject(self, noCopyPasteKey) boolValue];
}

- (void)setNoCopyPaste:(BOOL)noCopyPaste
{
    objc_setAssociatedObject(self, noCopyPasteKey, [NSNumber numberWithBool:noCopyPaste], OBJC_ASSOCIATION_ASSIGN);
}
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return !self.noCopyPaste;
}
@end
