//
//  JLBoxModel.h
//  CloudArtChain
//
//  Created by 朱彬 on 2021/4/25.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JLBoxModel : NSObject
@end

//////////////////////////////////////////////////////////////////////////
#pragma mark /v1/blind_boxes 盲盒列表
@protocol Model_blind_boxes_card_groups_Data @end
@interface Model_blind_boxes_card_groups_Data : Model_Interface
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *box_id;
@property (nonatomic, strong) NSString *seller_id;
@property (nonatomic, strong) NSString *amount;
@property (nonatomic, strong) NSString *remain_amount;
@property (nonatomic, strong) NSString *special_attr;
@property (nonatomic, strong) Model_art_Detail_Data *art;
@end
@protocol Model_blind_boxes_Data @end
@interface Model_blind_boxes_Data : Model_Interface
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *img_path;
@property (nonatomic, strong) NSString *background_img_path;
@property (nonatomic, strong) NSString *app_img_path;
@property (nonatomic, strong) NSString *app_background_img_path;
@property (nonatomic, strong) NSString *app_cover_img_path;
@property (nonatomic, strong) NSString *rule;
@property (nonatomic, strong) NSString *start_time;
@property (nonatomic, strong) NSString *end_time;
@property (nonatomic, strong) NSString *special_attr;
@property (nonatomic, strong) NSArray<Model_blind_boxes_card_groups_Data> *onchain_card_groups;
@end
@interface Model_blind_boxes_Req : Model_Req
@end
@interface Model_blind_boxes_Rsp : Model_Rsp_V1
@property (nonatomic, strong) NSArray<Model_blind_boxes_Data> *body;
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark /v1/blind_box_orders/:id/history 盲盒开启记录
@protocol Model_blind_box_orders_history_Data @end
@interface Model_blind_box_orders_history_Data : Model_Interface
@property (nonatomic, strong) NSString *art_id;
@property (nonatomic, strong) NSString *name;
/** 1: 静图 2: gif 3: live2d 4: movie */
@property (nonatomic, assign) NSInteger resource_type;
@property (nonatomic, strong) NSDictionary *img_main_file1;
@property (nonatomic, strong) NSString *special_attr;
@property (nonatomic, strong) NSString *extrinsic_hash;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *nft_address;
@end
@interface Model_blind_box_orders_history_Req : Model_Req
@property (nonatomic, strong) NSString *box_id;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger per_page;
@end
@interface Model_blind_box_orders_history_Rsp : Model_Rsp_V1
@property (nonatomic, strong) Model_blind_box_orders_history_Req *request;
@property (nonatomic, strong) NSArray<Model_blind_box_orders_history_Data> *body;
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark 购买盲盒 /v1/blind_box_orders
@interface Model_blind_box_orders_Req : Model_Req
@property (nonatomic, strong) NSString *box_id;
@property (nonatomic, strong) NSString *amount;
/** web/ios/android */
@property (nonatomic, strong) NSString *order_from;
@property (nonatomic, strong) NSString *pay_type;
@end
@interface Model_blind_box_orders_Rsp : Model_Rsp_V1
@property (nonatomic, strong) NSDictionary *body;
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark /v1/blind_box_orders/check 查看是否有未开启盲盒
@protocol Model_blind_box_orders_check_Data @end
@interface Model_blind_box_orders_check_Data : Model_Interface
@property (nonatomic, strong) NSString *sn;
@property (nonatomic, strong) NSString *total;
@property (nonatomic, strong) NSString *opened;
@property (nonatomic, strong) NSString *left;
@end
@interface Model_blind_box_orders_check_Req : Model_Req
@property (nonatomic, strong) NSString *box_id;
@end
@interface Model_blind_box_orders_check_Rsp : Model_Rsp_V1
@property (nonatomic, strong) NSArray<Model_blind_box_orders_check_Data> *body;
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark /v1/blind_box_orders/open 开启盲盒
@protocol Model_blind_box_orders_open_Data @end
@interface Model_blind_box_orders_open_Data : Model_Interface
@property (nonatomic, strong) NSString *art_id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSDictionary *img_main_file1;
@property (nonatomic, strong) NSString *special_attr;
@property (nonatomic, strong) NSString *extrinsic_hash;
@property (nonatomic, assign) NSInteger opened;
@property (nonatomic, assign) NSInteger left;
@property (nonatomic, assign) NSInteger total;
@property (nonatomic, strong) NSString *created_at;
/** 1: 静图 2: gif 3: live2d 4: movie */
@property (nonatomic, assign) NSInteger resource_type;

@property (nonatomic, assign) CGFloat imgHeight; //单张图片高度
@end
@interface Model_blind_box_orders_open_Req : Model_Req
@property (nonatomic, strong) NSString *sn;
@end
@interface Model_blind_box_orders_open_Rsp : Model_Rsp_V1
@property (nonatomic, strong) NSArray<Model_blind_box_orders_open_Data> *body;
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark /v1/blind_box_orders/check_order 检查盲盒是否可继续购买
@interface Model_blind_box_orders_check_order_Data : Model_Interface
@property (nonatomic, assign) BOOL allow;
@end
@interface Model_blind_box_orders_check_order_Req : Model_Req
@property (nonatomic, strong) NSString *box_id;
@property (nonatomic, strong) NSString *amount;
@end
@interface Model_blind_box_orders_check_order_Rsp : Model_Rsp_V1
@property (nonatomic, strong) Model_blind_box_orders_check_order_Data *body;
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark /v1/blind_boxes/:id 盲盒详情
@interface Model_blind_boxes_detail_Req : Model_Req
@property (nonatomic, strong) NSString *boxId;
@end
@interface Model_blind_boxes_detail_Rsp : Model_Rsp_V1
@property (nonatomic, strong) Model_blind_boxes_detail_Req *request;
@property (nonatomic, strong) Model_blind_boxes_Data *body;
@end
//////////////////////////////////////////////////////////////////////////
