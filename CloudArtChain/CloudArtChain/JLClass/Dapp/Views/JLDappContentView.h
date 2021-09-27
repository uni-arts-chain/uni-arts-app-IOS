//
//  JLDappContentView.h
//  CloudArtChain
//
//  Created by jielian on 2021/9/26.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, JLDappContentViewLookMoreType) {
    /// 收藏
    JLDappContentViewLookMoreTypeCollect,
    /// 最近
    JLDappContentViewLookMoreTypeRecently,
    /// 推荐
    JLDappContentViewLookMoreTypeRecommend,
    /// 交易
    JLDappContentViewLookMoreTypeTransaction
};

@protocol JLDappContentViewDelegate <NSObject>

- (void)search;

- (void)scanCode;

- (void)refreshData;

- (void)lookMoreWithType: (JLDappContentViewLookMoreType)type;

- (void)refreshChainInfoDatasWithSymbol: (JLMultiChainSymbol)symbol;

- (void)lookCollect;

- (void)lookRecently;

- (void)lookDappWithUrl: (NSString *)url;

@end

@interface JLDappContentView : UIView

@property (nonatomic, weak) id<JLDappContentViewDelegate> delegate;

@property (nonatomic, copy) NSArray *chainSymbolArray;

@property (nonatomic, copy) NSArray *trackArray;
@property (nonatomic, copy) NSArray *recommendArray;
@property (nonatomic, copy) NSArray *transactionArray;

@end

NS_ASSUME_NONNULL_END
