//
//  JLBaseTableView.m
//  CloudArtChain
//
//  Created by jielian on 2021/9/23.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLBaseTableView.h"

@implementation JLBaseTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    return [super initWithFrame:frame style:style];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    
    if (![NSStringFromClass(view.class) isEqualToString:@"UITextView"] &&
        ![NSStringFromClass(view.class) isEqualToString:@"UITextField"] &&
        ![NSStringFromClass(view.class) isEqualToString:@"JLBaseTextView"] &&
        ![NSStringFromClass(view.class) isEqualToString:@"JLBaseTextField"]) {
        if (([NSStringFromClass(view.superview.class) isEqualToString:@"UITextView"] ||
            [NSStringFromClass(view.superview.class) isEqualToString:@"UITextField"] ||
            [NSStringFromClass(view.superview.class) isEqualToString:@"JLBaseTextView"] ||
            [NSStringFromClass(view.superview.class) isEqualToString:@"JLBaseTextField"]) &&
            view.isUserInteractionEnabled == YES) {
            return view;
        }
        [super endEditing:YES];
        
        if (self.endEditBlock) {
            self.endEditBlock();
        }
        
        if (event != nil) {
            return view;
        }
        
        return self;
    }else {
        return view;
    }
}

@end
