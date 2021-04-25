//
//  JLInputView.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/9/16.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLBaseView.h"
#import "JLTimeButton.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, JLInputTrailType) {
    JLInputTrailTypeNone = 1, /** 无操作 */
    JLInputTrailTypePwd, /** 密码显示/隐藏 */
    JLInputTrailTypeVerifyCode, /** 获取验证码 */
};

@interface JLInputView : JLBaseView
@property (nonatomic, copy) NSString *inputContent;
- (instancetype)initWithHeadImage:(NSString *)headImage placeholder:(NSString *)placeholder trailType:(JLInputTrailType)trailType;
@property (nonatomic, copy) void(^sendSmsBlock)(JLTimeButton *sender);
@end

NS_ASSUME_NONNULL_END
