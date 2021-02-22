//
//  ErrorHead.h
//
//  Created by 明浩 杜 on 2018/4/27
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ErrorHead : NSObject

@property (nonatomic, strong) NSString *msg;
@property (nonatomic, assign) double code;

+ (id)modelObjectWithDictionary:(NSDictionary *)dict;

@end
