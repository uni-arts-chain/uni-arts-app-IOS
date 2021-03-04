//
//  JLPersonalDescriptionViewController.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/16.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JLPersonalDescriptionViewController : JLBaseViewController
@property (nonatomic, copy) void(^saveBlock)(NSString *residentialAddress, NSString *college, NSString *desc);
@end

NS_ASSUME_NONNULL_END
