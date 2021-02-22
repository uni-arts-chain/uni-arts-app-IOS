//
//  JLBaseView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLBaseView.h"

@implementation JLBaseView
+ (UIView *)loadCustomView {
    NSString *className = NSStringFromClass([self class]);
    NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:className owner:nil options:nil];
    id view = [nibViews objectAtIndex:0];
    return view;
}

+ (UIView *)loadCustomView:(NSString *)nibName className:(NSString *)className {
    NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil];
    for (UIView *v in nibViews) {
        NSString *vName = NSStringFromClass([v class]);
        if ([vName isEqualToString:className]) {
            return v;
        }
    }
    return nil;
}
@end
