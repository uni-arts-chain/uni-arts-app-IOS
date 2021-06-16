//
//  JLVersionUpdateView.h
//  Miner_Fil
//
//  Created by 花田半亩 on 2020/6/21.
//  Copyright © 2020 花田半亩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JLVersionUpdateView : UIView

//立刻更新下载地址
@property (nonatomic, strong) NSDictionary *downloadUrl;
@property (nonatomic, strong) NSString *openUrl;

/**
 版本更新
 
 @param version 版本号
 @param contents 更新内容
 @param isForce 是否为强制更新
 @return 弹框实例
 */
+ (id)showUpdateView:(NSString *)version
            contents:(NSArray *)contents
               force:(BOOL)isForce;
/**
 普通更新
 
 @param version 版本号
 @param contents 更新内容
 @return 弹框实例
 */
+ (id)showUpdateVersion:(NSString *)version
               contents:(NSArray *)contents;

/**
 强制更新
 
 @param version 版本号
 @param contents 更新内容
 @return 弹框实例
 */
+ (id)showForceUpdateVersion:(NSString *)version
                    contents:(NSArray *)contents;

//分割字符
+ (NSArray *)slipContent:(NSString*)desc;

@end

