//
//  JLVersionManager.h
//  Miner_Fil
//
//  Created by 朱彬 on 2020/7/13.
//  Copyright © 2020 花田半亩. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLVersionManager : NSObject
+ (JLVersionManager *)shared;
+ (void)checkVersion;
@end

NS_ASSUME_NONNULL_END
