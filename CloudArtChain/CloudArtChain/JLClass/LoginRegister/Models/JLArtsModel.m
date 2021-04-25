//
//  JLArtsModel.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/2/25.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLArtsModel.h"

@implementation JLArtsModel
@end

// ==========================================================
#pragma mark /arts/categories 分类
@implementation Model_arts_theme_Data
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"ID": @"id"}];
}
@end
@implementation Model_arts_theme_Req
@end
@implementation Model_arts_theme_Rsp
- (NSString *)interfacePath {
    return @"arts/categories";
}
@end
// ==========================================================
#pragma mark /arts/art_types 类型
@implementation Model_arts_art_types_Data
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"ID": @"id"}];
}
@end
@implementation Model_arts_art_types_Req

@end
@implementation Model_arts_art_types_Rsp
- (NSString *)interfacePath {
    return @"arts/art_types";
}
@end
// ==========================================================
#pragma mark /arts/prices 价格区间
@implementation Model_arts_prices_Data
@end
@implementation Model_arts_prices_Req
@end
@implementation Model_arts_prices_Rsp
@end
// ==========================================================
