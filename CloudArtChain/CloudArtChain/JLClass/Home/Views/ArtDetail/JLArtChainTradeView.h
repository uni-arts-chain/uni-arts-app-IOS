//
//  JLArtChainTradeView.h
//  CloudArtChain
//
//  Created by 朱彬 on 2021/4/23.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLBaseView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^JLArtChainTradeViewShowCertificateBlock)(void);

@interface JLArtChainTradeView : JLBaseView
/// 0:不分(所有) 1:新品 2:二手
@property (nonatomic, assign) NSInteger marketLevel;

@property (nonatomic, strong) Model_art_Detail_Data *artDetailData;
@property (nonatomic, copy) JLArtChainTradeViewShowCertificateBlock showCertificateBlock;
@end

NS_ASSUME_NONNULL_END
