//
//  ErrorRoot.h
//
//  Created by 明浩 杜 on 2018/4/27
//  Copyright (c) 2018 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ErrorHead, ErrorBody;

@interface ErrorRoot : NSObject

@property (nonatomic, strong) ErrorHead *head;
@property (nonatomic, strong) ErrorBody *body;

+ (id)modelObjectWithDictionary:(NSDictionary *)dict;

@end
