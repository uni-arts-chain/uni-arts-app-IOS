//
//  JLUploadWorkSwitchView.h
//  CloudArtChain
//
//  Created by 朱彬 on 2021/4/20.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JLUploadWorkSwitchView : JLBaseView
@property (nonatomic, assign) BOOL isHiddenBottomLine;
- (instancetype)initWithTitle:(NSString *)title selectBlock:(void(^)(BOOL))selectBlock;
@end

NS_ASSUME_NONNULL_END
