//
//  Utility.m
//  Join
//
//  Created by 黄克瑾 on 16/11/28.
//  Copyright © 2016年 huangkejin. All rights reserved.
//

#import "Utility.h"

#import "DLHDActivityIndicator.h"

@implementation Utility

+ (BOOL)isValidTelephoneNum:(NSString *)strPhoneNum {
    NSString *phoneNumRegex1 = @"^((13[0-9])|(15[^4,\\D])|(17[0-9])|(18[0-9]))\\d{8}$";
    NSPredicate *phoneNum1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneNumRegex1];
    
    return [phoneNum1 evaluateWithObject:strPhoneNum];
}


+ (void)showProgressDialog:(UIView *)view {
    [DLHDActivityIndicator hideActivityIndicatorInView:view];
    DLHDActivityIndicator *indicator = [[DLHDActivityIndicator alloc] init];
    indicator.window = view;
    [indicator showWithLabelText:@"正在加载"];
}

+ (void)showProgressDialog:(UIView *)view text:(NSString *)text {
    
    [DLHDActivityIndicator hideActivityIndicatorInView:view];
    DLHDActivityIndicator *indicator = [[DLHDActivityIndicator alloc] init];
    indicator.window = view;
    [indicator showWithLabelText:text];
}

+ (void)showProgressDialogText:(NSString *)text {
    DLHDActivityIndicator *indicator = [DLHDActivityIndicator shared];
    [indicator showWithLabelText:text];
}

+ (void)hideProgressDialog:(UIView *)view {
    [DLHDActivityIndicator hideActivityIndicatorInView:view];
    
}

+ (void)hideProgressDialog {
    
    [DLHDActivityIndicator hideActivityIndicator];
}






//计算一个时间与当前时间的时间差 返回秒
+ (NSDateComponents *)difftimeDate:(NSDate *)date withUnit:(NSCalendarUnit)unit {
    if (!date) {
        date = [NSDate date];
    }
    // 获取当前日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // 需要对比的时间数据
//    NSCalendarUnit unit = unit;//NSCalendarUnitYear | NSCalendarUnitMonth
    //| NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    // 对比时间差
    NSDateComponents *dateCom = [calendar components:unit fromDate:date toDate:[NSDate date] options:0];
    
    /**
     *年差额 = dateCom.year
     *月差额 = dateCom.month
     *日差额 = dateCom.day
     *小时差额 = dateCom.hour
     *分钟差额 = dateCom.minute
     *秒差额 = dateCom.second
     */
    return dateCom;
}

+ (NSDateComponents *)date:(NSDate *)currenDate subtractDate:(NSDate *)date withUnit:(NSCalendarUnit)unit {
    // 获取当前日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // 需要对比的时间数据
//    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth
//    | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    // 对比时间差
    NSDateComponents *dateCom = [calendar components:unit fromDate:currenDate toDate:date options:0];
    
    /**
     *年差额 = dateCom.year
     *月差额 = dateCom.month
     *日差额 = dateCom.day
     *小时差额 = dateCom.hour
     *分钟差额 = dateCom.minute
     *秒差额 = dateCom.second
     */
    return dateCom;
}

//获取当前控制器
+ (UIViewController *)getCurrentViewController {

    UIViewController *resultVC;
    resultVC = [Utility _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [Utility _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

+ (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [Utility _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [Utility _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

//字典转json字符串
+ (NSString *)dictionaryToJson:(NSDictionary *)dic {
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

//json字符串转字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options:NSJSONReadingMutableContainers
                         
                                                          error:&err];
    
    if(err) {
        
        NSLog(@"json解析失败：%@",err);
        
        return nil;
    }
    
    return dic;
}

@end
