//
//  JLDappMoreContentView.h
//  CloudArtChain
//
//  Created by jielian on 2021/9/27.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol JLDappMoreContentViewDelegate <NSObject>

- (void)refreshDatas;

- (void)loadMoreDatas;

- (void)lookDappWithDappData: (Model_dapp_Data *)dappData;

@end

@interface JLDappMoreContentView : UIView

@property (nonatomic, weak) id<JLDappMoreContentViewDelegate> delegate;

- (void)setDataArray:(NSArray *)dataArray page: (NSInteger)page pageSize: (NSInteger)pageSize;

@end

NS_ASSUME_NONNULL_END
