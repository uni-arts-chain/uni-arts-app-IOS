//
//  JLDappApplyForAuthorisationView.h
//  CloudArtChain
//
//  Created by jielian on 2021/9/28.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^JLDappApplyForAuthorisationViewAgreeBlock)(void);
typedef void(^JLDappApplyForAuthorisationViewRefuseBlock)(void);

@interface JLDappApplyForAuthorisationView : UIView

+ (void)showWithDappName: (NSString *)dappName
              dappImgUrl: (NSString *)dappImgUrl
              dappWebUrl: (NSString *)dappWebUrl
               superView: (UIView * _Nullable)superView
                  refuse: (JLDappApplyForAuthorisationViewRefuseBlock)refuse
                   agree: (JLDappApplyForAuthorisationViewAgreeBlock _Nullable)agree;

@end

NS_ASSUME_NONNULL_END
