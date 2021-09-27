//
//  JLDappMoreContentView.h
//  CloudArtChain
//
//  Created by jielian on 2021/9/27.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol JLDappMoreContentViewDelegate <NSObject>

- (void)lookDappWithUrl: (NSString *)url;

@end

@interface JLDappMoreContentView : UIView

@property (nonatomic, weak) id<JLDappMoreContentViewDelegate> delegate;

@property (nonatomic, copy) NSArray *dataArray;

@end

NS_ASSUME_NONNULL_END
