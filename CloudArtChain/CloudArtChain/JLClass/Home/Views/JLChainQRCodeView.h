//
//  JLChainQRCodeView.h
//  CloudArtChain
//
//  Created by 朱彬 on 2021/1/13.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JLChainQRCodeView : JLBaseView
- (instancetype)initWithFrame:(CGRect)frame qrcodeString:(NSString *)qrcodeString;
@end

NS_ASSUME_NONNULL_END
