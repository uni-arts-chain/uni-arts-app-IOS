//
//  JLNoAddressView.h
//  CloudArtChain
//
//  Created by 朱彬 on 2021/1/21.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLNoAddressView : UIView
@property (nonatomic, copy) void(^addNewAddressBlock)(void);
@end

NS_ASSUME_NONNULL_END
