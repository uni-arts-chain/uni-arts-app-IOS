//
//  JLRealNameFailedView.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol JLRealNameFailedViewDelegate <NSObject>
@optional
- (void)failedViewBackAction;
@end

@interface JLRealNameFailedView : UIView
@property (nonatomic, weak) id<JLRealNameFailedViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
