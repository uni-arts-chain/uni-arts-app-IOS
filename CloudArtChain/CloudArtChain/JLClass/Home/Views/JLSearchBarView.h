//
//  JLSearchBarView.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/25.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JLSearchBarView : JLBaseView
- (void)setSearchPlaceholder:(NSString *)text;
- (void)setSearchText:(NSString *)text;
- (void)becomeResponder;
- (void)resignResponder;
@end

@protocol JLSearchBarViewDelegate <NSObject>
- (void)textEditChange:(NSString *)text;
- (void)textEndEditChange:(NSString *)text;
- (void)didRightItemJumpPage;
@end

NS_ASSUME_NONNULL_END
