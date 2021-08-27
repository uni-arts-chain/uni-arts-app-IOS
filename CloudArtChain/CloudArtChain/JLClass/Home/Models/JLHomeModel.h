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
@interface Model_banners_Rsp : Model_Rsp_V2
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
@interface Model_news_Rsp : Model_Rsp_V2
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
@interface Model_auction_meetings_Rsp : Model_Rsp_V2
@property (nonatomic, strong) NSArray<Model_auction_meetings_Data> *body;
@end
//////////////////////////////////////////////////////////////////////////
@protocol Model_art_author_Data @end
@interface Model_art_author_Data : Model_Interface
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *phone_number;
@property (nonatomic, strong) NSString *sn;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *display_name;
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
@property (nonatomic, assign) BOOL follow_by_me;
@property (nonatomic, assign) NSInteger art_size;
@property (nonatomic, strong) NSString *residential_address;
@property (nonatomic, strong) NSString *college;
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark 拍卖会通过审核的作品列表 /auction_meetings/:id/arts
@protocol Model_art_Detail_Data @end
@interface Model_art_Detail_Data : Model_Interface
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger category_id;
@property (nonatomic, assign) NSInteger theme_id;
@property (nonatomic, assign) NSInteger material_id;
@property (nonatomic, strong) NSString *produce_at;
@property (nonatomic, strong) NSString *size_length;
@property (nonatomic, strong) NSString *size_width;
@property (nonatomic, strong) NSString *details;
@property (nonatomic, strong) NSArray *detail_imgs;
@property (nonatomic, strong) NSString *video_url;
@property (nonatomic, assign) NSInteger resource_type;
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
/** 状态,多个逗号分割 prepare(上传未上链), online(已上链), bidding(已上架), auctioning(拍卖中) */
@property (nonatomic, strong) NSString *aasm_state;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *collection_id;
@property (nonatomic, strong) NSString *item_id;
@property (nonatomic, strong) NSString *member_id;
//@property (nonatomic, strong) Model_art_author_Data *member;
@property (nonatomic, strong) Model_art_author_Data *author;
@property (nonatomic, strong) NSString *item_hash;
@property (nonatomic, strong) NSString *auction_start_time;
@property (nonatomic, strong) NSString *auction_end_time;
@property (nonatomic, assign) NSTimeInterval server_time;
@property (nonatomic, assign) BOOL liked_by_me;
@property (nonatomic, assign) BOOL disliked_by_me;
@property (nonatomic, assign) BOOL favorite_by_me;
@property (nonatomic, assign) NSInteger liked_count;
@property (nonatomic, assign) NSInteger dislike_count;
@property (nonatomic, assign) NSInteger favorite_count;
@property (nonatomic, assign) NSInteger signature_count;
@property (nonatomic, strong) NSString *last_sign_at;

@property (nonatomic, strong) NSString *royalty;
@property (nonatomic, strong) NSString *royalty_expired_at;
@property (nonatomic, assign) BOOL has_royalty;
@property (nonatomic, strong) NSString *live2d_file;
@property (nonatomic, strong) NSString *live2d_ipfs_url;
@property (nonatomic, strong) NSString *live2d_ipfs_zip_url;
/** 是否拆分 1,2不可拆分 3可拆分 */
@property (nonatomic, assign) NSInteger collection_mode;
/** 总数量 */
@property (nonatomic, assign) NSInteger total_amount;
/** 当前拥有数量 */
@property (nonatomic, assign) NSInteger has_amount;
@property (nonatomic, assign) BOOL is_owner;
@property (nonatomic, strong) NSString *selling_amount;
@property (nonatomic, strong) NSString *trades_count;

