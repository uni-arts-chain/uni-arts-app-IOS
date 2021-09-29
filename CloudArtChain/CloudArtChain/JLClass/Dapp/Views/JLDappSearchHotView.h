//
//  JLDappSearchHotView.h
//  CloudArtChain
//
//  Created by jielian on 2021/9/28.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark -- JLDappSearchHotView
@protocol JLDappSearchHotViewdelegate <NSObject>

- (void)lookDappWithUrl: (NSString *)url;

@end

@interface JLDappSearchHotView : UIView

@property (nonatomic, weak) id<JLDappSearchHotViewdelegate> delegate;

@property (nonatomic, copy) NSArray *hotSearchArray;

@end

#pragma mark -- JLDappSearchHotCell
@interface JLDappSearchHotCell : UICollectionViewCell

@property (nonatomic, strong) Model_dapp_Data *dappData;

@end

NS_ASSUME_NONNULL_END
