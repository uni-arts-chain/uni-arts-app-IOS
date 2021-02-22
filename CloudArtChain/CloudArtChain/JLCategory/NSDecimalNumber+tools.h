//
//  NSDecimalNumber+tools.h
//  Rfinex
//
//  Created by 曾进宗 on 2018/8/28.
//  Copyright © 2018年 HuaXinBlockChain(Shenyang)Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface NSDecimalNumber (tools)
// 大于等于1
- (BOOL)isGreaterOrEqualOne;
//大于0
- (BOOL)isGreaterThanZero;
//等于0
- (BOOL)isEqualToZero;
//小于0
- (BOOL)isLessThanZero;
//大于等于0
- (BOOL)isGreaterThanOrEqualZero;
//小于等于0
- (BOOL)isLessThanOrEqualZero;

//大于
- (BOOL)isGreaterThan:(NSDecimalNumber*)decimalNumber;
//等于
- (BOOL)isEqualTo:(NSDecimalNumber*)decimalNumber;
//小于
- (BOOL)isLessThan:(NSDecimalNumber*)decimalNumber;
//大于等于
- (BOOL)isGreaterThanOrEqual:(NSDecimalNumber*)decimalNumber;
//小于等于
- (BOOL)isLessThanOrEqual:(NSDecimalNumber*)decimalNumber;

//只舍不入，保留小数位数
- (NSDecimalNumber*)roundDownScale:(short)scale;
//只入不舍
- (NSDecimalNumber*)roundUpScale:(short)scale;
//四舍五入NSRoundPlain
- (NSDecimalNumber*)roundPlainScale:(short)scale;

@end
