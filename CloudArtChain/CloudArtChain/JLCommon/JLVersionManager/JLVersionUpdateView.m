//
//  JLVersionUpdateView.m
//  Miner_Fil
//
//  Created by 花田半亩 on 2020/6/21.
//  Copyright © 2020 花田半亩. All rights reserved.
//

#import "JLVersionUpdateView.h"
#import "UIView+anmit.h"

#define screenW [UIScreen mainScreen].bounds.size.width
#define screenH [UIScreen mainScreen].bounds.size.height
//视图边距
#define ContentPadding    15
//图片高度
#define TopImageHeight    388.0f
//按钮高度
#define ButonHeight       36.0f

@interface JLVersionUpdateView()
@property (nonatomic, strong) UIView *bgCenView;
@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, strong) UILabel *versionText;
@property (nonatomic, strong) UILabel *versionLabel;
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) UIButton *nextTalkButton;
@property (nonatomic, strong) UIButton *updateNowButton;
@property (nonatomic, copy)   NSString *verson;
@property (nonatomic, copy)   NSArray *textArray;
//文本高度
@property (nonatomic, assign) CGFloat contentH;
//是否为强制更新
@property (nonatomic, assign) BOOL isForce;
@end

@implementation JLVersionUpdateView

- (id)init {
    self = [super init];
    if (self) {
        self.backgroundColor = JL_color_clear;
        [self createView];
    }
    return self;
}

+ (id)showUpdateView:(NSString *)version
            contents:(NSArray *)contents
               force:(BOOL)isForce {
    JLVersionUpdateView *updateView = nil;
    if (isForce) {
        updateView = [JLVersionUpdateView showForceUpdateVersion:version contents:contents];
    } else {
        updateView = [JLVersionUpdateView showUpdateVersion:version contents:contents];
    }
    updateView.isForce = isForce;
    
    [JLAlert alert].config
    .LeeMaxWidth(kScreenWidth - 55.0f * 2)
    .LeeQueue(YES)
    .LeePriority(1000)
    .LeeCustomView(updateView)
    .LeeHeaderInsets(UIEdgeInsetsZero)
    .LeeHeaderColor(JL_color_clear)
    .LeeBackGroundColor(JL_color_clear)
    .LeeShow();
    return updateView;
}

#pragma mark 普通更新
+ (id)showUpdateVersion:(NSString *)version contents:(NSArray *)contents {
    JLVersionUpdateView *updateView = [[JLVersionUpdateView alloc] init];
    updateView.verson = version;
    updateView.textArray = contents;
    [updateView showUpdateView];
    return updateView;
}

#pragma mark 强制更新
+ (id)showForceUpdateVersion:(NSString *)version contents:(NSArray *)contents {
    JLVersionUpdateView *updateView = [[JLVersionUpdateView alloc] init];
    updateView.verson = version;
    updateView.textArray = contents;
    [updateView showGeneralUpdateView];
    return updateView;
}

#pragma mark 非强制更新
- (void)showUpdateView {
    //设置中间视图 frame
    float viewH = TopImageHeight + 25.0f + 32.0f;
    self.frame = CGRectMake(0, 0, screenW - 55.0f * 2, viewH);
    
    self.updateNowButton.frame = CGRectMake(50.0f, TopImageHeight - 25.0f - ButonHeight, self.frameWidth - 50.0f * 2, ButonHeight);
    [self addSubview:self.updateNowButton];
    //添加关闭按钮
    self.nextTalkButton.frame = CGRectMake((screenW - 55.0f * 2 - 32.0f) * 0.5f, self.topImageView.frameBottom + 25.0f, 32.0f, 32.0f);
    [self addSubview:self.nextTalkButton];
}

#pragma mark 强制更新
- (void)showGeneralUpdateView {
    //设置中间视图 frame
    float viewH = TopImageHeight;
    self.frame = CGRectMake(0, 0, screenW - 55.0f * 2, viewH);
    
    self.updateNowButton.frame = CGRectMake(50.0f, TopImageHeight - 25.0f - ButonHeight, self.frameWidth - 50.0f * 2, ButonHeight);
    [self addSubview:self.updateNowButton];
}

- (void)createView {
    [self addSubview:self.topImageView];
    
    [self addSubview:self.versionText];

    [self addSubview:self.contentScrollView];
}

- (void)setVerson:(NSString *)verson{
    _verson = verson;
    if (_verson) {
        if ([verson.lowercaseString containsString:@"v"]) {
            self.versionText.text = [NSString stringWithFormat:@"发现新版本%@", verson.uppercaseString];
        } else {
            self.versionText.text = [NSString stringWithFormat:@"发现新版本V%@", verson];
        }
    }
}

