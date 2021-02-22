//
//  JLMineSuccessView.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol JLMineSuccessViewDelegate <NSObject>
@optional
- (void)successViewBackAction;
@end

@interface JLMineSuccessView : UIView
@property (nonatomic, weak) id<JLMineSuccessViewDelegate> delegate;
@property (nonatomic, copy) NSString *succedText;
@end

NS_ASSUME_NONNULL_END
