//
//  JLWalletPwdViewController.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/3.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLWalletPwdViewController : UIViewController
@property (nonatomic, copy) void(^endEditBlock)(NSString *pwd);
@end

NS_ASSUME_NONNULL_END
