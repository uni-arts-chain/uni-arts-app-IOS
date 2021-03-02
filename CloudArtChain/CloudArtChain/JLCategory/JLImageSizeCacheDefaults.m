//
//  JLImageSizeCacheDefaults.m
//  smartcampus
//
//  Created by dazhiyunxiao1 on 2019/11/27.
//  Copyright © 2019 大智云校. All rights reserved.
//

#import "JLImageSizeCacheDefaults.h"

@implementation JLImageSizeCacheDefaults
+ (JLImageSizeCacheDefaults *)standardUserDefaults {
    static dispatch_once_t onceToken;
    static JLImageSizeCacheDefaults *userDefault = nil;
    dispatch_once(&onceToken, ^{
        userDefault = [[JLImageSizeCacheDefaults alloc] initWithSuiteName:@"JLImageSizeCacheDefaults"];
    });
    return userDefault;
}
@end
