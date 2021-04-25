//
//  JLBoxModel.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/4/25.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLBoxModel.h"

@implementation JLBoxModel
@end

//////////////////////////////////////////////////////////////////////////
#pragma mark /v1/blind_boxes 盲盒列表
@implementation Model_Model_blind_boxes_card_groups_Data
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"ID": @"id"}];
}
@end
@implementation Model_blind_boxes_Data
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"ID": @"id"}];
}
@end
@implementation Model_blind_boxes_Req
@end
@implementation Model_blind_boxes_Rsp
- (NSString *)interfacePath {
    return @"blind_boxes";
}
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark /v1/blind_box_draws 盲盒开启记录
@implementation Model_blind_box_draws_Req
@end
@implementation Model_blind_box_draws_Rsp
- (NSString *)interfacePath {
    return @"blind_box_draws";
}
@end
//////////////////////////////////////////////////////////////////////////
