//
//  RFKeyChain.m
//  Rfinex
//
//  Created by 曾进宗 on 2019/1/15.
//  Copyright © 2019 HuaXinBlockChain(Shenyang)Tech. All rights reserved.
//

#import "JLKeyChain.h"
#import "UICKeyChainStore.h"
static NSString *const UUIDService = @"com.CloudArtChain";
@interface JLKeyChain()
@property (nonatomic,strong) NSString *deviceUuid; //当前设备UUID

@end

@implementation JLKeyChain

+ (JLKeyChain *)sharedKeyChain
{
    static JLKeyChain *_sharedKeyChain = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedKeyChain = [[JLKeyChain alloc] init];
    });
    return _sharedKeyChain;
}

#pragma mark 获取应用UUID
+ (NSString*)getDeviceUuid
{
    return [[JLKeyChain sharedKeyChain] getObjectDeviceUuid];
}

- (NSString*)getObjectDeviceUuid{
    if (_deviceUuid.length==0) {
        UICKeyChainStore *keyChainStore = [UICKeyChainStore keyChainStoreWithService:UUIDService];
        NSString * currentDeviceUUIDStr = [keyChainStore stringForKey:@"uuid"];
        if (currentDeviceUUIDStr == nil || [currentDeviceUUIDStr isEqualToString:@""])
        {
            NSUUID * currentDeviceUUID  = [UIDevice currentDevice].identifierForVendor;
            currentDeviceUUIDStr = currentDeviceUUID.UUIDString;
            currentDeviceUUIDStr = [currentDeviceUUIDStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
            currentDeviceUUIDStr = [currentDeviceUUIDStr lowercaseString];
            [keyChainStore setString:currentDeviceUUIDStr forKey:@"uuid"];
        }
        _deviceUuid = currentDeviceUUIDStr;
    }
//    NSLog(@"设备UUID = %@",_deviceUuid);
    return _deviceUuid;
}


@end
