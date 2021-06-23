//
//  JLMineContentMiddleView.h
//  CloudArtChain
//
//  Created by jielian on 2021/6/21.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^JLMineContentMiddleViewSelectItemBlock)(NSInteger index);

@interface JLMineContentMiddleView : UIView

@property (nonatomic, copy) JLMineContentMiddleViewSelectItemBlock selectItemBlock;

@end

NS_ASSUME_NONNULL_END
