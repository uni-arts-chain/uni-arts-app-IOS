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
    if (![NSString stringIsEmpty:mainFileUrl]) {
        if (![[JLImageSizeCacheDefaults standardUserDefaults] objectForKey:mainFileUrl]) {
            CGSize imageSize = [UIImage getImageSizeWithURL:mainFileUrl];
            CGFloat imgH = 0;
            if (imageSize.height > 0) {
                imgH = imageSize.height * (kScreenWidth - 15.0f * 2 - 26.0f) * 0.5f / imageSize.width;
                [[JLImageSizeCacheDefaults standardUserDefaults] setObject:@(imgH) forKey:mainFileUrl];
            }
            
        }
    }
}

- (CGFloat)imgHeight {
    NSString *mainFileUrl = self.img_main_file1[@"url"];
    if (![NSString stringIsEmpty:mainFileUrl]) {
        NSNumber *imgHeightNumber = [[JLImageSizeCacheDefaults standardUserDefaults] objectForKey:mainFileUrl];
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
