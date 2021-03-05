//
//  JLImageRectClipViewController.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/17.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JLImageRectClipViewController;

@protocol JLImageRectClipViewControllerDelegate <NSObject>
- (void)jlrectClipViewController:(JLImageRectClipViewController *)clipViewController finishClipImage:(UIImage *)editImage;
@end

@interface JLImageRectClipViewController : UIViewController {
    UIImageView *_imageView;
    UIImage *_image;
    UIView *_overView;
    UIView *_imageViewScale;
    CGFloat lastScale;
}
/** 图片缩放的最大倍数 */
@property (nonatomic, assign) CGFloat scaleRation;
/** 裁剪框的宽度 */
@property (nonatomic, assign) CGFloat width;
/** 剪裁框的高度 */
@property (nonatomic, assign) CGFloat height;
/** 裁剪框的frame */
@property (nonatomic, assign) CGRect circularFrame;
@property (nonatomic, assign) CGRect OriginalFrame;
@property (nonatomic, assign) CGRect currentFrame;
@property (nonatomic,   weak) id<JLImageRectClipViewControllerDelegate> delegate;

- (instancetype)initWithImage:(UIImage *)image;
@end

NS_ASSUME_NONNULL_END
