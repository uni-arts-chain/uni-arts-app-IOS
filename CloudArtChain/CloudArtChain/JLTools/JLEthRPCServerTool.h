//
//  JLEthRPCServerTool.h
//  CloudArtChain
//
//  Created by jielian on 2021/10/25.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLEthRPCServerTool : NSObject

#pragma mark - 以太坊服务相关
/// 存储服务
+ (void)saveEthRPCServer: (Model_eth_rpc_server_data *)rpcServer;
/// 读取服务
+ (Model_eth_rpc_server_data *)ethRPCServer;
/// 删除服务
+ (void)deleteEthRPCServer;

@end

NS_ASSUME_NONNULL_END
