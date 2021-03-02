//
//  JLThemeRecommendView.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/25.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JLThemeRecommendView : JLBaseView
@property (nonatomic, strong) Model_arts_topic_Data *topicData;
@property (nonatomic, copy) void(^themeRecommendBlock)(Model_art_Detail_Data *artDetailData);
@end

NS_ASSUME_NONNULL_END
