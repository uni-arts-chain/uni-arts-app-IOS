//
//  JLSegmentViewController.h
//  CloudArtChain
//
//  Created by jielian on 2021/7/14.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JLSegmentViewControllerDelegate <NSObject>

- (void)scrollOffset: (CGPoint)offset;

@end

@interface JLSegmentViewController : UIViewController

- (__nullable instancetype)initWithFrame:(CGRect)frame viewControllers:( NSArray<UIViewController *> * _Nullable)viewControllers;
- (__nullable instancetype)initWithFrame:(CGRect)frame viewControllers:( NSArray<UIViewController *> * _Nullable)viewControllers defaultIndex: (NSInteger)defaultIndex;

@property (nonatomic, weak, nullable) id<JLSegmentViewControllerDelegate> delegate;

@property (nonatomic, strong, nullable) NSArray<UIViewController *> *viewControllers;

@property (nonatomic, assign, readonly) NSUInteger index;

- (void)moveToViewControllerAtIndex:(NSUInteger)index;

@end

