//
//  RFKeyChain.h
//  Rfinex
//
//  Created by 曾进宗 on 2019/1/15.
//  Copyright © 2019 HuaXinBlockChain(Shenyang)Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JLKeyChain : NSObject

+ (JLKeyChain *)sharedKeyChain;

//获取设备UUID
+ (NSString*)getDeviceUuid;

- (NSString*)getObjectDeviceUuid;

@end

