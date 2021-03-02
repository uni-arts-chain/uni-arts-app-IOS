//
//  JLCategoryModel.h
//  CloudArtChain
//
//  Created by 朱彬 on 2021/3/1.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JLCategoryModel : NSObject
@end

//////////////////////////////////////////////////////////////////////////
#pragma mark /arts/selling 正在卖的作品
@interface Model_arts_selling_Req : Model_Req
/** 页码 */
@property (nonatomic, assign) NSInteger page;
/** 每页多少 */
@property (nonatomic, assign) NSInteger per_page;
/** 分类id */
@property (nonatomic, strong) NSString *category_id;
/** 主题id */
@property (nonatomic, strong) NSString *theme_id;
/** 材质id */
@property (nonatomic, strong) NSString *material_id;
/** 价格大于等于 */
@property (nonatomic, strong) NSString *price_gte;
/** 价格小于 */
@property (nonatomic, strong) NSString *price_lt;
@end
@interface Model_arts_selling_Rsp : Model_Rsp_V1
@property (nonatomic, strong) NSArray<Model_art_Detail_Data> *body;
@end
//////////////////////////////////////////////////////////////////////////
#pragma mark /arts/search 作品搜索
@interface Model_arts_search_Req : Model_Req
@property (nonatomic, strong) NSString *q;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger per_page;
@end
@interface Model_arts_search_Rsp : Model_Rsp_V1
@property (nonatomic, strong) NSArray<Model_art_Detail_Data> *body;
@end
//////////////////////////////////////////////////////////////////////////