@property (nonatomic, assign) CGFloat imgHeight; //单张图片高度
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
@property (nonatomic, strong) Model_art_Detail_Data *art;
- (void)updateWithAuctionInfo:(AuctionInfo *)auctionInfo CurrentDate:(NSDate *)currentDate blockNumber:(UInt32)blockNumber;
@end
@interface Model_auction_meetings_arts_Req : Model_Req
/** 页码 */
@property (nonatomic, assign) NSInteger page;
/** 每页多少 */
@property (nonatomic, assign) NSInteger per_page;
/** 拍卖会id */
@property (nonatomic, strong) NSString *meeting_id;
@end
@interface Model_auction_meetings_arts_Rsp : Model_Rsp_V2
@property (nonatomic, strong) Model_auction_meetings_arts_Req *request;
@property (nonatomic, strong) NSArray<Model_auction_meetings_arts_Data> *body;
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark /arts/popular 热门原创
@interface Model_arts_popular_Req : Model_Req
/** 页码 */
@property (nonatomic, assign) NSInteger page;
/** 每页多少 */
@property (nonatomic, assign) NSInteger per_page;
@end
@interface Model_arts_popular_Rsp : Model_Rsp_V2
@property (nonatomic, strong) NSArray<Model_art_Detail_Data> *body;
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark /arts/topic 主题推荐
@protocol Model_arts_topic_Data @end
@interface Model_arts_topic_Data : Model_Interface
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSDictionary *img_file;
@property (nonatomic, strong) NSDictionary *app_img_file;
@property (nonatomic, strong) NSArray<Model_art_Detail_Data> *arts;
@end
@interface Model_arts_topic_Req : Model_Req
/** 页码 */
@property (nonatomic, assign) NSInteger page;
@end
@interface Model_arts_topic_Rsp : Model_Rsp_V2
@property (nonatomic, strong) NSArray<Model_arts_topic_Data> *body;
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark /arts/:id/like 赞
@interface Model_arts_like_Req : Model_Req
@property (nonatomic, strong) NSString *art_id;
@end
@interface Model_arts_like_Rsp : Model_Rsp_V2
@property (nonatomic, strong) Model_arts_like_Req *request;
@property (nonatomic, strong) Model_art_Detail_Data *body;
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark /arts/:id/cancel_like 取消赞
@interface Model_art_cancel_like_Req : Model_Req
@property (nonatomic, strong) NSString *art_id;
@end
@interface Model_art_cancel_like_Rsp : Model_Rsp_V2
@property (nonatomic, strong) Model_art_cancel_like_Req *request;
@property (nonatomic, strong) Model_art_Detail_Data *body;
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark /arts/:id/dislike 踩
@interface Model_art_dislike_Req : Model_Req
@property (nonatomic, strong) NSString *art_id;
@end
@interface Model_art_dislike_Rsp : Model_Rsp_V2
@property (nonatomic, strong) Model_art_dislike_Req *request;
@property (nonatomic, strong) Model_art_Detail_Data *body;
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark /arts/:id/cancel_dislike 取消踩
@interface Model_art_cancel_dislike_Req : Model_Req
@property (nonatomic, strong) NSString *art_id;
@end
@interface Model_art_cancel_dislike_Rsp : Model_Rsp_V2
@property (nonatomic, strong) Model_art_cancel_dislike_Req *request;
@property (nonatomic, strong) Model_art_Detail_Data *body;
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark /arts/:id/favorite 收藏作品
@interface Model_art_favorite_Req : Model_Req
@property (nonatomic, strong) NSString *art_id;
@end
@interface Model_art_favorite_Rsp : Model_Rsp_V2
@property (nonatomic, strong) Model_art_favorite_Req *request;
@property (nonatomic, strong) Model_art_Detail_Data *body;
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark /arts/:id/unfavorite 取消收藏作品
@interface Model_art_unfavorite_Req : Model_Req
@property (nonatomic, strong) NSString *art_id;
@end
@interface Model_art_unfavorite_Rsp : Model_Rsp_V2
@property (nonatomic, strong) Model_art_unfavorite_Req *request;
@property (nonatomic, strong) Model_art_Detail_Data *body;
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark /arts/my_signatures 个人签名的艺术作品
@interface Model_arts_my_signatures_Req : Model_Req
/** 页码 */
@property (nonatomic, assign) NSInteger page;
/** 每页多少 */
@property (nonatomic, assign) NSInteger per_page;
@end
@interface Model_arts_my_signatures_Rsp : Model_Rsp_V2
@property (nonatomic, strong) NSArray<Model_art_Detail_Data> *body;
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark /organizations 机构列表
@protocol Model_organizations_Data @end
@interface Model_organizations_Data : Model_Interface
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSDictionary *img_file;
@property (nonatomic, strong) NSString *aasm_state;
@property (nonatomic, strong) NSString *fee;
@property (nonatomic, strong) NSString *signature_count;
@end
@interface Model_organizations_Req : Model_Req
/** 页码 */
@property (nonatomic, assign) NSInteger page;
/** 每页多少 */
@property (nonatomic, assign) NSInteger per_page;
@end
@interface Model_organizations_Rsp : Model_Rsp_V2
@property (nonatomic, strong) NSArray<Model_organizations_Data> *body;
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark /arts/applying_signatures 申请机构签名艺术作品列表
@interface Model_arts_applying_signatures_Req : Model_Req
/** 页码 */
@property (nonatomic, assign) NSInteger page;
/** 每页多少 */
@property (nonatomic, assign) NSInteger per_page;
@end
@interface Model_arts_applying_signatures_Rsp : Model_Rsp_V2
@property (nonatomic, strong) NSArray<Model_art_Detail_Data> *body;
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark /arts/:id/apply_signature 申请签名（加签）艺术作品
@interface Model_arts_apply_signature_Req : Model_Req
@property (nonatomic, strong) NSString *art_id;
@property (nonatomic, strong) NSString *organization_name;
@property (nonatomic, strong) NSString *memo;
@end
@interface Model_arts_apply_signature_Rsp : Model_Rsp_V2
@property (nonatomic, strong) Model_arts_apply_signature_Req *request;
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark /arts/available_signature_arts 可以签名的艺术作品
@interface Model_arts_available_signature_arts_Req : Model_Req
/** 页码 */
@property (nonatomic, assign) NSInteger page;
/** 每页多少 */
@property (nonatomic, assign) NSInteger per_page;
/** 机构名称 */
@property (nonatomic, strong) NSString *organization_name;
@end
@interface Model_arts_available_signature_arts_Rsp : Model_Rsp_V2
@property (nonatomic, strong) NSArray<Model_art_Detail_Data> *body;
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark /messages 通知列表
@protocol Model_messages_Data @end
@interface Model_messages_Data : Model_Interface
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *body;
@property (nonatomic, assign) BOOL read;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *updated_at;
/** ArtSignature 艺术品签名， Art 艺术品审核, ArtTrade 艺术品交易, BlindBoxDrawGroup 盲盒链上操作完成 */
@property (nonatomic, strong) NSString *resource_type;
@property (nonatomic, strong) NSString *resource_id;
@property (nonatomic, strong) NSString *action_str;
@end
@interface Model_messages_Req : Model_Req
/** 页码 */
@property (nonatomic, assign) NSInteger page;
@end
@interface Model_messages_Rsp : Model_Rsp_V2
@property (nonatomic, strong) NSArray<Model_messages_Data> *body;
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark /messages/read 消息已读
@interface Model_messages_read_Req : Model_Req
@property (nonatomic, strong) NSString *id;
@end
@interface Model_messages_read_Rsp : Model_Rsp_V2
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark /messages/has_unread 用户是否有未读消息
@interface Model_messages_has_unread_Data: Model_Interface
@property (nonatomic, assign) NSInteger has_unread;
@end
@interface Model_messages_has_unread_Req : Model_Req
@end
@interface Model_messages_has_unread_Rsp : Model_Rsp_V2
@property (nonatomic, strong) Model_messages_has_unread_Data *body;
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark /messages/read_all 全部已读
@interface Model_messages_read_all_Req : Model_Req
@end
@interface Model_messages_read_all_Rsp : Model_Rsp_V2
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark /v1/arts/#{id}/orders 出售列表
@protocol Model_arts_id_orders_Data @end
@interface Model_arts_id_orders_Data : Model_Interface
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *amount;
@property (nonatomic, strong) NSString *total_amount;
@property (nonatomic, strong) NSString *sn;
@property (nonatomic, assign) BOOL is_mine;
@property (nonatomic, strong) NSString *seller_id;
@property (nonatomic, strong) NSString *royalty;
@property (nonatomic, assign) BOOL need_royalty;
@end
@interface Model_arts_id_orders_Req : Model_Req
@property (nonatomic, strong) NSString *ID;
/** 页码 */
@property (nonatomic, assign) NSInteger page;
/** 每页多少 */
@property (nonatomic, assign) NSInteger per_page;
@end
@interface Model_arts_id_orders_Rsp : Model_Rsp_V2
@property (nonatomic, strong) Model_arts_id_orders_Req *request;
@property (nonatomic, strong) NSArray<Model_arts_id_orders_Data> *body;
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark /v1/arts/:id 个人艺术品详情
@interface Model_arts_detail_Req : Model_Req
@property (nonatomic, strong) NSString *art_id;
@end
@interface Model_arts_detail_Rsp : Model_Rsp_V2
@property (nonatomic, strong) Model_arts_detail_Req *request;
@property (nonatomic, strong) Model_art_Detail_Data *body;
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark api/v2/members/user_agreement 隐私协议
@interface Model_members_user_agreement_Data : Model_Interface
@property (nonatomic, strong) NSString *user_agreement;
@end
@interface Model_members_user_agreement_Req : Model_Req
@end
@interface Model_members_user_agreement_Rsp : Model_Rsp_V2
@property (nonatomic, strong) Model_members_user_agreement_Data *body;
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark - /v2/auctions 拍卖列表
@protocol Model_auctions_Data @end
@interface Model_auctions_Data : Model_Interface
/// 拍卖id
@property (nonatomic, copy) NSString *ID;
/// 拍卖数量
@property (nonatomic, copy) NSString *amount;
/// 创建时间
@property (nonatomic, copy) NSString *created_at;
/// 开始时间
@property (nonatomic, copy) NSString *start_time;
/// 结束时间
@property (nonatomic, copy) NSString *end_time;
/// 服务器当前时间
@property (nonatomic, copy) NSString *server_timestamp;
/// 保证金
@property (nonatomic, copy) NSString *deposit_amount;
/// 已出价
@property (nonatomic, copy) NSString *current_price;
/// 支付币种
@property (nonatomic, copy) NSString *currency_code;
/// 开始价格
@property (nonatomic, copy) NSString *start_price;
/// 当前价格
@property (nonatomic, copy) NSString *current_user_highest_price;
/// 加价幅度
@property (nonatomic, copy) NSString *price_increment;
/// 赢得拍卖价格
@property (nonatomic, copy) NSString *win_price;
/// 中标者
@property (nonatomic, strong) UserDataBody *buyer;
/// 中标者 支付状态
@property (nonatomic, copy) NSString *aasm_state;
/// 是否正在支付中（等待微信回调等延迟处理）
@property (nonatomic, assign) BOOL is_paying;
/// 是否可以取消
@property (nonatomic, assign) BOOL can_cancel;
/// 保证金是否支付
@property (nonatomic, assign) BOOL deposit_paid;
/// 是否是拍卖者
@property (nonatomic, assign) BOOL is_owner;
/// 版税金额(规则：创作者发起拍卖没有版税 其他人发起拍卖计算的版税金额)
@property (nonatomic, copy) NSString *royalty;
/// 限时支付时间
@property (nonatomic, copy) NSString *pay_timeout;
/// 是否正在结算中
@property (nonatomic, assign) BOOL is_settlement;
/// 艺术品
@property (nonatomic, strong) Model_art_Detail_Data *art;
@end
@interface Model_auctions_list_Req : Model_Req
/** 页码 */
@property (nonatomic, assign) NSInteger page;
/** 每页多少 */
@property (nonatomic, assign) NSInteger per_page;
/** 主题id */
@property (nonatomic, strong) NSString *category_id;
/** 分类 */
@property (nonatomic, strong) NSString *resource_type;
/** 价格排序 */
@property (nonatomic, strong) NSString *price_sort;
/** 币种 */
@property (nonatomic, strong) NSString *code;
@end
@interface Model_auctions_list_Rsp : Model_Rsp_V2
@property (nonatomic, strong) NSArray<Model_auctions_Data> *body;
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark - /v2/auctions/{:id} 拍卖详情
@interface Model_auctions_id_Req : Model_Req
@property (nonatomic, copy) NSString *ID;
@end
@interface Model_auctions_id_Rsp : Model_Rsp_V2
@property (nonatomic, strong) Model_auctions_id_Req *request;
@property (nonatomic, strong) Model_auctions_Data *body;
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark - /v2/auctions/{:id}/bid_histories 拍卖出价列表
@protocol Model_auctions_bid_Data @end
@interface Model_auctions_bid_Data : Model_Interface
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *currency_code;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, strong) UserDataBody *member;
@end
@interface Model_auctions_id_bid_histories_Req : Model_Req
@property (nonatomic, copy) NSString *ID;
@end
@interface Model_auctions_id_bid_histories_Rsp : Model_Rsp_V2
@property (nonatomic, strong) Model_auctions_id_bid_histories_Req *request;
@property (nonatomic, copy) NSArray<Model_auctions_bid_Data> *body;
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark - /v2/auctions/{:id}/bid 出价艺术品
@interface Model_auctions_id_bid_Req : Model_Req
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *price;
@end
@interface Model_auctions_id_bid_Rsp : Model_Rsp_V2
@property (nonatomic, strong) Model_auctions_id_bid_Req *request;
@property (nonatomic, strong) NSDictionary *body;
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark - /v2/auction_deposits 缴纳保证金
@interface Model_auction_deposits_Req : Model_Req
@property (nonatomic, copy) NSString *auction_id;
@property (nonatomic, copy) NSString *pay_type;
@property (nonatomic, copy) NSString *order_from;
@end
@interface Model_auction_deposits_Rsp : Model_Rsp_V2
@property (nonatomic, strong) NSDictionary *body;
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark - /v2/auctions/notice 拍卖须知
@interface Model_auctions_notice_Req : Model_Req
@end
@interface Model_auctions_notice_Rsp : Model_Rsp_V2
@property (nonatomic, strong) NSDictionary *body;
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark - /v2/auctions/popular 精品拍卖
@interface Model_auctions_popular_Req : Model_Req
/** 页码 */
@property (nonatomic, assign) NSInteger page;
/** 每页多少 */
@property (nonatomic, assign) NSInteger per_page;
@end
@interface Model_auctions_popular_Rsp : Model_Rsp_V2
@property (nonatomic, copy) NSArray<Model_auctions_Data> *body;
@end
//////////////////////////////////////////////////////////////////////////
