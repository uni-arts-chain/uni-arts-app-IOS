//
//  JLBoxModel.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/4/25.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLBoxModel.h"
#import "JLBoxImageSizeCacheDefaults.h"
#import "UIImage+ImgSize.h"

@implementation JLBoxModel
@end

//////////////////////////////////////////////////////////////////////////
#pragma mark /v1/blind_boxes 盲盒列表
@implementation Model_blind_boxes_card_groups_Data
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
#pragma mark /v1/blind_box_orders/:id/history 盲盒开启记录
@implementation Model_blind_box_orders_history_Data
@end
@implementation Model_blind_box_orders_history_Req
@end
@implementation Model_blind_box_orders_history_Rsp
- (NSString *)interfacePath {
    return [NSString stringWithFormat:@"blind_box_orders/%@/history", self.request.box_id];
}
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark 购买盲盒 /v1/blind_box_orders
#pragma mark 购买盲盒 /v1/blind_box_orders
@implementation Model_blind_box_orders_Req
@end
@implementation Model_blind_box_orders_Rsp
- (NSString *)interfacePath {
    return @"blind_box_orders";
}
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark /v1/blind_box_orders/check 查看是否有未开启盲盒
@implementation Model_blind_box_orders_check_Data
@end
@implementation Model_blind_box_orders_check_Req
@end
@implementation Model_blind_box_orders_check_Rsp
- (NSString *)interfacePath {
    return @"blind_box_orders/check";
}
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark /v1/blind_box_orders/open 开启盲盒
@implementation Model_blind_box_orders_open_Data
- (void)setImg_main_file1:(NSDictionary *)img_main_file1 {
    _img_main_file1 = img_main_file1;
    NSString *mainFileUrl = img_main_file1[@"url"];
    NSString *mainFileUrlKey = [mainFileUrl stringByAppendingString:self.art_id];
    if (![NSString stringIsEmpty:mainFileUrl]) {
        if (![[JLBoxImageSizeCacheDefaults standardUserDefaults] objectForKey:mainFileUrlKey]) {
            CGSize imageSize = [UIImage getImageSizeWithURL:mainFileUrl];
            CGFloat imgH = 0;
            if (imageSize.height > 0) {
                imgH = imageSize.height * 185.0f / imageSize.width;
                [[JLBoxImageSizeCacheDefaults standardUserDefaults] setObject:@(imgH) forKey:mainFileUrlKey];
            }
        }
    }
}

- (CGFloat)imgHeight {
    NSString *mainFileUrl = self.img_main_file1[@"url"];
    NSString *mainFileUrlKey = [mainFileUrl stringByAppendingString:self.art_id];
    if (![NSString stringIsEmpty:mainFileUrl]) {
        NSNumber *imgHeightNumber = [[JLBoxImageSizeCacheDefaults standardUserDefaults] objectForKey:mainFileUrlKey];
        if (imgHeightNumber) {
            return imgHeightNumber.floatValue;
        } else {
            return 120.0f;
        }
    }
    return 120.0f;
}

@end
@implementation Model_blind_box_orders_open_Req
@end
@implementation Model_blind_box_orders_open_Rsp
- (NSString *)interfacePath {
    return @"blind_box_orders/open";
}
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark /v1/blind_box_orders/check_order 检查盲盒是否可继续购买
@implementation Model_blind_box_orders_check_order_Data
@end
@implementation Model_blind_box_orders_check_order_Req
@end
@implementation Model_blind_box_orders_check_order_Rsp
- (NSString *)interfacePath {
    return @"blind_box_orders/check_order";
}
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark /v1/blind_boxes/:id 盲盒详情
@implementation Model_blind_boxes_detail_Req
@end
@implementation Model_blind_boxes_detail_Rsp
- (NSString *)interfacePath {
    return [NSString stringWithFormat:@"blind_boxes/%@", self.request.boxId];
}
@end
//////////////////////////////////////////////////////////////////////////
