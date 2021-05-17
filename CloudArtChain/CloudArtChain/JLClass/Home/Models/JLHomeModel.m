//
//  JLHomeModel.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/2/25.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLHomeModel.h"
#import "JLImageSizeCacheDefaults.h"
#import "UIImage+ImgSize.h"

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
@implementation Model_art_Detail_Data
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"ID": @"id"}];
}
- (void)setImg_main_file1:(NSDictionary *)img_main_file1 {
    _img_main_file1 = img_main_file1;
    NSString *mainFileUrl = img_main_file1[@"url"];
    NSString *mainFileUrlKey = [mainFileUrl stringByAppendingString:self.ID];
    if (![NSString stringIsEmpty:mainFileUrl]) {
        if (![[JLImageSizeCacheDefaults standardUserDefaults] objectForKey:mainFileUrlKey]) {
            CGSize imageSize = [UIImage getImageSizeWithURL:mainFileUrl];
            CGFloat imgH = 0;
            if (imageSize.height > 0) {
                imgH = imageSize.height * (kScreenWidth - 15.0f * 2 - 26.0f) * 0.5f / imageSize.width;
                [[JLImageSizeCacheDefaults standardUserDefaults] setObject:@(imgH) forKey:mainFileUrlKey];
            }
            
        }
    }
}