- (void)setTextArray:(NSArray *)textArray {
    if (textArray.count > 0) {
        CGFloat currentY = 0;
        for (NSString *content in textArray) {
            UIView *dotView = [[UIView alloc] initWithFrame:CGRectMake(0, currentY + 8.0f, 3.0f, 3.0f)];
            dotView.backgroundColor = JL_color_gray_333333;
            ViewBorderRadius(dotView, 1.5f, 0, JL_color_clear);
            [self.contentScrollView addSubview:dotView];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(dotView.frameRight + 7.0f, currentY, kScreenWidth - 55.0f * 2 - 25.0f * 2 - 10.0f, [self sizeofString:content].height)];
            label.numberOfLines = 0;
            label.font = kFontPingFangSCRegular(14.0f);
            label.textColor = JL_color_gray_333333;
            label.text = content;
            [self.contentScrollView addSubview:label];
            currentY += label.frameHeight + 20.0f;
        }
        currentY -= 20.0f;
        self.contentScrollView.contentSize = CGSizeMake(kScreenWidth - 55.0f * 2 - 25.0f * 2, currentY);
    }
}

- (UIImageView*)topImageView {
    if (!_topImageView) {
        _topImageView = [[UIImageView alloc] init];
        _topImageView.image = [UIImage imageNamed:@"app_version_update_bg"];
        _topImageView.contentMode = UIViewContentModeScaleToFill;
        _topImageView.frame = CGRectMake(0, 0, screenW - 55.0f * 2, TopImageHeight);
    }
    return _topImageView;
}

#pragma mark 发现新版本
- (UILabel*)versionText {
    if (!_versionText) {
        _versionText = [[UILabel alloc] init];
        _versionText.textColor = JL_color_gray_333333;
        _versionText.textAlignment = NSTextAlignmentCenter;
        _versionText.font = kFontPingFangSCSCSemibold(19.0f);
        _versionText.text = @"发现新版本";
        _versionText.frame = CGRectMake(0, 187.0f, screenW - 55.0f * 2, 19.0f);
        _versionText.adjustsFontSizeToFitWidth = YES;
    }
    return _versionText;
}

//更新内容
- (UIScrollView *)contentScrollView {
    if (!_contentScrollView) {
        _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(25.0f, self.versionText.frameBottom + 20.0f, kScreenWidth - 55.0f * 2 - 25.0f * 2, 90.0f)];
        _contentScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _contentScrollView;
}

//立即更新
- (UIButton*)updateNowButton {
    if (!_updateNowButton) {
        _updateNowButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_updateNowButton setTitle:@"立即更新" forState:UIControlStateNormal];
        _updateNowButton.titleLabel.font = kFontPingFangSCSCSemibold(17.0f);
        _updateNowButton.backgroundColor = JL_color_blue_6077DF;
        [_updateNowButton setTitleColor:JL_color_white_ffffff forState:UIControlStateNormal];
        [_updateNowButton addTarget:self action:@selector(updateNow) forControlEvents:UIControlEventTouchUpInside];
        ViewBorderRadius(_updateNowButton, ButonHeight * 0.5f, 0, JL_color_clear);
    }
    return _updateNowButton;
}

//下次再说
- (UIButton*)nextTalkButton {
    if (!_nextTalkButton) {
        _nextTalkButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextTalkButton setImage:[UIImage imageNamed:@"app_version_update_close"] forState:UIControlStateNormal];
        [_nextTalkButton addTarget:self action:@selector(nextTalkButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextTalkButton;
}

/**
 计算字符串高度
 @param string 字符串
 */
- (CGSize)sizeofString:(NSString *)string {
    CGSize size = CGSizeMake(kScreenWidth - 55.0f * 2 - 25.0f * 2 - 10.0f, 1000);
    return [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: kFontPingFangSCRegular(14.0f)} context:nil].size;
}

- (void)nextTalkButtonAction{
    [self closeView];
}

#pragma mark 立即更新
- (void)updateNow {
    if (self.openUrl.length == 0) {
        [self closeView];
        return;
    }
    NSURL * url  = [NSURL URLWithString:self.openUrl];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

+ (NSArray *)slipContent:(NSString*)desc {
    //移除所有空格和换行
    NSString *newString = [desc stringByReplacingOccurrencesOfString:@" " withString:@""];
    newString = [newString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    //没有返回空字符
    if (newString.length == 0) {
        return [NSArray array];
    }
    
    //分割字符串通过中英文逗号
    NSCharacterSet *chaarect = [NSCharacterSet characterSetWithCharactersInString:@","];
    NSArray *subArray = [newString componentsSeparatedByCharactersInSet:chaarect];
    
    return subArray;
}

- (void)closeView {
    [LEEAlert closeWithCompletionBlock:nil];
}
@end
