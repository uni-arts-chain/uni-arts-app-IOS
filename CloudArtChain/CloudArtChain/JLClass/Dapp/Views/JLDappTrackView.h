//
//  JLDappTrackView.h
//  CloudArtChain
//
//  Created by jielian on 2021/9/26.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^JLDappTrackViewDidSelectTitleBlock)(NSInteger index);
typedef void(^JLDappTrackViewMoreBlock)(NSInteger index);
typedef void(^JLDappTrackViewLookDappBlock)(NSString *dappUrl);

@interface JLDappTrackView : UIView

@property (nonatomic, copy) JLDappTrackViewDidSelectTitleBlock didSelectTitleBlock;
@property (nonatomic, copy) JLDappTrackViewMoreBlock moreBlock;
@property (nonatomic, copy) JLDappTrackViewLookDappBlock lookDappBlock;

@property (nonatomic, copy) NSArray *dataArray;

@end

NS_ASSUME_NONNULL_END
