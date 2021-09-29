//
//  JLDappBrowserManagerView.h
//  CloudArtChain
//
//  Created by jielian on 2021/9/28.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, JLDappBrowserManagerViewItemType) {
    JLDappBrowserManagerViewItemTypeCollect,
    JLDappBrowserManagerViewItemTypeCopy,
    JLDappBrowserManagerViewItemTypeRefresh
};
typedef void(^JLDappBrowserManagerViewClickBlock)(JLDappBrowserManagerViewItemType itemType);

@interface JLDappBrowserManagerView : UIView

+ (void)showWithIsCollect: (BOOL)isCollect
                superView: (UIView * _Nullable)superView
               completion: (JLDappBrowserManagerViewClickBlock)completion;

@end

NS_ASSUME_NONNULL_END
