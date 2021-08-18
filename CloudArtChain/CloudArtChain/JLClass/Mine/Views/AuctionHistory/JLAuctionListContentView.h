//
//  JLAuctionListContentView.h
//  CloudArtChain
//
//  Created by jielian on 2021/8/16.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol JLAuctionListContentViewDelegate <NSObject>

- (void)refreshData;

- (void)loadMoreData;

- (void)payAuction:(NSString *)auctionsId;

- (void)lookAuctionDetail:(NSString *)auctionsId;

@end

@interface JLAuctionListContentView : UIView

@property (nonatomic, weak) id<JLAuctionListContentViewDelegate> delegate;

@property (nonatomic, assign) JLAuctionHistoryType type;

@property (nonatomic, assign) NSInteger page;

- (void)setDataArray:(NSArray *)dataArray page: (NSInteger)page pageSize: (NSInteger)pageSize;

@end

NS_ASSUME_NONNULL_END
