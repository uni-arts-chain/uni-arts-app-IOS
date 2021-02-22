//
//  NSDate+LZFormat.h
//  Rfinex
//
//  Created by 曾进宗 on 2018/11/30.
//  Copyright © 2018 HuaXinBlockChain(Shenyang)Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (LZFormat)
//当前时间格式化
+ (NSString*)lz_todayyyyyMMdd;
//yyyy-MM-dd
- (NSString*)lz_yyyyMMddString;
+ (NSString*)lz_yyyyMMddDate:(NSDate*)date;
//转化时间
+ (NSDate*)lz_dateWithString:(NSString*)dateStr;

+ (NSString*)lz_getWithDoubel:(double)interval;

@end


