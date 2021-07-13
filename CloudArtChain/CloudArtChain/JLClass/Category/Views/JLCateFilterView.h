//
//  JLCateFilterView.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/25.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JLCateFilterView : JLBaseView
@property (nonatomic, assign) NSInteger defaultIndex;
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title items:(NSArray *)items isNoDeSelect: (BOOL)isNoDeSelect defaultSelectIndex: (NSInteger)defaultSelectIndex isShowAllItem:(BOOL)isShowAllItem selectBlock:(void(^)(NSInteger index))selectBlock;
- (void)refreshItems:(NSArray *)items;
@end

NS_ASSUME_NONNULL_END
