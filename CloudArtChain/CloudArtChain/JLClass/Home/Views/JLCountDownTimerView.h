//
//  JLCountDownTimerView.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/21.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JLCountDownTimerView : JLBaseView
- (instancetype)initWithSeconds:(NSInteger)seconds seperateColor:(UIColor *)seperateColor backColor:(UIColor *)backColor timeColor:(UIColor *)timeColor;
@end

NS_ASSUME_NONNULL_END
