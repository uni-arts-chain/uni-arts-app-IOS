//
//  JLBaseWebViewController.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JLBaseWebViewController : JLBaseViewController
- (instancetype)initWithWebUrl:(NSString *)url naviTitle:(NSString *)title;
- (instancetype)initWithHtmlContent:(NSString *)htmlContent naviTitle:(NSString *)title;
@end

NS_ASSUME_NONNULL_END
