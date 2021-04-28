//
//  JLUploadWorkViewController.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/17.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JLUploadWorkViewController : JLBaseViewController
@property (nonatomic, copy) void(^checkProcessBlock)(void);
@property (nonatomic, copy) void(^uploadSuccessBackBlock)(void);
@end

NS_ASSUME_NONNULL_END
