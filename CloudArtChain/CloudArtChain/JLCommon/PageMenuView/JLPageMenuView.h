//
//  JLPageMenuView.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/2.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JLPageMenuView : JLBaseView
- (instancetype)initWithMenus:(NSArray *)menus itemMargin:(CGFloat)itemMargin;
@property (nonatomic, copy) void(^indexChangedBlock)(NSInteger index);
@end

NS_ASSUME_NONNULL_END
