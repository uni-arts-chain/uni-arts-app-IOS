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
@protocol Model_Model_blind_boxes_card_groups_Data @end
@interface Model_Model_blind_boxes_card_groups_Data : Model_Interface
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *box_id;
@property (nonatomic, strong) NSString *seller_id;
@property (nonatomic, strong) NSString *amount;
@property (nonatomic, strong) NSString *remain_amount;
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
@property (nonatomic, strong) NSString *rule;
@property (nonatomic, strong) NSString *start_time;
@property (nonatomic, strong) NSString *end_time;
@property (nonatomic, strong) NSString *special_attr;
@property (nonatomic, strong) NSArray<Model_Model_blind_boxes_card_groups_Data> *card_groups;
@end
@interface Model_blind_boxes_Req : Model_Req
@end
@interface Model_blind_boxes_Rsp : Model_Rsp_V1
@property (nonatomic, strong) NSArray<Model_blind_boxes_Data> *body;
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark /v1/blind_box_draws 盲盒开启记录
@interface Model_blind_box_draws_Req : Model_Req
@end
@interface Model_blind_box_draws_Rsp : Model_Rsp_V1
@end
//////////////////////////////////////////////////////////////////////////
