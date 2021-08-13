//
//  UILabel+JLExtension.m
//  CloudArtChain
//
//  Created by jielian on 2021/8/12.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "UILabel+JLExtension.h"

#import <objc/runtime.h>

const void *kAssociatedjl_contentInsets;

/// 获取UIEdgeInsets在水平方向上的值
CG_INLINE CGFloat
UIEdgeInsetsGetHorizontalValue(UIEdgeInsets insets) {
    return insets.left + insets.right;
}

/// 获取UIEdgeInsets在垂直方向上的值
CG_INLINE CGFloat
UIEdgeInsetsGetVerticalValue(UIEdgeInsets insets) {
    return insets.top + insets.bottom;
}

CG_INLINE void
ReplaceMethod(Class _class, SEL _originSelector, SEL _newSelector) {
    Method oriMethod = class_getInstanceMethod(_class, _originSelector);
    Method newMethod = class_getInstanceMethod(_class, _newSelector);
    BOOL isAddedMethod = class_addMethod(_class, _originSelector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod));
    if (isAddedMethod) {
        class_replaceMethod(_class, _newSelector, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
    } else {
        method_exchangeImplementations(oriMethod, newMethod);
    }
}

@implementation UILabel (JLExtension)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ReplaceMethod([self class], @selector(drawTextInRect:), @selector(jl_drawTextInRect:));
        ReplaceMethod([self class], @selector(sizeThatFits:), @selector(jl_sizeThatFits:));
    });
}

- (void)jl_drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = self.jl_contentInsets;
    [self jl_drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

- (CGSize)jl_sizeThatFits:(CGSize)size {
    UIEdgeInsets insets = self.jl_contentInsets;
    size = [self jl_sizeThatFits:CGSizeMake(size.width - UIEdgeInsetsGetHorizontalValue(insets), size.height-UIEdgeInsetsGetVerticalValue(insets))];
    size.width += UIEdgeInsetsGetHorizontalValue(insets);
    size.height += UIEdgeInsetsGetVerticalValue(insets);
    return size;
}

- (void)setJl_contentInsets:(UIEdgeInsets)jl_contentInsets {
    objc_setAssociatedObject(self, &kAssociatedjl_contentInsets, [NSValue valueWithUIEdgeInsets:jl_contentInsets] , OBJC_ASSOCIATION_RETAIN);
}

- (UIEdgeInsets)jl_contentInsets {
    return [objc_getAssociatedObject(self, &kAssociatedjl_contentInsets) UIEdgeInsetsValue];
}

@end
