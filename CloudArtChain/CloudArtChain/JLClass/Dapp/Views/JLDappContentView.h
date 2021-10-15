//
//  JLDappContentView.h
//  CloudArtChain
//
//  Created by jielian on 2021/9/26.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, JLDappContentViewLookTrackMoreType) {
    /// 收藏
    JLDappContentViewLookTrackMoreTypeCollect,
    /// 最近
    JLDappContentViewLookTrackMoreTypeRecently
};
typedef NS_ENUM(NSUInteger, JLDappContentViewTrackType) {
    JLDappContentViewTrackTypeCollect,
    JLDappContentViewTrackTypeRecently
};

@protocol JLDappContentViewDelegate <NSObject>

- (void)search;

- (void)scanCode;

- (void)refreshDataWithTrackType: (JLDappContentViewTrackType)trackType chainData: (Model_chain_Data *)chainData;

- (void)loadMoreChainCategoryDatas;

- (void)lookTrackMoreWithType: (JLDappContentViewLookTrackMoreType)type;

- (void)lookChainCategoryMoreWithData: (Model_chain_category_Data *)chainCategoryData;

- (void)refreshChainInfoDatasWithChainData: (Model_chain_Data *)chainData;

- (void)lookTrackWithType: (JLDappContentViewTrackType)type;

- (void)lookDappWithDappData: (Model_dapp_Data *)dappData;

@end

@interface JLDappContentView : UIView

@property (nonatomic, weak) id<JLDappContentViewDelegate> delegate;

@property (nonatomic, copy) NSArray *trackArray;
@property (nonatomic, copy) NSArray *chainArray;

- (void)setChainDappArray: (NSArray *)chainDappArray page: (NSInteger)page pageSize: (NSInteger)pageSize;

@end

NS_ASSUME_NONNULL_END
