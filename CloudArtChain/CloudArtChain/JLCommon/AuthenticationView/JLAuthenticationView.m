//
//  JLAuthenticationView.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLAuthenticationView.h"
#import "UIButton+TouchArea.h"
#import "JLSettingViewController.h"

@implementation JLAuthenticationInfo
+ (NSArray*)getAuthModelArray {
    UserDataBody *user = [AppSingleton sharedAppSingleton].userBody;
    NSArray *leftImages = @[@"icon_auth_realname",
                            @"icon_auth_alirealname"];
    
    NSArray *titles     = @[@"实人认证",
                            @"支付宝实名认证"];
    
    NSArray *rightText  = @[@"去认证",
                            @"去认证"];
    
    NSArray *autheds    = @[@"已认证",
                            @"已认证"];
    
    NSArray *types      = @[@(JLAuthTypeRealName),
                            @(JLAuthTypeAliRealName)];
    
    NSArray *completes  = @[@(user.id_document_validated),
                            @(user.app_validated)];
    
    NSMutableArray *models = [[NSMutableArray alloc]init];
    for (int i = 0; i < leftImages.count; i++) {
        JLAuthenticationInfo *auth = [[JLAuthenticationInfo alloc]init];
        auth.index           = i;
        auth.authType        = [types[i] integerValue];
        auth.leftImageName   = leftImages[i];
        auth.title           = titles[i];
        auth.rightButtonText = rightText[i];
        auth.authenText      = autheds[i];
        auth.isComplete      = [completes[i] boolValue];
        [models addObject:auth];
    }
    return models;
}
@end

@interface JLAuthenticationView()
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) UILabel *titieLabel;
@end

@implementation JLAuthenticationView

- (id)initWith:(NSString*)title {
    return [self initWithType:RFAuthTypeAll title:title];
}

- (id)initWithType:(JLAuthenticationType)authType title:(NSString*)title {
    self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth - 30.0f * 2, 0)];
    if (self) {
        self.backgroundColor = JL_color_white_ffffff;
        self.authType = authType;
        self.title = title? : @"为了您的账户安全，请完成以下认证";
        [self initDataArray];
        [self createView];
    }
    return self;
}

- (void)createView {
    [self addSubview:self.titieLabel];
    
    //已验证中英文宽度
    CGFloat comViewWith = 75.0f;
    
    CGFloat titleHeight = [self getTitleSize];
    CGFloat topY = titleHeight + 30.0f * 2;
    CGFloat rowH = 30.0f;
    CGFloat rowSep = 27.0f;
    
    self.titieLabel.frame = CGRectMake(22.0f, 30.0f, self.frameWidth - 22.0f * 2, titleHeight);
    
    for (int i = 0; i < self.dataArray.count; i++) {
        JLAuthenticationInfo *info = self.dataArray[i];
        UIImage *image = [UIImage imageNamed:info.leftImageName];
        CGFloat imageWidthHeight = 18.0f;
        CGFloat imageY = topY + (rowH + rowSep) * i + (rowH - imageWidthHeight) * 0.5f;
        CGFloat imageX = 32.0f;
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(imageX, imageY, imageWidthHeight, imageWidthHeight);
        imageView.image = image;
        [self addSubview:imageView];
        
        UILabel *titleLab = [[UILabel alloc] init];
        titleLab.frame = CGRectMake(imageView.frameRight + 7.0f, imageView.frameY - (rowH - imageWidthHeight) * 0.5f, kScreenWidth - 170, rowH);
        titleLab.text = info.title;
        titleLab.textColor = JL_color_black_1E1D1E;
        titleLab.font = kFontPingFangSCRegular(16.0f);
        titleLab.adjustsFontSizeToFitWidth = YES;
        [self addSubview:titleLab];
        
        if (info.isComplete) {
            CGSize size = [titleLab sizeThatFits:CGSizeMake((kScreenWidth - 170)/2, rowH)];
            titleLab.frame = CGRectMake(imageView.frameRight + 7.0f, imageView.frameY - (rowH - imageWidthHeight) * 0.5f, size.width, rowH);
            
            UILabel *comLabel = [[UILabel alloc] init];
            comLabel.frame = CGRectMake(self.frameWidth - 29.0f - comViewWith, topY + (rowH + rowSep) * i, comViewWith, rowH);
            comLabel.text = info.authenText;
            comLabel.textAlignment = NSTextAlignmentCenter;
            comLabel.textColor = JL_color_white_ffffff;
            comLabel.font = kFontPingFangSCRegular(15.0f);
            comLabel.backgroundColor = JL_color_gray_B3B3B3;
            ViewBorderRadius(comLabel, rowH * 0.5f, 0, JL_color_clear);
            [self addSubview:comLabel];
        } else {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(self.frameWidth - 29.0f - comViewWith, topY + (rowH + rowSep) * i, comViewWith, rowH)];
            button.tag = i;
            [button setTitle:info.rightButtonText forState:UIControlStateNormal];
            button.titleLabel.font = kFontPingFangSCRegular(15.0f);
            button.titleLabel.adjustsFontSizeToFitWidth = YES;
            [button setTitleColor:JL_color_white_ffffff forState:UIControlStateNormal];
            button.backgroundColor = JL_color_blue_50C3FF;
            ViewBorderRadius(button, rowH * 0.5f, 0, JL_color_clear);
            [button edgeTouchAreaWithTop:8 right:8 bottom:8 left:8];
            [button addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
        }
    }
    CGFloat viewHeight = topY + self.dataArray.count * rowH + (self.dataArray.count - 1) * rowSep + 30.0f;
    self.frame = CGRectMake(30.0f, 0, kScreenWidth - 30.0f * 2, viewHeight);
}

