//
//  JLHomePageHeaderView.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/26.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JLHomePageHeaderView : JLBaseView
@property (nonatomic, strong) Model_art_author_Data *authorData;
@property (nonatomic, strong) UserDataBody *userData;
@end

NS_ASSUME_NONNULL_END
