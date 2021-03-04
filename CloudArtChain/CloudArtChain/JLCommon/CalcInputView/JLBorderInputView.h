//
//  JLBorderInputView.h
//  CloudArtChain
//
//  Created by 朱彬 on 2021/3/3.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLBorderInputView : UIView
@property (nonatomic, strong) NSString *inputContent;
- (instancetype)initWithPlaceholder:(NSString *)placeholder content:(NSString *)content;
@end

NS_ASSUME_NONNULL_END
