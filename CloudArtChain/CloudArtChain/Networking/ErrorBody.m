//
//  ErrorBody.m
//
//  Created by 明浩 杜 on 2018/4/27
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import "ErrorBody.h"

@implementation ErrorBody

+ (id)modelObjectWithDictionary:(NSDictionary *)dict {
    return [ErrorBody yy_modelWithJSON:dict];
}

@end
