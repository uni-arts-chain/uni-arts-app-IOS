//
//  JLBaseTextField.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLBaseTextField.h"

@implementation JLBaseTextField
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (_textFieldType == TextFieldType_withdrawAmout) {
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        if (menuController) {
            [UIMenuController sharedMenuController].menuVisible = NO;
        }
        return NO;
    } else {
        return [super canPerformAction:action withSender:sender];
    }
}
@end
