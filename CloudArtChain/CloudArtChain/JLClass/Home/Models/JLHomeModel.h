//
//  JLHomeModel.h
//  CloudArtChain
//
//  Created by 朱彬 on 2021/2/25.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JLHomeModel : NSObject
@end

//////////////////////////////////////////////////////////////////////////
#pragma mark ------ Banners管理
#pragma mark Banner列表 /banners
@protocol Model_banners_Data @end
@interface Model_banners_Data : Model_Interface
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *img_max;
@property (nonatomic, strong) NSString *img_middle;
@property (nonatomic, strong) NSString *img_min;
@end
@interface Model_banners_Req : Model_Req
/** 平台 0 pc, 1 mobil */
@property (nonatomic, strong) NSString *platform;
@end
@interface Model_banners_Rsp : Model_Rsp_V1
@property (nonatomic, strong) NSArray<Model_banners_Data> *body;
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark ------ 新闻中心
#pragma mark 新闻列表 /news
@protocol Model_news_Data @end
@interface Model_news_Data : Model_Interface
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *from;
@property (nonatomic, strong) NSString *label;
@property (nonatomic, strong) NSString *summary;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *cover;
@property (nonatomic, strong) NSString *link;
@property (nonatomic, strong) NSString *created_at;
@end
@interface Model_news_Req : Model_Req
/** 页码 */
@property (nonatomic, assign) NSInteger page;
/** 类型  Available values : New::New, New::Announcement */
@property (nonatomic, strong) NSString *type;
@end
@interface Model_news_Rsp : Model_Rsp_V1
@property (nonatomic, strong) NSArray<Model_news_Data> *body;
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark ----- 拍卖会
#pragma mark 拍卖会列表 /auction_meetings
@protocol Model_auction_meetings_Data @end
@interface Model_auction_meetings_Data : Model_Interface
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *topic;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *aasm_state;
@property (nonatomic, strong) NSString *start_at;
@property (nonatomic, strong) NSString *end_at;
@property (nonatomic, strong) NSDictionary *img_file;
@property (nonatomic, strong) NSString *owner_id;
@property (nonatomic, assign) NSInteger art_size;
@end
@interface Model_auction_meetings_Req : Model_Req
/** 页码 */
@property (nonatomic, assign) NSInteger page;
/** 每页多少 */
@property (nonatomic, assign) NSInteger per_page;
@end
@interface Model_auction_meetings_Rsp : Model_Rsp_V1
@property (nonatomic, strong) NSArray<Model_auction_meetings_Data> *body;
@end
//////////////////////////////////////////////////////////////////////////
@interface Model_art_author_Data : Model_Interface
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *phone_number;
@property (nonatomic, strong) NSString *sn;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *display_name;
@property (nonatomic, strong) NSString *nick_name;
@property (nonatomic, strong) NSString *ancestry;
@property (nonatomic, strong) NSString *disabled;
@property (nonatomic, strong) NSString *crypted_password;
@property (nonatomic, strong) NSString *salt;
@property (nonatomic, strong) NSString *client_id;
@property (nonatomic, strong) NSString *client_type;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *updated_at;
@property (nonatomic, strong) NSString *api_disabled;
@property (nonatomic, strong) NSString *role;
@property (nonatomic, assign) NSInteger register_type;
@property (nonatomic, assign) BOOL is_large_customer;
@property (nonatomic, strong) NSString *off;
@property (nonatomic, strong) NSString *electricity_off;
@property (nonatomic, strong) NSString *referer;
@property (nonatomic, strong) NSString *is_read_agreement;
@property (nonatomic, strong) NSString *mining_level;
@property (nonatomic, strong) NSString *invitation_level;
@property (nonatomic, strong) NSString *effective_user_count;
@property (nonatomic, strong) NSString *unbind_otp_at;
@property (nonatomic, strong) NSString *award_welfare_flag;
@property (nonatomic, strong) NSString *activate_code;
@property (nonatomic, strong) NSString *award_member_level;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSDictionary *avatar;
@property (nonatomic, strong) NSDictionary *recommend_image;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *artist_desc;
@property (nonatomic, assign) BOOL is_artist;
@property (nonatomic, strong) NSArray *tag_list;
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark 拍卖会通过审核的作品列表 /auction_meetings/:id/arts
@interface Model_auction_meetings_art_Detail_Data : Model_Interface
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger category_id;
@property (nonatomic, assign) NSInteger theme_id;
@property (nonatomic, assign) NSInteger material_id;
@property (nonatomic, strong) NSString *produce_at;
@property (nonatomic, strong) NSString *size_length;
@property (nonatomic, strong) NSString *size_width;
@property (nonatomic, strong) NSString *details;
@property (nonatomic, strong) NSDictionary *img_main_file1;
@property (nonatomic, strong) NSDictionary *img_main_file2;
@property (nonatomic, strong) NSDictionary *img_main_file3;
@property (nonatomic, strong) NSDictionary *img_detail_file1;
@property (nonatomic, strong) NSString *img_detail_file1_desc;
@property (nonatomic, strong) NSDictionary *img_detail_file2;
@property (nonatomic, strong) NSString *img_detail_file2_desc;
@property (nonatomic, strong) NSDictionary *img_detail_file3;
@property (nonatomic, strong) NSString *img_detail_file3_desc;
@property (nonatomic, strong) NSDictionary *img_detail_file4;
@property (nonatomic, strong) NSString *img_detail_file4_desc;
@property (nonatomic, strong) NSDictionary *img_detail_file5;
@property (nonatomic, strong) NSString *img_detail_file5_desc;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *fee;
@property (nonatomic, strong) NSString *position;
@property (nonatomic, strong) NSString *aasm_state;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *collection_id;
@property (nonatomic, strong) NSString *item_id;
@property (nonatomic, strong) NSString *member_id;
@property (nonatomic, strong) Model_art_author_Data *member;
@property (nonatomic, strong) Model_art_author_Data *author;
@property (nonatomic, strong) NSString *item_hash;
@property (nonatomic, strong) NSString *auction_start_time;
@property (nonatomic, strong) NSString *auction_end_time;
@property (nonatomic, assign) BOOL liked_by_me;
@property (nonatomic, assign) BOOL disliked_by_me;
@property (nonatomic, assign) BOOL favorite_by_me;
@property (nonatomic, assign) NSInteger liked_count;
@property (nonatomic, assign) NSInteger dislike_count;
@property (nonatomic, assign) NSInteger favorite_count;
@end
@protocol Model_auction_meetings_arts_Data @end
@interface Model_auction_meetings_arts_Data : Model_Interface
@property (nonatomic, strong) NSString *memo;
@property (nonatomic, strong) NSString *owner_memo;
@property (nonatomic, strong) NSString *aasm_state;
@property (nonatomic, strong) NSString *start_price;
@property (nonatomic, strong) NSString *price_increment;
@property (nonatomic, strong) NSString *start_time;
@property (nonatomic, strong) NSString *end_time;
@property (nonatomic, strong) Model_auction_meetings_art_Detail_Data *art;
@end
@interface Model_auction_meetings_arts_Req : Model_Req
/** 页码 */
@property (nonatomic, assign) NSInteger page;
/** 每页多少 */
@property (nonatomic, assign) NSInteger per_page;
/** 拍卖会id */
@property (nonatomic, strong) NSString *meeting_id;
@end
@interface Model_auction_meetings_arts_Rsp : Model_Rsp_V1
@property (nonatomic, strong) Model_auction_meetings_arts_Req *request;
@property (nonatomic, strong) NSArray<Model_auction_meetings_arts_Data> *body;
@end
//////////////////////////////////////////////////////////////////////////
