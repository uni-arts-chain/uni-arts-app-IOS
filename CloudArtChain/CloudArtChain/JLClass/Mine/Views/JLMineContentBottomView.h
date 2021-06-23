//
//  JLMineContentBottomView.h
//  CloudArtChain
//
//  Created by jielian on 2021/6/21.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^JLMineContentBottomViewSelectItemBlock)(NSInteger index);

@interface JLMineContentBottomView : UIView

@property (nonatomic, copy) JLMineContentBottomViewSelectItemBlock selectItemBlock;

@end

NS_ASSUME_NONNULL_END
