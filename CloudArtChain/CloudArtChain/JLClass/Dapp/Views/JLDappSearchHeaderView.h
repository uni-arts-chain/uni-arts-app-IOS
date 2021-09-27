//
//  JLDappSearchHeaderView.h
//  CloudArtChain
//
//  Created by jielian on 2021/9/26.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^JLDappSearchHeaderViewSearchBlock)(void);
typedef void(^JLDappSearchHeaderViewScanBlock)(void);

@interface JLDappSearchHeaderView : UIView

@property (nonatomic, copy) JLDappSearchHeaderViewSearchBlock searchBlock;
@property (nonatomic, copy) JLDappSearchHeaderViewScanBlock scanBlock;

@end

NS_ASSUME_NONNULL_END
