//
//  JLDappBrowserManagerView.m
//  CloudArtChain
//
//  Created by jielian on 2021/9/28.
//  Copyright © 2021 捷链科技. All rights reserved.
//

#import "JLDappBrowserManagerView.h"

static JLDappBrowserManagerView *managerView;

@interface JLDappBrowserManagerView ()

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *closeBtn;

@property (nonatomic, assign) BOOL isCollect;
@property (nonatomic, copy) JLDappBrowserManagerViewClickBlock clickBlock;

@property (nonatomic, copy) NSArray *titleArray;
@property (nonatomic, copy) NSArray *imageNamedArray;

@end

@implementation JLDappBrowserManagerView

- (instancetype)initWithFrame:(CGRect)frame isCollect: (BOOL)isCollect
{
    self = [super initWithFrame:frame];
    if (self) {
        _isCollect = isCollect;
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    _maskView = [[UIView alloc] initWithFrame:self.bounds];
    _maskView.alpha = 0;
    _maskView.backgroundColor = JL_color_black;
    _maskView.userInteractionEnabled = YES;
    [_maskView addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskViewDidTap:)]];
    [self addSubview:_maskView];
    
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 182 + KTouch_Responder_Height)];
    _bgView.layer.cornerRadius = 5;
    _bgView.backgroundColor = JL_color_white_ffffff;
    [self addSubview:_bgView];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"页面管理";
    _titleLabel.textColor = JL_color_gray_101010;
    _titleLabel.font = kFontPingFangSCRegular(17);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_bgView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(13);
        make.centerX.equalTo(self.bgView);
    }];
    
    _closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_closeBtn setImage:[[UIImage imageNamed:@"icon_dapp_browser_face_close"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [_closeBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_closeBtn];
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self.bgView);
        make.size.mas_equalTo(CGSizeMake(60, 55));
    }];
    
    CGFloat itemW = (self.frameWidth - 30 ) / 4;
    CGFloat itemH = 90;
    for (int i = 0; i < self.titleArray.count; i++) {
        UIView *itemView = [[UIView alloc] init];
        itemView.tag = 100 + i;
        itemView.userInteractionEnabled = YES;
        [itemView addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemViewDidTap:)]];
        [_bgView addSubview:itemView];
        [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bgView).offset(56);
            make.left.equalTo(self.bgView).offset(15 + itemW * i);
            make.size.mas_equalTo(CGSizeMake(itemW, itemH));
        }];
        
        UIView *imgBgView = [[UIView alloc] init];
        imgBgView.tag = 200 + i;
        imgBgView.layer.cornerRadius = 25;
        imgBgView.layer.borderWidth = 1;
        imgBgView.layer.borderColor = JL_color_gray_DDDDDD.CGColor;
        imgBgView.clipsToBounds = YES;
        [itemView addSubview:imgBgView];
        [imgBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(itemView).offset(10);
            make.centerX.equalTo(itemView);
            make.width.height.mas_equalTo(@50);
        }];
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.tag = 300 + i;
        imgView.image = [UIImage imageNamed:self.imageNamedArray[i]];
        [imgBgView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(imgBgView);
            make.width.height.mas_equalTo(@30);
        }];
        
        UILabel *label = [[UILabel alloc] init];
        label.tag = 400 + i;
        label.text = self.titleArray[i];
        label.textColor = JL_color_gray_999999;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = kFontPingFangSCRegular(14);
        [itemView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imgBgView.mas_bottom).offset(17);
            make.centerX.equalTo(imgBgView);
        }];
        
        if (i == JLDappBrowserManagerViewItemTypeCollect && _isCollect) {
            imgView.image = [UIImage imageNamed:@"icon_dapp_browser_face_collected"];
        }
    }
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.maskView.alpha = 0.5;
        self.bgView.frame = CGRectMake(0, kScreenHeight - (182 + KTouch_Responder_Height), kScreenWidth, 182 + KTouch_Responder_Height);
    } completion:nil];
}

#pragma mark - event response
- (void)maskViewDidTap: (UITapGestureRecognizer *)ges {
    [self dismiss];
}

- (void)itemViewDidTap: (UITapGestureRecognizer *)ges {
    if (self.clickBlock) {
        if (ges.view.tag - 100 == 0) {
            [ges.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.tag >= 200 && obj.tag < 300) {
                    [obj.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if (obj.tag >= 300 && obj.tag < 400) {
                            if (!self.isCollect) {
                                ((UIImageView *)obj).image = [UIImage imageNamed:@"icon_dapp_browser_face_collected"];
                            }else {
                                ((UIImageView *)obj).image = [UIImage imageNamed:@"icon_dapp_browser_face_collect"];
                            }
                        }
                    }];
                }
            }];
        }
        self.clickBlock(ges.view.tag - 100);
    }
    [self dismiss];
}

- (void)closeBtnClick: (UIButton *)sender {
    [self dismiss];
}

#pragma mark - public methods
+ (void)showWithIsCollect: (BOOL)isCollect
                superView: (UIView * _Nullable)superView
               completion: (JLDappBrowserManagerViewClickBlock)completion {
    CGRect frame = [UIScreen mainScreen].bounds;
    if (superView) {
        frame = superView.bounds;
    }
    managerView = [[JLDappBrowserManagerView alloc] initWithFrame:frame isCollect:isCollect];
    managerView.clickBlock = completion;
    if (superView) {
        [superView addSubview:managerView];
        [superView bringSubviewToFront:managerView];
    }else {
        [[UIApplication sharedApplication].windows.lastObject addSubview:managerView];
        [[UIApplication sharedApplication].windows.lastObject bringSubviewToFront:managerView];
    }
}

#pragma mark - private methods
- (void)dismiss {
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.maskView.alpha = 0;
        self.bgView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 182 + KTouch_Responder_Height);
    } completion:^(BOOL finished) {
        [self.maskView removeFromSuperview];
        [self.bgView removeFromSuperview];
        [managerView removeFromSuperview];
        managerView = nil;
    }];
}

#pragma mark - setters and getters
- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[@"收藏",@"复制链接",@"刷新"];
    }
    return _titleArray;
}

- (NSArray *)imageNamedArray {
    if (!_imageNamedArray) {
        _imageNamedArray = @[@"icon_dapp_browser_face_collect",
                             @"icon_dapp_browser_face_copy",
                             @"icon_dapp_browser_face_refresh"];
    }
    return _imageNamedArray;
}

@end