- (CGFloat)imgHeight {
    NSString *mainFileUrl = self.img_main_file1[@"url"];
    NSString *mainFileUrlKey = [mainFileUrl stringByAppendingString:self.ID];
    if (![NSString stringIsEmpty:mainFileUrl]) {
        NSNumber *imgHeightNumber = [[JLImageSizeCacheDefaults standardUserDefaults] objectForKey:mainFileUrlKey];
        if (imgHeightNumber) {
            return imgHeightNumber.floatValue;
        } else {
            return 120.0f;
        }
    }
    return 120.0f;
}
@end
@implementation Model_auction_meetings_arts_Data
- (void)updateWithAuctionInfo:(AuctionInfo *)auctionInfo CurrentDate:(NSDate *)currentDate blockNumber:(UInt32)blockNumber {
    int precision = [[JLViewControllerTool appDelegate].walletTool getAssetPrecision];
    self.start_price = @([auctionInfo getStartPriceWithPrecision:precision]).stringValue;
    self.price_increment = @([auctionInfo getPriceIncrementWithPrecision:precision]).stringValue;
//    self.start_time = @([[auctionInfo getStartTimeWithCurrentDate:currentDate currentBlockNumber:blockNumber] timeIntervalSince1970]).stringValue;
//    self.end_time = @([[auctionInfo getEndTimeWithCurrentDate:currentDate currentBlockNumber:blockNumber] timeIntervalSince1970]).stringValue;
    self.art.price = @([auctionInfo getCurrentPriceWithPrecision:precision]).stringValue;
}
@end
@implementation Model_auction_meetings_arts_Req
@end
@implementation Model_auction_meetings_arts_Rsp
- (NSString *)interfacePath {
    return [NSString stringWithFormat:@"/auction_meetings/%@/arts", self.request.meeting_id];
}
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark /arts/popular 热门原创
@implementation Model_arts_popular_Req
@end
@implementation Model_arts_popular_Rsp
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark /arts/topic 主题推荐
@implementation Model_arts_topic_Data
@end
@implementation Model_arts_topic_Req
@end
@implementation Model_arts_topic_Rsp
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark /arts/:id/like 赞
@implementation Model_arts_like_Req
@end
@implementation Model_arts_like_Rsp
- (NSString *)interfacePath {
    return [NSString stringWithFormat:@"arts/%@/like", self.request.art_id];
}
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark /arts/:id/cancel_like 取消赞
@implementation Model_art_cancel_like_Req
@end
@implementation Model_art_cancel_like_Rsp
- (NSString *)interfacePath {
    return [NSString stringWithFormat:@"arts/%@/cancel_like", self.request.art_id];
}
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark /arts/:id/dislike 踩
@implementation Model_art_dislike_Req
@end
@implementation Model_art_dislike_Rsp
- (NSString *)interfacePath {
    return [NSString stringWithFormat:@"arts/%@/dislike", self.request.art_id];
}
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark /arts/:id/cancel_dislike 取消踩
@implementation Model_art_cancel_dislike_Req
@end
@implementation Model_art_cancel_dislike_Rsp
- (NSString *)interfacePath {
    return [NSString stringWithFormat:@"arts/%@/cancel_dislike", self.request.art_id];
}
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark /arts/:id/favorite 收藏作品
@implementation Model_art_favorite_Req
@end
@implementation Model_art_favorite_Rsp
- (NSString *)interfacePath {
    return [NSString stringWithFormat:@"arts/%@/favorite", self.request.art_id];
}
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark /arts/:id/unfavorite 取消收藏作品
@implementation Model_art_unfavorite_Req
@end
@implementation Model_art_unfavorite_Rsp
- (NSString *)interfacePath {
    return [NSString stringWithFormat:@"arts/%@/unfavorite", self.request.art_id];
}
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark /arts/my_signatures 个人签名的艺术作品
@implementation Model_arts_my_signatures_Req
@end
@implementation Model_arts_my_signatures_Rsp
- (NSString *)interfacePath {
    return @"arts/my_signatures";
}
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark /organizations 机构列表
@implementation Model_organizations_Data : Model_Interface
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"ID": @"id"}];
}
@end
@implementation Model_organizations_Req
@end
@implementation Model_organizations_Rsp
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark /arts/applying_signatures 申请机构签名艺术作品列表
@implementation Model_arts_applying_signatures_Req
@end
@implementation Model_arts_applying_signatures_Rsp
- (NSString *)interfacePath {
    return @"arts/applying_signatures";
}
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark /arts/:id/apply_signature 申请签名（加签）艺术作品
@implementation Model_arts_apply_signature_Req
@end
@implementation Model_arts_apply_signature_Rsp
- (NSString *)interfacePath {
    return [NSString stringWithFormat:@"arts/%@/apply_signature", self.request.art_id];
}
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark /arts/available_signature_arts 可以签名的艺术作品
@implementation Model_arts_available_signature_arts_Req
@end
@implementation Model_arts_available_signature_arts_Rsp
- (NSString *)interfacePath {
    return @"arts/available_signature_arts";
}
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark /messages 通知列表
@implementation Model_messages_Data
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"ID": @"id"}];
}
@end
@implementation Model_messages_Req
@end
@implementation Model_messages_Rsp
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark /messages/read 消息已读
@implementation Model_messages_read_Req
@end
@implementation Model_messages_read_Rsp
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark /messages/has_unread 用户是否有未读消息
@implementation Model_messages_has_unread_Data
@end
@implementation Model_messages_has_unread_Req
@end
@implementation Model_messages_has_unread_Rsp
- (NSString *)interfacePath {
    return @"messages/has_unread";
}
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark /messages/read_all 全部已读
@implementation Model_messages_read_all_Req
@end
@implementation Model_messages_read_all_Rsp
- (NSString *)interfacePath {
    return @"messages/read_all";
}
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark /v1/arts/#{id}/orders 出售列表
@implementation Model_arts_id_orders_Data
@end
@implementation Model_arts_id_orders_Req
@end
@implementation Model_arts_id_orders_Rsp
- (NSString *)interfacePath {
    return [NSString stringWithFormat:@"arts/%@/orders", self.request.ID];
}
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark /v1/arts/:id 个人艺术品详情
@implementation Model_arts_detail_Req
@end
@implementation Model_arts_detail_Rsp
- (NSString *)interfacePath {
    return [NSString stringWithFormat:@"arts/%@", self.request.art_id];
}
@end
//////////////////////////////////////////////////////////////////////////
