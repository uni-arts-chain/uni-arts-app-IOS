//
//  NSAttributedString+replace.m
//  Rfinex
//
//  Created by 曾进宗 on 2019/8/23.
//  Copyright © 2019 HuaXinBlockChain(Shenyang)Tech. All rights reserved.
//

#import "NSAttributedString+replace.h"

@implementation NSAttributedString (replace)

//将向您的邮箱12***12@qq.com发送验证码
+ (NSAttributedString*)getSendEmailAtt:(NSString*)original current:(NSString*)current replace:(NSString*)replace {
    NSMutableAttributedString *hit = nil;
    if (original) {
        NSDictionary *dic = @{NSForegroundColorAttributeName:JL_color_gray,NSFontAttributeName:kFontPingFangSCRegular(12)};
        hit = [[NSMutableAttributedString alloc]initWithString:original attributes:dic];
    }
    if (![original containsString:replace]) {
        return hit;
    }
    if (replace && current) {
        NSRange range = [original rangeOfString:replace];
        NSDictionary *curDic = @{NSForegroundColorAttributeName:JL_color_gray_101010,NSFontAttributeName:[UIFont systemFontOfSize:12]};
        NSMutableAttributedString *curAtt = [[NSMutableAttributedString alloc]initWithString:current attributes:curDic];
        [hit replaceCharactersInRange:range withAttributedString:curAtt];
    }else if(current) {
        NSDictionary *curDic = @{NSForegroundColorAttributeName:JL_color_gray_101010,NSFontAttributeName:[UIFont systemFontOfSize:12]};
        NSMutableAttributedString *curAtt = [[NSMutableAttributedString alloc]initWithString:current attributes:curDic];
        [hit appendAttributedString:curAtt];
    }
    return hit;
}

+ (NSAttributedString*)getSendEmailAtt:(NSString*)original current:(NSString*)current {
   return [NSAttributedString getSendEmailAtt:original current:current replace:@"%@"];
}


+ (NSAttributedString*)attributedStringWithImage:(NSString*)imageName string:(NSString*)string {
    
    NSMutableAttributedString *textAttrStr = [[NSMutableAttributedString alloc] init];
    //第一张图
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    attach.image = [UIImage imageNamed:imageName];
    attach.bounds = CGRectMake(0, -2 , 13, 13);
    NSAttributedString *imgStr = [NSAttributedString attributedStringWithAttachment:attach];
    [textAttrStr appendAttributedString:imgStr];

    NSDictionary *dic = @{NSForegroundColorAttributeName:JL_color_orange,NSFontAttributeName:kFontPingFangSCRegular(12)};
    NSAttributedString *attr = [[NSAttributedString alloc] initWithString:string attributes:dic];
    [textAttrStr appendAttributedString:attr];
    
    return textAttrStr;
}

+(NSMutableAttributedString*)attributed:(NSString *)totoalStr key:(NSString *)keyStr param:(NSDictionary*)keyParam {
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:totoalStr];
    [attributedStr addAttributes:keyParam range:NSMakeRange(totoalStr.length-keyStr.length,keyStr.length)];
    return attributedStr;
}

@end
