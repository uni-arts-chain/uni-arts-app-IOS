//
//  JLDappSearchResultView.h
//  CloudArtChain
//
//  Created by jielian on 2021/9/28.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol JLDappSearchResultViewdelegate <NSObject>

- (void)didSelect: (Model_dapp_Data *)dappData;

@end

@interface JLDappSearchResultView : UIView

@property (nonatomic, weak) id<JLDappSearchResultViewdelegate> delegate;

@property (nonatomic, copy) NSArray *searchResultArray;

/// 是否正在搜索中(显示等待指示器)
@property (nonatomic, assign) BOOL isSearching;

@end

NS_ASSUME_NONNULL_END
