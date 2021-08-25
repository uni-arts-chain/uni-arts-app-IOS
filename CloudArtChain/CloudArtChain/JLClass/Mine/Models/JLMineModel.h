//
//  JLMineModel.h
//  CloudArtChain
//
//  Created by 朱彬 on 2021/3/1.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import <Foundation/Foundation.h>

//typedef NS_ENUM(NSUInteger, JLOrderPayType) {
//    JLOrderPayTypeCashAccount,
//    JLOrderPayTypeWeChat,
//    JLOrderPayTypeAlipay,
//};

@interface JLMineModel : NSObject
@end

//////////////////////////////////////////////////////////////////////////
#pragma mark /members/favorate_arts 作品收藏
@protocol Model_members_favorate_arts_Data @end
@interface Model_members_favorate_arts_Data : Model_Interface
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) Model_art_Detail_Data *favoritable;
@property (nonatomic, strong) Model_art_author_Data *favoritor;
@end
@interface Model_members_favorate_arts_Req : Model_Req
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger per_page;
@end
@interface Model_members_favorate_arts_Rsp : Model_Rsp_V2
@property (nonatomic, strong) NSArray<Model_members_favorate_arts_Data> *body;
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark /members/followings 关注列表
@interface Model_members_followings_Req : Model_Req
/** 页码 */
@property (nonatomic, assign) NSInteger page;
/** 每页多少 */
@property (nonatomic, assign) NSInteger per_page;
@end
@interface Model_members_followings_Rsp : Model_Rsp_V2
@property (nonatomic, strong) NSArray<Model_art_author_Data> *body;
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark /members/followers 粉丝列表
@interface Model_members_followers_Req : Model_Req
/** 页码 */
@property (nonatomic, assign) NSInteger page;
/** 每页多少 */
@property (nonatomic, assign) NSInteger per_page;
@end
@interface Model_members_followers_Rsp : Model_Rsp_V2
@property (nonatomic, strong) NSArray<Model_art_author_Data> *body;
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark /arts/mine 个人艺术作品
@interface Model_arts_mine_Req : Model_Req
/** 页码 */
@property (nonatomic, assign) NSInteger page;
/** 每页多少 */
@property (nonatomic, assign) NSInteger per_page;
/** 状态,多个逗号分割 prepare(上传未上链), online(已上链), bidding(已上架), auctioning(拍卖中) */
@property (nonatomic, strong) NSString *aasm_state;
@end
@interface Model_arts_mine_Rsp : Model_Rsp_V2
@property (nonatomic, strong) NSArray<Model_art_Detail_Data> *body;
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark - /auctions/mine 个人拍卖艺术作品
@interface Model_auctions_mine_Req : Model_Req
/** 页码 */
@property (nonatomic, assign) NSInteger page;
/** 每页多少 */
@property (nonatomic, assign) NSInteger per_page;
@end
@interface Model_auctions_mine_Rsp : Model_Rsp_V2
@property (nonatomic, strong) NSArray<Model_auctions_Data> *body;
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark - /v2/auctions/{:id}/cancel 取消艺术品拍卖
@interface Model_auctions_id_cancel_Req : Model_Req
@property (nonatomic, copy) NSString *ID;
@end
@interface Model_auctions_id_cancel_Rsp : Model_Rsp_V2
@property (nonatomic, strong) Model_auctions_id_cancel_Req *request;
@property (nonatomic, copy) NSDictionary *body;
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark /arts 上传艺术品
@interface Model_arts_Req : Model_Req
/** 画作标题 */
@property (nonatomic, strong) NSString *name;
/** 分类id */
@property (nonatomic, strong) NSString *category_id;
/** 题材id */
@property (nonatomic, strong) NSString *theme_id;
/** 材质id */
@property (nonatomic, strong) NSString *material_id;
/** 创作日期 */
@property (nonatomic, strong) NSString *produce_at;
/** 尺寸 长度 */
@property (nonatomic, strong) NSString *size_length;
/** 尺寸 宽度 */
@property (nonatomic, strong) NSString *size_width;
/** 价格 */
@property (nonatomic, strong) NSString *price;
/** 详情说明 */
@property (nonatomic, strong) NSString *details;
/** 主图1 */
@property (nonatomic, strong) NSString *img_main_file1;
/** 主图2 */
@property (nonatomic, strong) NSString *img_main_file2;
/** 主图3 */
@property (nonatomic, strong) NSString *img_main_file3;
/** 视频 */
@property (nonatomic, strong) NSString *video_url;
/** 细节图1 */
@property (nonatomic, strong) NSString *img_detail_file1;
/** 细节图2 */
@property (nonatomic, strong) NSString *img_detail_file2;
/** 细节图3 */
@property (nonatomic, strong) NSString *img_detail_file3;
/** 细节说明1 */
@property (nonatomic, strong) NSString *img_detail_file1_desc;
/** 细节说明2 */
@property (nonatomic, strong) NSString *img_detail_file2_desc;
/** 细节说明3 */
@property (nonatomic, strong) NSString *img_detail_file3_desc;
/** 版税比例 */
@property (nonatomic, strong) NSString *royalty;
/** 版税有效期 */
@property (nonatomic, strong) NSString *royalty_expired_at;

