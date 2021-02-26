//
//  JLHomeModel.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/2/25.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLHomeModel.h"

@implementation JLHomeModel
@end

//////////////////////////////////////////////////////////////////////////
#pragma mark ------ Banners管理
#pragma mark Banner列表 /banners
@implementation Model_banners_Data
@end
@implementation Model_banners_Req
@end
@implementation Model_banners_Rsp
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark ------ 新闻中心
#pragma mark 新闻列表 /news
@implementation Model_news_Data
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"ID": @"id"}];
}
- (void)setCreated_at:(NSString *)created_at {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:created_at.intValue];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    _created_at = [dateFormatter stringFromDate:date];
}
@end
@implementation Model_news_Req
@end
@implementation Model_news_Rsp
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark ----- 拍卖会
#pragma mark 拍卖会列表 /auction_meetings
@implementation Model_auction_meetings_Data
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"ID": @"id"}];
}
@end
@implementation Model_auction_meetings_Req
@end
@implementation Model_auction_meetings_Rsp
- (NSString *)interfacePath {
    return @"auction_meetings";
}
@end
//////////////////////////////////////////////////////////////////////////
@implementation Model_art_author_Data
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"ID": @"id"}];
}
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark 拍卖会通过审核的作品列表 /auction_meetings/:id/arts
@implementation Model_auction_meetings_art_Detail_Data
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"ID": @"id"}];
}
@end
@implementation Model_auction_meetings_arts_Data
@end
@implementation Model_auction_meetings_arts_Req
@end
@implementation Model_auction_meetings_arts_Rsp
- (NSString *)interfacePath {
    return [NSString stringWithFormat:@"/auction_meetings/%@/arts", self.request.meeting_id];
}
@end
//////////////////////////////////////////////////////////////////////////
