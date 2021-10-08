//
//  JLDappChainView.h
//  CloudArtChain
//
//  Created by jielian on 2021/9/26.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^JLDappChainViewLookDappBlock)(Model_dapp_Data *dappData);

@interface JLDappChainView : UIView

@property (nonatomic, copy) JLDappChainViewLookDappBlock lookDappBlock;

@property (nonatomic, copy) NSArray *dataArray;

@end

NS_ASSUME_NONNULL_END
