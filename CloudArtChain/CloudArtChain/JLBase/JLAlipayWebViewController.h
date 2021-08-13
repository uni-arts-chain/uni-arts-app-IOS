//
//  JLAlipayWebViewController.h
//  CloudArtChain
//
//  Created by 朱彬 on 2021/5/17.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JLAlipayWebViewController : JLBaseViewController
@property (nonatomic, strong) NSString *payUrl;
@property (nonatomic, copy) void(^paySuccessBlock)(void);
@end

NS_ASSUME_NONNULL_END
