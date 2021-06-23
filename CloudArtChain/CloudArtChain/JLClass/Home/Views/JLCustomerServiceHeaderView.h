//
//  JLCustomerServiceHeaderView.h
//  CloudArtChain
//
//  Created by jielian on 2021/6/22.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLCustomerServiceHeaderView : UIView

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *imageName;

@property (nonatomic, assign) NSInteger section;

@property (nonatomic, assign) UIRectCorner rectCorner;

@end

NS_ASSUME_NONNULL_END
