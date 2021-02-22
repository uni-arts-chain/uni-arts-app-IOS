//
//  NSDate+LZFormat.m
//  Rfinex
//
//  Created by 曾进宗 on 2018/11/30.
//  Copyright © 2018 HuaXinBlockChain(Shenyang)Tech. All rights reserved.
//

#import "NSDate+LZFormat.h"

@implementation NSDate (LZFormat)

+ (NSString*)lz_todayyyyyMMdd
{
    NSString *formatter = @"yyyy-MM-dd";
    return [NSDate lz_yyyyMMdd:[NSDate date] formatter:formatter];
}

- (NSString*)lz_yyyyMMddString
{
    NSString *formatter = @"yyyy-MM-dd";
    return [NSDate lz_yyyyMMdd:self formatter:formatter];
}

+ (NSString*)lz_yyyyMMddDate:(NSDate*)date
{
    NSString *formatter = @"yyyy-MM-dd";
    return [NSDate lz_yyyyMMdd:date formatter:formatter];
}

+ (NSString*)lz_yyyyMMdd:(NSDate*)date formatter:(NSString*)formatter
{
    if (!date) {
        return nil;
    }
    if (formatter.length==0) {
        formatter = @"yyyy-MM-dd HH:mm:ss";
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    return [dateFormatter stringFromDate:date];
}

+ (NSDate*)lz_dateWithString:(NSString*)dateStr
{
    return [NSDate lz_dateWithString:dateStr formatter:@"yyyy-MM-dd"];
}

+ (NSDate*)lz_dateWithString:(NSString*)dateStr formatter:(NSString*)formatter
{
    if (dateStr.length==0) {
        return nil;
    }
    if (formatter.length==0) {
        formatter = @"yyyy-MM-dd HH:mm:ss";
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    return [dateFormatter dateFromString:dateStr];
}

+ (NSString*)lz_getWithDoubel:(double)interval
{
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString       = [formatter stringFromDate: date];
    return dateString;
}




@end
