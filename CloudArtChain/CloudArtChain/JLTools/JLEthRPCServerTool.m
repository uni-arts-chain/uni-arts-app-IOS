//
//  JLEthRPCServerTool.m
//  CloudArtChain
//
//  Created by jielian on 2021/10/25.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLEthRPCServerTool.h"

@implementation JLEthRPCServerTool

#pragma mark - 以太坊服务相关
/// 存储服务
+ (void)saveEthRPCServer: (Model_eth_rpc_server_data *)rpcServer {
    NSError *error = nil;
    NSData *rpcServerData =  [NSKeyedArchiver archivedDataWithRootObject:rpcServer requiringSecureCoding:YES error:&error];
    if (!error) {
        NSError *error1 = nil;
        [rpcServerData writeToFile:JLEthRPCServerFilepath options:NSDataWritingAtomic error:&error1];
        if (!error1) {
            JLLog(@"ethRPCServer保存成功！");
        }else {
            JLLog(@"ethRPCServer保存失败！error: %@", error1);
        }
    }else {
        JLLog(@"ethRPCServer保存失败！error: %@", error);
    }
}
/// 读取服务
+ (Model_eth_rpc_server_data *)ethRPCServer {
    NSError *error = nil;
    NSData *serverData = [NSData dataWithContentsOfFile:JLEthRPCServerFilepath options:NSDataReadingMappedIfSafe error:&error];
    if (!error) {
        NSSet *set = [[NSSet alloc] initWithArray:@[[Model_eth_rpc_server_data class]]];
        NSError *error1 = nil;
        Model_eth_rpc_server_data *server = [NSKeyedUnarchiver unarchivedObjectOfClasses:set fromData:serverData error:&error1];
        if (!error1) {
            return server;
        }
    }
    return nil;
}
/// 删除服务
+ (void)deleteEthRPCServer {
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    if ([defaultManager isDeletableFileAtPath:JLEthRPCServerFilepath]) {
        NSError *error = nil;
        [defaultManager removeItemAtPath:JLEthRPCServerFilepath error:&error];
        if (!error) {
            JLLog(@"删除rpcServer成功");
        }else {
            JLLog(@"删除rpcServer失败 error: %@", error);
        }
    }else {
        JLLog(@"删除rpcServer失败 未发现此文件");
    }
}

@end
