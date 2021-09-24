//
//  JLBaseTextView.h
//  CloudArtChain
//
//  Created by jielian on 2021/9/23.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLBaseTextView : UITextView

@property (nonatomic, copy) NSString *jl_placeholder;

@property (nonatomic, strong) UIColor *jl_placeholderColor;

@property (nonatomic, strong) UIFont *jl_placeholderFont;

@property (nonatomic, assign) UIEdgeInsets jl_placeholderInsets;

@end

NS_ASSUME_NONNULL_END
