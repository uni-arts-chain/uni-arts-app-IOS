//
//  JLMineModel.h
//  CloudArtChain
//
//  Created by 朱彬 on 2021/3/1.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import <Foundation/Foundation.h>

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
@interface Model_members_favorate_arts_Rsp : Model_Rsp_V1
@property (nonatomic, strong) NSArray<Model_members_favorate_arts_Data> *body;
@end
//////////////////////////////////////////////////////////////////////////
