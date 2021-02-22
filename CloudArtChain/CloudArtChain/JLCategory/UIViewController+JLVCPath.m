//
//  UIViewController+JLVCPath.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "UIViewController+JLVCPath.h"
#import <objc/runtime.h>

@implementation UIViewController (JLVCPath)
+ (void)load
{
#ifdef DEBUG
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class cls = [UIViewController class];
        Method m1 = class_getInstanceMethod(cls, @selector(viewDidLoad));
        Method m2 = class_getInstanceMethod(cls, @selector(ViewDidLoad_EverPath));
        method_exchangeImplementations(m1, m2);
        
//        SEL sel = @selector(modalPresentationStyle);
//        SEL swizzSel = @selector(swiz_modalPresentationStyle);
//        Method method = class_getInstanceMethod([self class], sel);
//        Method swizzMethod = class_getInstanceMethod([self class], swizzSel);
//        BOOL isAdd = class_addMethod(self, sel, method_getImplementation(swizzMethod), method_getTypeEncoding(swizzMethod));
//        if (isAdd) {
//          class_replaceMethod(self, swizzSel, method_getImplementation(method), method_getTypeEncoding(method));
//        } else {
//          method_exchangeImplementations(method, swizzMethod);
//        }
    });
#endif
}

- (UIModalPresentationStyle)swiz_modalPresentationStyle {
    return UIModalPresentationOverFullScreen;
}


- (void)ViewDidLoad_EverPath
{
    [self ViewDidLoad_EverPath];
    printf("Ever_VC_Path:%s\n",NSStringFromClass(self.class).UTF8String);
}
@end
