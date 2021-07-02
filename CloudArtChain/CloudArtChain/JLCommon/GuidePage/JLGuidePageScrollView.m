//
//  JLGuidePageScrollView.m
//  CloudArtChain
//
//  Created by jielian on 2021/6/22.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLGuidePageScrollView.h"
#import "JLGuideManager.h"

static JLGuidePageScrollView *guidePageScrollView;

@interface JLGuidePageScrollView ()

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, copy) JLGuidePageScrollViewCompleteBlock completeBlock;

@property (nonatomic, copy) NSArray *imageNameArray;

@property (nonatomic, copy) NSArray *indicatorImageNameArray;

@property (nonatomic, copy) NSArray *titleArray;

@property (nonatomic, copy) NSArray *descArray;

@end

@implementation JLGuidePageScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.backgroundColor = JL_color_white_ffffff;
    _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.bounces = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.contentSize = CGSizeMake(kScreenWidth * self.imageNameArray.count, kScreenHeight);
    [self addSubview:_scrollView];
    
    CGFloat titleTop = JLHeightScale(215 - 64 + KTouch_Responder_Height) + KStatusBar_Navigation_Height;
    
    for (int i = 0; i < self.imageNameArray.count; i++) {
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(i * kScreenWidth, 0, kScreenWidth, kScreenHeight)];
        imgView.tag = 100 + i;
        imgView.image = [UIImage imageNamed:self.imageNameArray[i]];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.clipsToBounds = YES;
        [_scrollView addSubview:imgView];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.tag = 200 + i;
        titleLabel.text = self.titleArray[i];
        titleLabel.textColor = JL_color_white_ffffff;
        titleLabel.font = kFontPingFangSCSCSemibold(30);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [_scrollView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imgView).offset(titleTop);
            make.left.right.equalTo(imgView);
        }];
        
        UILabel *descLabel = [[UILabel alloc] init];
        descLabel.tag = 300 + i;
        descLabel.textColor = JL_color_white_ffffff;
        descLabel.font = kFontPingFangSCMedium(18);
        descLabel.textAlignment = NSTextAlignmentCenter;
        descLabel.numberOfLines = 0;
        NSMutableParagraphStyle *para = [[NSMutableParagraphStyle alloc] init];
        para.lineSpacing = 4;
        para.lineBreakMode = NSLineBreakByWordWrapping;
        para.alignment = NSTextAlignmentCenter;
        NSMutableAttributedString *attrs = [[NSMutableAttributedString alloc] initWithString:self.descArray[i]];
        [attrs addAttribute:NSParagraphStyleAttributeName value:para range:NSMakeRange(0, attrs.length)];
        descLabel.attributedText = attrs;
        [_scrollView addSubview:descLabel];
        [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel.mas_bottom).offset(JLHeightScale(29));
            make.left.right.equalTo(titleLabel);
        }];
        
        if (i != self.imageNameArray.count - 1) {
            UIImageView *indicatorImgView = [[UIImageView alloc] init];
            indicatorImgView.image = [UIImage imageNamed:self.indicatorImageNameArray[i]];
            indicatorImgView.tag = 400 + i;
            [_scrollView addSubview:indicatorImgView];
            [indicatorImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(imgView).offset(-(KTouch_Responder_Height + JLHeightScale(34)));
                make.centerX.equalTo(imgView);
                make.size.mas_equalTo(CGSizeMake(43, 14));
            }];
        }else {
            UIView *bottomView = [[UIView alloc] init];
            bottomView.backgroundColor = JL_color_white_ffffff;
            [_scrollView addSubview:bottomView];
            [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.bottom.right.equalTo(imgView);
                make.height.mas_equalTo(@(KTouch_Responder_Height + JLHeightScale(139)));
            }];
            
            UIButton *enterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [enterBtn setBackgroundImage:[UIImage imageNamed:self.indicatorImageNameArray[i]] forState:UIControlStateNormal];
            [enterBtn setTitle:@"进入" forState:UIControlStateNormal];
            [enterBtn setTitleColor:JL_color_white_ffffff forState:UIControlStateNormal];
            enterBtn.titleLabel.font = kFontPingFangSCMedium(17);
            enterBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 10, 0);
            [enterBtn addTarget:self action:@selector(enterBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [bottomView addSubview:enterBtn];
            [enterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(bottomView);
                make.bottom.equalTo(self).offset(-(KTouch_Responder_Height + JLHeightScale(26)));
                make.size.mas_equalTo(CGSizeMake(284, 80));
            }];
        }
    }
}

#pragma mark - event response
- (void)enterBtnClick: (UIButton *)sender {
    
    [JLGuideManager setFirstLaunch];
    
    [UIView animateWithDuration:0.5 animations:^{
        guidePageScrollView.alpha = 0;
    } completion:^(BOOL finished) {
        if (guidePageScrollView.completeBlock) {
            guidePageScrollView.completeBlock();
        }
        [guidePageScrollView removeFromSuperview];
        guidePageScrollView = nil;
    }];
}

#pragma mark - public methods
+ (void)showWithComplete: (JLGuidePageScrollViewCompleteBlock)complete {
    
    if ([JLGuideManager isFirstLaunch]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            guidePageScrollView = [[JLGuidePageScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            UIWindow *window = [guidePageScrollView getTopLevelWindow];
            [window addSubview:guidePageScrollView];
            [window bringSubviewToFront:guidePageScrollView];
            
            guidePageScrollView.completeBlock = complete;
        });
    }else {
        NSLog(@"不是第一次启动App");
    }
}

#pragma mark - setters and getters
- (NSArray *)imageNameArray {
    if (!_imageNameArray) {
        _imageNameArray = @[@"icon_guidance_1",
                            @"icon_guidance_2",
                            @"icon_guidance_3"];
    }
    return _imageNameArray;
}

- (NSArray *)indicatorImageNameArray {
    if (!_indicatorImageNameArray) {
        _indicatorImageNameArray = @[@"icon_guidance_1_indicator",
                                     @"icon_guidance_2_indicator",
                                     @"icon_guidance_3_enter"];
    }
    return _indicatorImageNameArray;
}

- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[@"海量原创NFT",
                        @"艺术品+区块链",
                        @"欢迎来到“萌易”"];
    }
    return _titleArray;
}

- (NSArray *)descArray {
    if (!_descArray) {
        _descArray = @[@"千名独具潜力的创作者\r\n万件可收藏的原创作品",
                       @"保证艺术品权属\r\n增强可收藏价值",
                       @"开启你的加密艺术之旅吧~"];
    }
    return _descArray;
}

- (void)dealloc
{
    NSLog(@"释放了: %@", self.class);
}

@end
