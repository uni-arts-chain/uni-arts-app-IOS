//
//  NSDecimalNumber+tools.m
//  Rfinex
//
//  Created by 曾进宗 on 2018/8/28.
//  Copyright © 2018年 HuaXinBlockChain(Shenyang)Tech. All rights reserved.
//

#import "NSDecimalNumber+tools.h"

@implementation NSDecimalNumber (tools)

// 大于等于1
- (BOOL)isGreaterOrEqualOne {
    return [self isGreaterThanOrEqual:[NSDecimalNumber decimalNumberWithString:@"1"]];
}

//大于0
- (BOOL)isGreaterThanZero
{
    return [self isGreaterThan:NSDecimalNumber.zero];
}
//等于0
- (BOOL)isEqualToZero
{
    return [self isEqualTo:NSDecimalNumber.zero];
}
//小于0
- (BOOL)isLessThanZero
{
    return [self isLessThan:NSDecimalNumber.zero];
}
//大于等于0
- (BOOL)isGreaterThanOrEqualZero
{
    return [self isGreaterThanOrEqual:NSDecimalNumber.zero];
}
//小于等于0
- (BOOL)isLessThanOrEqualZero
{
    return [self isLessThanOrEqual:NSDecimalNumber.zero];
}

//大于
- (BOOL)isGreaterThan:(NSDecimalNumber*)decimalNumber
{
    NSComparisonResult result = [self compare:decimalNumber];
    if (result==NSOrderedDescending) {
        return YES;
    }
    return NO;
}
//等于
- (BOOL)isEqualTo:(NSDecimalNumber*)decimalNumber
{
    NSComparisonResult result = [self compare:decimalNumber];
    if (result==NSOrderedSame) {
        return YES;
    }
    return NO;
}

//小于
- (BOOL)isLessThan:(NSDecimalNumber*)decimalNumber
{
    NSComparisonResult result = [self compare:decimalNumber];
    if (result==NSOrderedAscending) {
        return YES;
    }
    return NO;
}

//大于等于
- (BOOL)isGreaterThanOrEqual:(NSDecimalNumber*)decimalNumber
{
    NSComparisonResult result = [self compare:decimalNumber];
    if (result==NSOrderedDescending || result==NSOrderedSame) {
        return YES;
    }
    return NO;
}
//小于等于
- (BOOL)isLessThanOrEqual:(NSDecimalNumber*)decimalNumber
{
    NSComparisonResult result = [self compare:decimalNumber];
    if (result==NSOrderedAscending || result==NSOrderedSame) {
        return YES;
    }
    return NO;
}

- (NSDecimalNumber*)roundingMode:(NSRoundingMode)model scale:(short)scale
{
    NSDecimalNumberHandler* roundingBehaviorSec = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:model scale:scale raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
    NSDecimalNumber *resultNum = [self decimalNumberByRoundingAccordingToBehavior:roundingBehaviorSec];
    return resultNum;
}

- (NSDecimalNumber*)roundDownScale:(short)scale
{
   return [self roundingMode:NSRoundDown scale:scale];
}

- (NSDecimalNumber*)roundUpScale:(short)scale
{
    return [self roundingMode:NSRoundUp scale:scale];
}

- (NSDecimalNumber*)roundPlainScale:(short)scale
{
    return [self roundingMode:NSRoundPlain scale:scale];
}


@end
