//
//  JLTransferViewController.h
//  CloudArtChain
//
//  Created by 朱彬 on 2021/5/13.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JLTransferViewController : JLBaseViewController
@property (nonatomic, strong) Model_art_Detail_Data *artDetailData;
@property (nonatomic, copy) void(^transferSuccessBlock)(void);
@end

NS_ASSUME_NONNULL_END
