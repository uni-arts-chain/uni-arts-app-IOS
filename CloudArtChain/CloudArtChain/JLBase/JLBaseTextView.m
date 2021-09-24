//
//  JLBaseTextView.m
//  CloudArtChain
//
//  Created by jielian on 2021/9/23.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLBaseTextView.h"

@implementation JLBaseTextView

+ (void)load {
    method_exchangeImplementations(class_getInstanceMethod(self.class,NSSelectorFromString(@"dealloc") ),
                                class_getInstanceMethod(self.class, NSSelectorFromString(@"jl_swizzledDealloc")));
}

+ (void)jl_swizzledDealloc {
    //移除监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self jl_swizzledDealloc];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textchange) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}

- (void)textchange {
    //重新绘制
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    if(!self.hasText){
        //文字的属性
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        //设置字体大小
        dict[NSFontAttributeName] = self.jl_placeholderFont ? self.jl_placeholderFont : self.font;
        //设置字体颜色
        dict[NSForegroundColorAttributeName] = self.jl_placeholderColor ? self.jl_placeholderColor : [UIColor colorWithHexString:@"cdcdcd"];
        //画文字(rect是textView的bounds）
        CGFloat top = self.jl_placeholderInsets.top ? self.jl_placeholderInsets.top : 8;
        CGFloat left = self.jl_placeholderInsets.left ? self.jl_placeholderInsets.left : 5;
        CGFloat bottom = self.jl_placeholderInsets.bottom ? self.jl_placeholderInsets.bottom : 8;
        CGFloat right = self.jl_placeholderInsets.right ? self.jl_placeholderInsets.right : 5;
        CGRect textRect = CGRectMake(left, top, rect.size.width - left - right, rect.size.height - top - bottom);
        [self.jl_placeholder drawInRect:textRect withAttributes:dict];
    }
}

- (void)setJl_placeholder:(NSString *)jl_placeholder {
    _jl_placeholder = jl_placeholder;
    
    [self setNeedsDisplay];
}

- (void)setJl_placeholderColor:(UIColor *)jl_placeholderColor {
    _jl_placeholderColor = jl_placeholderColor;
    
    [self setNeedsDisplay];
}

- (void)setJl_placeholderFont:(UIFont *)jl_placeholderFont {
    _jl_placeholderFont = jl_placeholderFont;
    
    [self setNeedsDisplay];
}

- (void)setJl_placeholderInsets:(UIEdgeInsets)jl_placeholderInsets {
    _jl_placeholderInsets = jl_placeholderInsets;
    
    [self setNeedsDisplay];
}

@end
