//
//  JLModelInterface.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLModelInterface.h"

@implementation JLModelInterface
+ (NSString*)getName{
    return @"InterfaceBase";
}
@end

@implementation Model_Base

- (void)dump{
    NSLog(@"%@", self);
}

- (void)autoFillNecessaryFields:(NSString*)ifName{
    
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    NSString *msg = [NSString stringWithFormat:@"接口数据Model类:%@ 未发现:%@字段，需要检查接口定义", [self class], key];
    NSLog(@"%@", msg);
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}
@end

@implementation Model_Interface
@end

@implementation Model_Req
@end

@implementation Model_head_data

@end

@implementation Model_Rsp
- (NSString *)baseUrl {
    return NETINTERFACE_URL_CLOUDARTCHAIN;
}

- (NSString *)serverVersionSubpath {
    return @"api/";
}

- (NSString *)interfacePath {
    return @"";
}

@end

@implementation Model_Rsp_V1
- (NSString *)serverVersionSubpath {
    return [NSString stringWithFormat:@"api/v1/"];
}
@end

@implementation Model_Rsp_V2
- (NSString *)serverVersionSubpath {
    return [NSString stringWithFormat:@"api/v2/"];
}
@end
