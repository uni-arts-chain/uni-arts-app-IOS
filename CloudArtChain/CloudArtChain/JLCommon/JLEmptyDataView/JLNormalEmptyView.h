//
//  JLNormalEmptyView.h
//  CloudArtChain
//
//  Created by 朱彬 on 2021/3/1.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLNormalEmptyView : UIView

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) BOOL isMainColorBg;

@property (nonatomic, assign) BOOL isOrderEmpty;

@end

NS_ASSUME_NONNULL_END
