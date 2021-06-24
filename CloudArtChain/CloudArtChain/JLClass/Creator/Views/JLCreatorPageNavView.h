//
//  JLCreatorPageNavView.h
//  CloudArtChain
//
//  Created by jielian on 2021/6/24.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^JLCreatorPageNavViewBackBlock)(void);

@interface JLCreatorPageNavView : UIView

@property (nonatomic, strong, readonly) UIView *bgView;

@property (nonatomic, strong, readonly) UIButton *backBtn;

@property (nonatomic, strong, readonly) UILabel *titleLabel;

@property (nonatomic, copy) JLCreatorPageNavViewBackBlock backBlock;

@end

NS_ASSUME_NONNULL_END
