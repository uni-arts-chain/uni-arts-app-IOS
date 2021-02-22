//
//  JLBaseView.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JLBaseView : UIView
@property (nonatomic, assign) id delegate;

+ (UIView *)loadCustomView;
+ (UIView *)loadCustomView:(NSString *)nibName className:(NSString *)className;
@end
