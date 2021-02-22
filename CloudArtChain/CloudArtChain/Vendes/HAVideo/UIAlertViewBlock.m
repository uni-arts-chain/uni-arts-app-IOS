//
//  UIAlertViewBlock.m
//  CS090Agent
//
//  Created by cs090_jzb on 15/9/14.
//  Copyright (c) 2015年 cs090. All rights reserved.
//

#import "UIAlertViewBlock.h"

@implementation UIAlertViewBlock
- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    if (self = [super initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles,nil]) {
        
    }
    return self;
}

-(void)addDoneBlock:(AlertBlock)doneBlock
{
    self.doneBlock = doneBlock;
}

-(void)addCancelBlock:(AlertBlock)cancelBlock
{
    self.cancelBlock = cancelBlock;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView numberOfButtons] > 1) {
        if (buttonIndex == [alertView cancelButtonIndex]) {
            if (self.cancelBlock) {
                self.cancelBlock(self);
            }
        }
        else{
            if (self.doneBlock) {
                self.doneBlock(self);
            }
        }
    }
    else{
        if (self.doneBlock) {
            self.doneBlock(self);
        }
    }

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
