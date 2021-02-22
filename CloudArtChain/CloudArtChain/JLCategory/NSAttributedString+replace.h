//
//  NSAttributedString+replace.h
//  Rfinex
//
//  Created by 曾进宗 on 2019/8/23.
//  Copyright © 2019 HuaXinBlockChain(Shenyang)Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSAttributedString (replace)

//将向您的邮箱12***21@qq.com发送邮件,默认%@占位符
/*
 original 原始字符
 current  把原始字符中%@替换为current,颜色为蓝色
 */
+ (NSAttributedString*)getSendEmailAtt:(NSString*)original current:(NSString*)current;
+ (NSAttributedString*)getSendEmailAtt:(NSString*)original current:(NSString*)current replace:(NSString*)replace;

//账户安全页面使用，带图片的提示文字
+ (NSAttributedString*)attributedStringWithImage:(NSString*)imageName string:(NSString*)string;

+(NSMutableAttributedString*)attributed:(NSString *)totoalStr key:(NSString *)keyStr param:(NSDictionary*)keyParam;
@end

NS_ASSUME_NONNULL_END
