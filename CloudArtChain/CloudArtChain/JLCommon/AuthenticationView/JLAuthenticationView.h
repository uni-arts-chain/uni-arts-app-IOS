//
//  JLAuthenticationView.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, JLAuthenticationType) {
    JLAuthTypeRealName     =  1 << 0,
    JLAuthTypeAliRealName  =  1 << 1,
    JLAuthRealNameAliRealName =  JLAuthTypeRealName | JLAuthTypeAliRealName,
    RFAuthTypeAll          =  ~0UL        //全部
};

@interface JLAuthenticationInfo : NSObject
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) JLAuthenticationType authType;
@property (nonatomic, copy)   NSString *leftImageName;
@property (nonatomic, copy)   NSString *title;
@property (nonatomic, copy)   NSString *rightButtonText;
@property (nonatomic, copy)   NSString *authenText;
@property (nonatomic, assign) BOOL isComplete;
@end

@interface JLAuthenticationView : UIView
@property (nonatomic, copy, nonnull)  NSString *title;
@property (nonatomic, weak, nullable) UINavigationController *navigationController;
@property (nonatomic, assign) JLAuthenticationType authType;
@property (nonatomic, strong, readonly) NSArray *dataArray;

- (id)initWith:(NSString*)title;
- (id)initWithType:(JLAuthenticationType)authType title:(NSString*)title;

+ (void)showAuthView:(nullable NSString*)title;
+ (void)showAuthView:(NSString*)title authType:(JLAuthenticationType)authType;
+ (void)showAuthView:(NSString*)title authType:(JLAuthenticationType)authType topNav:(UINavigationController*)topNav;

- (void)gotoViewController:(JLAuthenticationInfo*)info;
+ (void)showAuthAlter:(UIView*)authView;

+ (UIViewController *)easyShowViewTopViewController;

//检测实人认证、支付宝实名认证
+ (BOOL)isRealNameAliRealName:(nullable NSString*)titile;
@end

NS_ASSUME_NONNULL_END
