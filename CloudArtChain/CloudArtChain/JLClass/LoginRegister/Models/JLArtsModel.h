//
//  JLArtsModel.h
//  CloudArtChain
//
//  Created by 朱彬 on 2021/2/25.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JLArtsModel : NSObject
@end

// ==========================================================
#pragma mark /arts/categories 分类
@protocol Model_arts_categories_Data @end
@interface Model_arts_categories_Data : Model_Interface
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *ID;
@end
@interface Model_arts_categories_Req : Model_Req

@end
@interface Model_arts_categories_Rsp : Model_Rsp_V2
@property (nonatomic, strong) NSArray<Model_arts_categories_Data> *body;
@end
// ==========================================================
#pragma mark /arts/themes 主题
@protocol Model_arts_themes_Data @end
@interface Model_arts_themes_Data: Model_Interface
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *ID;
@end
@interface Model_arts_themes_Req : Model_Req

@end
@interface Model_arts_themes_Rsp : Model_Rsp_V1
@property (nonatomic, strong) NSArray<Model_arts_themes_Data> *body;
@end
// ==========================================================
#pragma mark /arts/materials 材质
@protocol Model_arts_materials_Data @end
@interface Model_arts_materials_Data : Model_Interface
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *ID;
@end
@interface Model_arts_materials_Req : Model_Req

@end
@interface Model_arts_materials_Rsp : Model_Rsp_V1
@property (nonatomic, strong) NSArray<Model_arts_materials_Data> *body;
@end
// ==========================================================
#pragma mark /arts/prices 价格区间
@protocol Model_arts_prices_Data @end
@interface Model_arts_prices_Data : Model_Interface
@property (nonatomic, strong) NSString *gte;
@property (nonatomic, strong) NSString *lt;
@end
@interface Model_arts_prices_Req : Model_Req

@end
@interface Model_arts_prices_Rsp : Model_Rsp_V1
@property (nonatomic, strong) NSArray<Model_arts_prices_Data> *body;
@end
// ==========================================================
