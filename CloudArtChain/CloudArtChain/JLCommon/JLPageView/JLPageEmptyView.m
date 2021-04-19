//
//  JLPageEmptyView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2021/4/16.
//  Copyright © 2021 朱彬. All rights reserved.
//

#import "JLPageEmptyView.h"

@interface JLPageEmptyView ()
@property (nonatomic , strong) UILabel * hintLb;
@property (nonatomic , strong) UIImageView * imageView;
@end

@implementation JLPageEmptyView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initEmptyView];
    }
    return self;
}
- (void)initEmptyView
{
    self.imageView = [[UIImageView alloc]init];
    [self.imageView sizeToFit];
    [self.imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:self.imageView];
    
    self.hintLb = [[UILabel alloc]init];
    self.hintLb.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    self.hintLb.textColor = [UIColor colorWithRed:204/255.0f green:204/255.0f blue:204/255.0f alpha:1];
    [self.hintLb setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.hintLb.textAlignment = NSTextAlignmentCenter;
    self.hintLb.numberOfLines = 0;
    [self addSubview:self.hintLb];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:0.6 constant:0]];
    
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.hintLb attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.hintLb attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:60]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.hintLb attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1 constant:-20]];

}
- (void)setImageSize:(CGSize)imageSize
{
    _imageSize = imageSize;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0 constant:imageSize.width]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0 constant:imageSize.height]];
}
- (void)setImageName:(NSString *)imageName
{
    self.imageView.image = [UIImage imageNamed:imageName];
}
- (void)setHintText:(NSString *)hintText
{
    self.hintLb.text = hintText;
}
- (void)setHintTextFont:(UIFont *)hintTextFont
{
    self.hintLb.font = hintTextFont;
}
- (void)setHintTextColor:(UIColor *)hintTextColor
{
    self.hintLb.textColor = hintTextColor;
}
- (void)setHintAttributedText:(NSAttributedString *)hintAttributedText
{
    self.hintLb.attributedText = hintAttributedText;
}
@end
