//
//  JLCashAccountPasswordAuthorizeView.h
//  CloudArtChain
//
//  Created by jielian on 2021/7/16.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JLCashAccountPasswordAuthorizeViewCompleteBlock)(NSString *passwords);
typedef void(^JLCashAccountPasswordAuthorizeViewCancelBlock)(void);

@interface JLCashAccountPasswordAuthorizeView : UIView

+ (void)showWithTitle: (NSString *)title complete: (JLCashAccountPasswordAuthorizeViewCompleteBlock)complete cancel: (JLCashAccountPasswordAuthorizeViewCancelBlock)cancel;

@end