- (CGFloat)getTitleSize{
    NSString *text = self.titieLabel.text;
    CGSize size = CGSizeMake(self.frameWidth - 22.0f * 2, MAXFLOAT);
    NSDictionary *dic = @{NSFontAttributeName:self.titieLabel.font};
    return [text boundingRectWithSize:size
                              options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                           attributes:dic
                              context:nil].size.height;
}

- (UILabel*)titieLabel {
    if (!_titieLabel) {
        _titieLabel = [[UILabel alloc] init];
        _titieLabel.frame = CGRectMake(22.0f, 30.0f, kScreenWidth - 22.0f, 15.0f);
        _titieLabel.text = self.title;
        _titieLabel.textColor = JL_color_black_1E1D1E;
        _titieLabel.font = kFontPingFangSCMedium(15.0f);
        _titieLabel.numberOfLines = 0;
    }
    return _titieLabel;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    if (title) {
        self.titieLabel.text = title;
    }
}

- (void)initDataArray {
    NSArray *array = [JLAuthenticationInfo getAuthModelArray];
    if (self.authType == RFAuthTypeAll) {
        self.dataArray = array;
    }else {
        NSMutableArray *total = [[NSMutableArray alloc]init];
        for (JLAuthenticationInfo *info in array) {
            if (self.authType & info.authType) {
                [total addObject:info];
            }
        }
        self.dataArray = [total sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            JLAuthenticationInfo *info1 = (JLAuthenticationInfo*)obj1;
            JLAuthenticationInfo *info2 = (JLAuthenticationInfo*)obj2;
            if (info1.index <= info2.index) {
                return NSOrderedAscending;
            }else {
                return NSOrderedDescending;
            }
        }];
    }
}

- (void)rightButtonAction:(UIButton*)button {
    JLAuthenticationInfo *info = self.dataArray[button.tag];
    @weakify(self);
    [LEEAlert closeWithCompletionBlock:^{
        @strongify(self);
        [self gotoViewController:info];
    }];
}

- (void)gotoViewController:(JLAuthenticationInfo*)info {
    if (!self.navigationController) {
        UIViewController *topView = [JLAuthenticationView easyShowViewTopViewController];
        self.navigationController = topView.navigationController;
    }
    if (info.authType == JLAuthTypeRealName) {
        [self.navigationController pushViewController:[JLSettingViewController new] animated:YES];
    }else {
        [self.navigationController pushViewController:[JLSettingViewController new] animated:YES];
    }
}

+ (UIViewController *)easyShowViewTopViewController {
    UIViewController *resultVC = [self tempEasyShowViewTopVC:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self tempEasyShowViewTopVC:resultVC.presentedViewController];
    }
    return resultVC;
}

+ (UIViewController *)tempEasyShowViewTopVC:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self tempEasyShowViewTopVC:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self tempEasyShowViewTopVC:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

// 显示所有认证信息
+ (void)showAuthView:(nullable NSString*)title  {
    JLAuthenticationView *authView = [[self alloc] initWith:title];
    [JLAuthenticationView showAuthAlter:authView];
}

+ (void)showAuthView:(NSString*)title authType:(JLAuthenticationType)authType {
    JLAuthenticationView *authView = [[self alloc] initWithType:authType title:title];
    [JLAuthenticationView showAuthAlter:authView];
}

+ (void)showAuthView:(NSString*)title authType:(JLAuthenticationType)authType topNav:(UINavigationController*)topNav {
    JLAuthenticationView *authView = [[self alloc]initWithType:authType title:title];
    authView.navigationController = topNav;
    [JLAuthenticationView showAuthAlter:authView];
}

+ (void)showAuthAlter:(UIView*)authView {
    [LEEAlert alert].config
    .LeeHeaderInsets(UIEdgeInsetsMake(0, 0, 0, 0))
    .LeeAddCustomView(^(LEECustomView *custom) {
        custom.view = authView;
        custom.positionType = LEECustomViewPositionTypeCenter;
    })
    .LeeItemInsets(UIEdgeInsetsMake(0, 30, 0, 30))
    .LeeAddAction(^(LEEAction *action) {
        action.type = LEEActionTypeCancel;
        action.height = 50;
        action.borderColor = JL_color_gray_DDDDDD;
        action.backgroundHighlightColor = JL_color_white_ffffff;
        action.backgroundColor = JL_color_white_ffffff;
        action.title = @"我知道了";
        action.font = kFontPingFangSCRegular(16.0f);
        action.titleColor = JL_color_blue_38B2F1;
    })
    .LeeConfigMaxWidth(^CGFloat(LEEScreenOrientationType type) { // 这是最大宽度为屏幕宽度 (横屏和竖屏)
        return kScreenWidth - 30.0f * 2;
    })
    .LeeCornerRadius(5.0f)
    .LeeShow();
}

//检测实人认证、支付宝实名认证
+ (BOOL)isRealNameAliRealName:(nullable NSString*)title {
    UserDataBody *user = [AppSingleton sharedAppSingleton].userBody;
    if (user.app_validated && user.id_document_validated) {
        return YES;
    } else {
        [JLAuthenticationView showAuthView:title authType:JLAuthRealNameAliRealName];
        return NO;
    }
}

@end
