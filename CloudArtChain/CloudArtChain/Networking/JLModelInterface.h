//
//  JLModelInterface.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>


@interface JLModelInterface : NSObject
+ (NSString*)getName;
@end

#pragma mark MODEL基类
@interface Model_Base : JSONModel
- (void)dump;
- (void)autoFillNecessaryFields:(NSString *)ifName;
- (void)setValue:(id)value forUndefinedKey:(NSString *)key;
@end

#pragma mark 接口MODEL基类
@interface Model_Interface : Model_Base
@end

#pragma mark 请求消息基类
@interface Model_Req : Model_Interface

@end

#pragma mark 应答头部消息
@interface Model_head_data : Model_Interface
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *msg;
@end

#pragma mark 应答消息基类
@interface Model_Rsp : Model_Interface
@property (nonatomic, strong) Model_head_data *head;
@property (nonatomic,   copy) NSString *baseUrl; //基础域名
@property (nonatomic,   copy) NSString *serverVersionSubpath; //版本子路径
@property (nonatomic, strong) NSString *interfacePath;
@end

#pragma mark 版本v1应答消息基类
@interface Model_Rsp_V1 : Model_Rsp
@end

#pragma mark 版本v2应答消息基类
@interface Model_Rsp_V2 : Model_Rsp
@end