/**  */
@property (nonatomic, strong) NSString *is_refungible;
/** 拆分精度 */
@property (nonatomic, strong) NSString *refungible_decimal;
/** 资源类型  1: 静图 2: gif 3: live2d 4: movie */
@property (nonatomic, assign) NSInteger resource_type;

@property (nonatomic, strong) NSString *live2d_file;
@property (nonatomic, strong) NSString *live2d_ipfs_hash;
@property (nonatomic, strong) NSString *live2d_ipfs_zip_hash;
@end
@interface Model_arts_Rsp : Model_Rsp_V2
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark /v2/arts/upload_live2d_file 上传live2d zip文件
@interface Model_arts_upload_live2d_file_Data : Model_Interface
@property (nonatomic, strong) NSString *live2d_file;
@property (nonatomic, strong) NSString *live2d_ipfs_hash;
@property (nonatomic, strong) NSString *live2d_ipfs_url;
@property (nonatomic, strong) NSString *live2d_ipfs_zip_hash;
@end
@interface Model_arts_upload_live2d_file_Req : Model_Req
@property (nonatomic, strong) NSString *live2d_file;
@end
@interface Model_arts_upload_live2d_file_Rsp : Model_Rsp_V2
@property (nonatomic, strong) Model_arts_upload_live2d_file_Data *body;
@end
//////////////////////////////////////////////////////////////////////////
@protocol Model_arts_sold_Data @end
@interface Model_arts_sold_Data : Model_Interface
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *sn;
@property (nonatomic, strong) NSString *collection_id;
@property (nonatomic, strong) NSString *item_id;
@property (nonatomic, strong) NSString *amount;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *total_price;
@property (nonatomic, strong) NSString *finished_at;
@property (nonatomic, strong) NSString *pay_type;
@property (nonatomic, strong) NSString *royalty;
/// Auction: 拍卖 Bid: 寄售
@property (nonatomic, strong) NSString *trade_refer;
@property (nonatomic, strong) Model_auctions_Data *auction;
@property (nonatomic, strong) Model_art_Detail_Data *art;
@property (nonatomic, strong) Model_art_author_Data *buyer;
@property (nonatomic, strong) Model_art_author_Data *seller;
@end
#pragma mark 个人艺术作品 - 卖出 /arts/sold
@interface Model_arts_sold_Req : Model_Req
/** 页码 */
@property (nonatomic, assign) NSInteger page;
/** 每页多少 */
@property (nonatomic, assign) NSInteger per_page;
@end
@interface Model_arts_sold_Rsp : Model_Rsp_V2
@property (nonatomic, strong) NSArray<Model_arts_sold_Data> *body;
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark 个人艺术作品 - 买入 /arts/bought
@interface Model_arts_bought_Req : Model_Req
/** 页码 */
@property (nonatomic, assign) NSInteger page;
/** 每页多少 */
@property (nonatomic, assign) NSInteger per_page;
@end
@interface Model_arts_bought_Rsp : Model_Rsp_V2
@property (nonatomic, strong) NSArray<Model_arts_sold_Data> *body;
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark 请求出售转账地址 art_orders/lock_account_id
@interface Model_art_orders_lock_account_id_Req : Model_Req
@end
@interface Model_art_orders_lock_account_id_Rsp : Model_Rsp_V2
@property (nonatomic, strong) NSDictionary *body;
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark 出售作品 art_orders
@interface Model_art_orders_Req : Model_Req
@property (nonatomic, strong) NSString *art_id;
@property (nonatomic, strong) NSString *amount;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *currency;
@property (nonatomic, strong) NSString *encrpt_extrinsic_message;
@end
@interface Model_art_orders_Rsp : Model_Rsp_V2
@property (nonatomic, strong) Model_art_Detail_Data *body;
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark 提交订单 art_trades
@interface Model_art_trades_Req : Model_Req
@property (nonatomic, strong) NSString *art_order_sn;
@property (nonatomic, strong) NSString *auction_id;
@property (nonatomic, strong) NSString *amount;
/** 值: web/ios/android */
@property (nonatomic, strong) NSString *order_from;
/** (值：wepay/alipay/account) */
@property (nonatomic, strong) NSString *pay_type;
@end
@interface Model_art_trades_Rsp : Model_Rsp_V2
@property (nonatomic, strong) NSDictionary *body;
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark /v1/art_orders/cancel 作品下架
@interface Model_art_orders_cancel_Req : Model_Req
@property (nonatomic, strong) NSString *sn;
@end
@interface Model_art_orders_cancel_Rsp : Model_Rsp_V2
@property (nonatomic, strong) Model_art_Detail_Data *body;
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark /v1/feedbacks 提交反馈
@interface Model_feedbacks_Req : Model_Req
@property (nonatomic, strong) NSString *contact;
@property (nonatomic, strong) NSString *advise;
@end
@interface Model_feedbacks_Rsp : Model_Rsp_V1
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark /v1/lotteries/get_reward 领奖
@interface Model_lotteries_get_reward_Req : Model_Req
/** 领奖码 */
@property (nonatomic, strong) NSString *sn;
/** 推荐手机号 */
@property (nonatomic, strong) NSString *ref;
@end
@interface Model_lotteries_get_reward_Rsp : Model_Rsp_V2
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark - /v1/accounts 账户
@protocol Model_account_Data @end
@interface Model_account_Data : Model_Interface
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *currency_code;
@property (nonatomic, copy) NSString *balance;
@property (nonatomic, copy) NSString *locked;
@property (nonatomic, copy) NSString *awards;
@property (nonatomic, copy) NSString *total_price;
@property (nonatomic, copy) NSString *currency_awards_fee;
@property (nonatomic, copy) NSString *default_withdraw_fund_source_id;
@property (nonatomic, copy) NSString *default_withdraw_bank_source_id;
@property (nonatomic, copy) NSString *logo;
@property (nonatomic, copy) NSDictionary *withdraw_channel;
@end
@interface Model_accounts_Req : Model_Req
@end
@interface Model_accounts_Rsp : Model_Rsp_V1
@property (nonatomic, copy) NSArray<Model_account_Data> *body;
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark - 拍卖
@interface Model_auctions_Req : Model_Req
@property (nonatomic, copy) NSString *art_id;
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *price_increment;
@property (nonatomic, copy) NSString *start_time;
@property (nonatomic, copy) NSString *end_time;
@property (nonatomic, copy) NSString *encrpt_extrinsic_message;
@end
@interface Model_auctions_Rsp : Model_Rsp_V2
@property (nonatomic, strong) Model_auctions_Data *body;
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark - 请求出售转账地址 /v2/auctions/lock_account_id
@interface Model_auctions_lock_account_id_Req : Model_Req
@end
@interface Model_auctions_lock_account_id_Rsp : Model_Rsp_V2
@property (nonatomic, strong) NSDictionary *body;
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark - 现金账户明细 /v2/account_histories
@protocol Model_account_history_Data @end
@interface Model_account_history_Data : Model_Interface
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *currency_code;
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, copy) NSString *aasm_state;
@property (nonatomic, copy) NSString *message;
@end
@interface Model_account_histories_Req : Model_Req
/** 页码 */
@property (nonatomic, assign) NSInteger page;
/** 每页多少 */
@property (nonatomic, assign) NSInteger per_page;
@end
@interface Model_account_histories_Rsp : Model_Rsp_V2
@property (nonatomic, strong) NSArray<Model_account_history_Data> *body;
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark - 创建支付方式 /v2/payment_methods/update_img
@interface Model_payment_methods_Req : Model_Req
@property (nonatomic, copy) NSString *weixin_img;
@property (nonatomic, copy) NSString *alipay_img;
/// 是否是创建还是更新
@property (nonatomic, assign) BOOL isCreate;
@end
@interface Model_payment_methods_Rsp : Model_Rsp_V2
@property (nonatomic, strong) Model_payment_methods_Req *request;
@property (nonatomic, strong) NSDictionary *body;
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark - 提现 /v2/withdraws
@interface Model_withdraws_Req : Model_Req
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *pay_type;
@end
@interface Model_withdraws_Rsp : Model_Rsp_V2
@property (nonatomic, strong) NSDictionary *body;
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark - 拍卖纪录
// (已参与) /v2/auctions/attend
// (已出价) /v2/auctions/bid_auctions
// (已中标) /v2/auctions/wins
// (已结束) v2/auctions/finish
@interface Model_auctions_history_Req : Model_Req
/** 页码 */
@property (nonatomic, assign) NSInteger page;
/** 每页多少 */
@property (nonatomic, assign) NSInteger per_page;
/// 类型
@property (nonatomic, assign) JLAuctionHistoryType historyType;
@end
@interface Model_auctions_history_Rsp : Model_Rsp_V2
@property (nonatomic, strong) Model_auctions_history_Req *request;
@property (nonatomic, copy) NSArray<Model_auctions_Data> *body;
@end
//////////////////////////////////////////////////////////////////////////
