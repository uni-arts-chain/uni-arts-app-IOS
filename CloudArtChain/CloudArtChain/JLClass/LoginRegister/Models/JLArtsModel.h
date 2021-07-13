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
#pragma mark /arts/transaction 交易
@protocol Model_arts_transaction_Data @end
@interface Model_arts_transaction_Data : Model_Interface
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *ID;
@end
@interface Model_arts_transaction_Req : Model_Req

@end
@interface Model_arts_transaction_Rsp : Model_Rsp_V2
@property (nonatomic, strong) NSArray<Model_arts_transaction_Data> *body;
@end

// ==========================================================
#pragma mark /arts/categories 主题
@protocol Model_arts_theme_Data @end
@interface Model_arts_theme_Data : Model_Interface
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *ID;
@end
@interface Model_arts_theme_Req : Model_Req

@end
@interface Model_arts_theme_Rsp : Model_Rsp_V2
@property (nonatomic, strong) NSArray<Model_arts_theme_Data> *body;
@end

// ==========================================================
#pragma mark /arts/themes 商品类型
@protocol Model_arts_themes_Data @end
@interface Model_arts_themes_Data: Model_Interface
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *ID;
@end
@interface Model_arts_themes_Req : Model_Req

@end
@interface Model_arts_themes_Rsp : Model_Rsp_V2
@property (nonatomic, strong) NSArray<Model_arts_themes_Data> *body;
@end
// ==========================================================
#pragma mark /arts/art_types 类型
@protocol Model_arts_art_types_Data @end
@interface Model_arts_art_types_Data: Model_Interface
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *ID;
@end
@interface Model_arts_art_types_Req : Model_Req

@end
@interface Model_arts_art_types_Rsp : Model_Rsp_V2
@property (nonatomic, strong) NSArray<Model_arts_art_types_Data> *body;
@end
// ==========================================================
#pragma mark /arts/prices 价格
@protocol Model_arts_prices_Data @end
@interface Model_arts_prices_Data : Model_Interface
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *ID;
@end
@interface Model_arts_prices_Req : Model_Req

@end
@interface Model_arts_prices_Rsp : Model_Rsp_V2
@property (nonatomic, strong) NSArray<Model_arts_prices_Data> *body;
@end
// ==========================================================
