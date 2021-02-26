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
@implementation Model_arts_categories_Data
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"ID": @"id"}];
}
@end
@implementation Model_arts_categories_Req
@end
@implementation Model_arts_categories_Rsp
@end
// ==========================================================
#pragma mark /arts/themes 主题
@implementation Model_arts_themes_Data
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"ID": @"id"}];
}
@end
@implementation Model_arts_themes_Req

@end
@implementation Model_arts_themes_Rsp

@end
// ==========================================================
#pragma mark /arts/materials 材质
@implementation Model_arts_materials_Data
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"ID": @"id"}];
}
@end
@implementation Model_arts_materials_Req

@end
@implementation Model_arts_materials_Rsp

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
