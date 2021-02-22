//
//  WYImageRectClipViewController.h
//  smartcampus
//
//  Created by dazhiyunxiao1 on 2019/9/18.
//  Copyright © 2019 大智云校. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class WYImageRectClipViewController;

@protocol WYImageRectClipViewControllerDelegate <NSObject>
- (void)wyrectClipViewController:(WYImageRectClipViewController *)clipViewController finishClipImage:(UIImage *)editImage;
@end

@interface WYImageRectClipViewController : UIViewController {
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
@property (nonatomic,   weak) id<WYImageRectClipViewControllerDelegate> delegate;

- (instancetype)initWithImage:(UIImage *)image;
@end

NS_ASSUME_NONNULL_END
