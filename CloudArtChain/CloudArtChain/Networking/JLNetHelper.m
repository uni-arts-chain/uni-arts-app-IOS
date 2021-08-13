//
//  JLNetHelper.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import "JLNetHelper.h"
#import "JLViewControllerTool.h"

static AFHTTPSessionManager *sessionManager = nil;

@implementation JLNetHelper

+ (AFHTTPSessionManager*)getSessionManager {
    if (!sessionManager) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        // 设置超时时间
//        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
//        manager.requestSerializer.timeoutInterval = 30.f;
//        manager.requestSerializer.timeoutInterval = 120.f;
//        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        sessionManager = manager;
    }
    // 设置超时时间
    [sessionManager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    sessionManager.requestSerializer.timeoutInterval = 30.f;
    [sessionManager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    return sessionManager;
}

+ (AFHTTPSessionManager *)getUploadSessionManager {
    if (!sessionManager) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        sessionManager = manager;
    }
    // 设置超时时间
    [sessionManager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    sessionManager.requestSerializer.timeoutInterval = 120.0f;
    [sessionManager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    return sessionManager;
}

+ (void)netRequestPostParameters:(id)reqPar responseParameters:(id)rspPar callBack:(void(^)(BOOL netIsWork,NSString *errorStr, NSInteger errorCode))callBack {
    AFHTTPSessionManager *manager = [JLNetHelper getSessionManager];
    NSMutableDictionary * mutablePara = [NSMutableDictionary dictionaryWithDictionary:[reqPar toDictionary]];
    //获取时间戳
    NSString *timeString = [JLNetHelper getTimeString];
    //头部设置
    [JLNetHelper managerHeadBaseConfig:manager withTime:timeString];
    //设置Token
    Model_Rsp *modelRsp = (Model_Rsp *)rspPar;
    [mutablePara setObject:timeString forKey:@"tonce"];
    NSString *url = [NSString stringWithFormat:@"%@%@", [NSString stringIsEmpty:modelRsp.serverVersionSubpath] ? @"" : modelRsp.serverVersionSubpath, ![NSString stringIsEmpty:modelRsp.interfacePath] ? modelRsp.interfacePath : [[NSStringFromClass([reqPar class]) substringWithRange:NSMakeRange(6, NSStringFromClass([reqPar class]).length-10)] stringByReplacingOccurrencesOfString:@"_" withString:@"/"]];
    [JLNetHelper setToken:manager url:[NSString stringWithFormat:@"/%@", url] para:mutablePara isGET:NO timeString:timeString];
    
    
    NSString *baseUrl = [NSString stringWithFormat:@"%@%@%@",modelRsp.baseUrl, [NSString stringIsEmpty:modelRsp.serverVersionSubpath] ? @"" : modelRsp.serverVersionSubpath, [NSString stringIsEmpty:modelRsp.interfacePath] ? [[NSStringFromClass([reqPar class]) substringWithRange:NSMakeRange(6, NSStringFromClass([reqPar class]).length-10)] stringByReplacingOccurrencesOfString:@"_" withString:@"/"] : modelRsp.interfacePath];
    __block id rsp = rspPar;
    JLLog(@"当前的请求接口====: %@\n当前请求参数为====: %@", baseUrl,[reqPar toJSONString]);
    [manager POST:baseUrl parameters:[reqPar toDictionary] headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //网络获取数据成功
        NSString *jsonStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        JSONModelError *error;
        rsp = [rsp initWithString : jsonStr error : &error];
        if (error) {
            NSLog(@"jsonError : %@",error);
        }
        NSLog(@"当前的请求接口====%@,当前请求参数为===%@，当前接口的响应数据======%@",baseUrl,[reqPar toJSONString],jsonStr);
        Model_Rsp *rspBase = (Model_Rsp*)rsp;
        
        if (rspBase.head.code.integerValue == 1000) {
            if (callBack) {
                callBack(YES,rspBase.head.msg,rspBase.head.code.integerValue);
            }
            [JLNetHelper removeProtectView];
        } else {
            if (callBack) {
                callBack(NO,rspBase.head.msg,rspBase.head.code.integerValue);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        BOOL isTimeout = [JLNetHelper isTimeOut:error task:task];
        if (isTimeout) {
            [JLNetHelper requestTimeOut:task error:error showError:YES];
        }
        if (callBack) {
            ErrorRoot * rootError = [self serializationError:error];
            ErrorHead * errorHead = rootError.head;
            callBack(NO,errorHead.msg, errorHead.code);
        }
        if (!isTimeout) {
            [JLNetHelper dealErrorWith:task error:error needError:YES];
        }
    }];
}

+ (void)netRequestGetParameters:(id)reqPar respondParameters:(id)rspPar callBack:(void (^)(BOOL, NSString *, NSInteger errorCode))callBackBlock {
    AFHTTPSessionManager *manager = [JLNetHelper getSessionManager];
    NSMutableDictionary * mutablePara = [NSMutableDictionary dictionaryWithDictionary:[reqPar toDictionary]];
    //获取时间戳
    NSString *timeString = [JLNetHelper getTimeString];
    //头部设置
    [JLNetHelper managerHeadBaseConfig:manager withTime:timeString];
    //设置Token
    Model_Rsp *modelRsp = (Model_Rsp *)rspPar;
    [mutablePara setObject:timeString forKey:@"tonce"];
    NSString *url = [NSString stringWithFormat:@"%@%@", [NSString stringIsEmpty:modelRsp.serverVersionSubpath] ? @"" : modelRsp.serverVersionSubpath, ![NSString stringIsEmpty:modelRsp.interfacePath] ? modelRsp.interfacePath : [[NSStringFromClass([reqPar class]) substringWithRange:NSMakeRange(6, NSStringFromClass([reqPar class]).length-10)] stringByReplacingOccurrencesOfString:@"_" withString:@"/"]];
    [JLNetHelper setToken:manager url:[NSString stringWithFormat:@"/%@", url] para:mutablePara isGET:YES timeString:timeString];
    
    NSString *baseUrl = [NSString stringWithFormat:@"%@%@%@",modelRsp.baseUrl, [NSString stringIsEmpty:modelRsp.serverVersionSubpath] ? @"" :  modelRsp.serverVersionSubpath,  [NSString stringIsEmpty:modelRsp.interfacePath] ? [[NSStringFromClass([reqPar class]) substringWithRange:NSMakeRange(6, NSStringFromClass([reqPar class]).length-10)] stringByReplacingOccurrencesOfString:@"_" withString:@"/"] : modelRsp.interfacePath];
    __block id rsp = rspPar;
    JLLog(@"当前的请求接口====: %@\n当前请求参数为====: %@", baseUrl,[reqPar toJSONString]);
    [manager GET:baseUrl parameters:[reqPar toDictionary] headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //网络获取数据成功
        NSString *jsonStr = [[NSString alloc]initWithData:responseObject  encoding:NSUTF8StringEncoding];
        JSONModelError *error;
        rsp = [rsp initWithString:jsonStr error:&error];
        if (error) {
            NSLog(@"jsonError : %@",error);
        }
        NSLog(@"当前的请求接口====%@, 当前请求参数为===%@, 当前接口的响应数据======%@",baseUrl,  [reqPar toJSONString], jsonStr);
        Model_Rsp *rspBase = (Model_Rsp *)rsp;
        if (rspBase.head.code.integerValue == 1000) {
            if (callBackBlock) {
                callBackBlock(YES, rspBase.head.msg,rspBase.head.code.integerValue);
            }
            [JLNetHelper removeProtectView];
        } else {
            if (callBackBlock) {
                callBackBlock(NO, rspBase.head.msg, rspBase.head.code.integerValue);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        BOOL isTimeout = [JLNetHelper isTimeOut:error task:task];
        if (isTimeout) {
            [JLNetHelper requestTimeOut:task error:error showError:YES];
        }
        if (callBackBlock) {
            ErrorRoot * rootError = [self serializationError:error];
            ErrorHead * errorHead = rootError.head;
            callBackBlock(NO,errorHead.msg, errorHead.code);
        }
        if (!isTimeout) {
            [JLNetHelper dealErrorWith:task error:error needError:YES];
        }
    }];
}

+ (NSURLSessionDataTask*)netRequestDeleteParameters:(id)reqPar respondParameters:(id)rspPar callBack:(void (^)(BOOL netIsWork, NSString *errorStr, NSInteger errorCode))callBackBlock {
    AFHTTPSessionManager *manager = [JLNetHelper getSessionManager];
    NSMutableDictionary * mutablePara = [NSMutableDictionary dictionaryWithDictionary:[reqPar toDictionary]];
    //获取时间戳
    NSString *timeString = [JLNetHelper getTimeString];
    //头部设置
    [JLNetHelper managerHeadBaseConfig:manager withTime:timeString];
    //设置Token
    Model_Rsp *modelRsp = (Model_Rsp *)rspPar;
    [mutablePara setObject:timeString forKey:@"tonce"];
    NSString *url = [NSString stringWithFormat:@"%@%@", [NSString stringIsEmpty:modelRsp.serverVersionSubpath] ? @"" : modelRsp.serverVersionSubpath, ![NSString stringIsEmpty:modelRsp.interfacePath] ? modelRsp.interfacePath : [[NSStringFromClass([reqPar class]) substringWithRange:NSMakeRange(6, NSStringFromClass([reqPar class]).length-10)] stringByReplacingOccurrencesOfString:@"_" withString:@"/"]];
    [JLNetHelper setToken:manager url:[NSString stringWithFormat:@"/%@", url] para:mutablePara isGET:NO timeString:timeString];
    
    NSString *baseUrl = [NSString stringWithFormat:@"%@%@%@",modelRsp.baseUrl, [NSString stringIsEmpty:modelRsp.serverVersionSubpath] ? @"" :  modelRsp.serverVersionSubpath,  [NSString stringIsEmpty:modelRsp.interfacePath] ? [[NSStringFromClass([reqPar class]) substringWithRange:NSMakeRange(6, NSStringFromClass([reqPar class]).length-10)] stringByReplacingOccurrencesOfString:@"_" withString:@"/"] : modelRsp.interfacePath];
    __block id rsp = rspPar;
    
    return [manager DELETE:baseUrl parameters:[reqPar toDictionary] headers:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //网络获取数据成功
        NSString *jsonStr = [[NSString alloc]initWithData:responseObject  encoding:NSUTF8StringEncoding];
        JSONModelError *error;
        rsp = [rsp initWithString:jsonStr error:&error];
        if (error) {
            NSLog(@"jsonError : %@",error);
        }
        NSLog(@"当前的请求接口====%@, 当前请求参数为===%@, 当前接口的响应数据======%@",baseUrl,  [reqPar toJSONString], jsonStr);
        Model_Rsp *rspBase = (Model_Rsp *)rsp;
        if (rspBase.head.code.integerValue == 1000) {
            if (callBackBlock) {
                callBackBlock(YES, rspBase.head.msg,rspBase.head.code.integerValue);
            }
            [JLNetHelper removeProtectView];
        } else {
            if (callBackBlock) {
                callBackBlock(NO, rspBase.head.msg, rspBase.head.code.integerValue);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        BOOL isTimeout = [JLNetHelper isTimeOut:error task:task];
        if (isTimeout) {
            [JLNetHelper requestTimeOut:task error:error showError:YES];
        }
        if (callBackBlock) {
            ErrorRoot * rootError = [self serializationError:error];
            ErrorHead * errorHead = rootError.head;
            callBackBlock(NO,errorHead.msg, errorHead.code);
        }
        if (!isTimeout) {
            [JLNetHelper dealErrorWith:task error:error needError:YES];
        }
    }];
}

+ (void)netRequestUploadDataWithUrl:(NSString *)url
                               para:(NSDictionary *)para
                           fileData:(NSData *)fileData
                               name:(NSString *)name
                           callBack:(void(^)(BOOL netIsWork, NSString *errorStr, NSInteger errorCode))callBackBlock {
    AFHTTPSessionManager *manager = [JLNetHelper getUploadSessionManager];
    NSString *urlString = [NSString stringWithFormat:@"%@%@", NETINTERFACE_URL_CLOUDARTCHAIN, url];
    NSMutableDictionary * mutablePara = [NSMutableDictionary dictionaryWithDictionary:para];
    //获取时间戳
    NSString *timeString = [JLNetHelper getTimeString];
    [JLNetHelper managerHeadBaseConfig:manager withTime:timeString];
    //设置Token
    [mutablePara setObject:timeString forKey:@"tonce"];
    [JLNetHelper setToken:manager url:url para:mutablePara isGET:NO timeString:timeString];

    [manager POST:urlString parameters:para headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:fileData name:name fileName:[NSString stringWithFormat:@"%@.png",timeString] mimeType:@"image/jpeg"];

    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            NSDictionary * retDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            //如果调用者类需要处理错误信息也需要返回retDict
            if ([[[retDict objectForKey:@"head"] objectForKey:@"code"] integerValue] == 1000) {
                if (callBackBlock) {
                    callBackBlock(YES, [[retDict objectForKey:@"head"] objectForKey:@"msg"],(NSInteger)[[retDict objectForKey:@"head"] objectForKey:@"code"]);
                }
                [JLNetHelper removeProtectView];
            }else{
                if (callBackBlock) {
                    callBackBlock(NO, [[retDict objectForKey:@"head"] objectForKey:@"msg"], (NSInteger)[[retDict objectForKey:@"head"] objectForKey:@"code"]);
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (callBackBlock) {
            ErrorRoot * rootError = [self serializationError:error];
            ErrorHead * errorHead = rootError.head;
            callBackBlock(NO,errorHead.msg, errorHead.code);
        }
        [JLNetHelper dealWithHeadError:(NSHTTPURLResponse *)task.response];
        [JLNetHelper dealWithAllError:error needError:YES];
    }];
}

/// 文件上传 并完成Post 请求 身份核验
/// @param reqPar 请求参数
/// @param rspPar 请求应答
/// @param fileName 文件名称
/// @param fileData 文件数据
/// @param callBackBlock 请求回调
+ (void)netRequestPostUploadParameters:(id)reqPar respondParameters:(id)rspPar fileName:(NSString *)fileName fileData:(NSData *)fileData callBack:(void(^)(BOOL netIsWork, NSString *errorStr, NSInteger errorCode))callBackBlock {
    AFHTTPSessionManager *manager = [JLNetHelper getUploadSessionManager];
    NSMutableDictionary * mutablePara = [NSMutableDictionary dictionaryWithDictionary:[reqPar toDictionary]];
    //获取时间戳
    NSString *timeString = [JLNetHelper getTimeString];
    //头部设置
    [JLNetHelper managerHeadBaseConfig:manager withTime:timeString];
    //设置Token
    Model_Rsp *modelRsp = (Model_Rsp *)rspPar;
    [mutablePara setObject:timeString forKey:@"tonce"];
    NSString *url = [NSString stringWithFormat:@"%@%@", [NSString stringIsEmpty:modelRsp.serverVersionSubpath] ? @"" : modelRsp.serverVersionSubpath, ![NSString stringIsEmpty:modelRsp.interfacePath] ? modelRsp.interfacePath : [[NSStringFromClass([reqPar class]) substringWithRange:NSMakeRange(6, NSStringFromClass([reqPar class]).length-10)] stringByReplacingOccurrencesOfString:@"_" withString:@"/"]];
    [JLNetHelper setToken:manager url:[NSString stringWithFormat:@"/%@", url] para:mutablePara isGET:NO timeString:timeString];
    
    
    NSString *baseUrl = [NSString stringWithFormat:@"%@%@%@",modelRsp.baseUrl, [NSString stringIsEmpty:modelRsp.serverVersionSubpath] ? @"" : modelRsp.serverVersionSubpath, [NSString stringIsEmpty:modelRsp.interfacePath] ? [[NSStringFromClass([reqPar class]) substringWithRange:NSMakeRange(6, NSStringFromClass([reqPar class]).length-10)] stringByReplacingOccurrencesOfString:@"_" withString:@"/"] : modelRsp.interfacePath];
    __block id rsp = rspPar;
    
    
    [manager POST:baseUrl parameters:[reqPar toDictionary] headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:fileData name:fileName fileName:[NSString stringWithFormat:@"%@.png",timeString] mimeType:@"image/jpeg"];
//        [formData appendPartWithFileData:fileData name:fileName fileName:[NSString stringWithFormat:@"%@.png",fileName] mimeType:@"image/jpeg"];
//        [formData appendPartWithFileData:fileData name:fileName fileName:fileName mimeType:@"image/jpeg"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //网络获取数据成功
        NSString *jsonStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        JSONModelError *error;
        rsp = [rsp initWithString : jsonStr error : &error];
        if (error) {
            NSLog(@"jsonError : %@",error);
        }
        NSLog(@"当前的请求接口====%@,当前请求参数为===%@，当前接口的响应数据======%@",baseUrl,[reqPar toJSONString],jsonStr);
        Model_Rsp *rspBase = (Model_Rsp*)rsp;
        
        if (rspBase.head.code.integerValue == 1000) {
            if (callBackBlock) {
                callBackBlock(YES,rspBase.head.msg,rspBase.head.code.integerValue);
            }
            [JLNetHelper removeProtectView];
        } else {
            if (callBackBlock) {
                callBackBlock(NO,rspBase.head.msg,rspBase.head.code.integerValue);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        BOOL isTimeout = [JLNetHelper isTimeOut:error task:task];
        if (isTimeout) {
            [JLNetHelper requestTimeOut:task error:error showError:YES];
        }
        if (callBackBlock) {
            ErrorRoot * rootError = [self serializationError:error];
            ErrorHead * errorHead = rootError.head;
            callBackBlock(NO,errorHead.msg, errorHead.code);
        }
        if (!isTimeout) {
            [JLNetHelper dealErrorWith:task error:error needError:YES];
        }
    }];
}

/// 文件上传 并完成Post 请求 身份核验
/// @param reqPar 请求参数
/// @param rspPar 请求应答
/// @param fileName 文件名称
/// @param fileData 文件数据
/// @param callBackBlock 请求回调
+ (void)netRequestPostUploadParameters:(id)reqPar respondParameters:(id)rspPar paramsName:(NSString *)parasName fileName:(NSString *)fileName fileData:(NSData *)fileData callBack:(void(^)(BOOL netIsWork, NSString *errorStr, NSInteger errorCode))callBackBlock {
    AFHTTPSessionManager *manager = [JLNetHelper getUploadSessionManager];
    NSMutableDictionary * mutablePara = [NSMutableDictionary dictionaryWithDictionary:[reqPar toDictionary]];
    //获取时间戳
    NSString *timeString = [JLNetHelper getTimeString];
    //头部设置
    [JLNetHelper managerHeadBaseConfig:manager withTime:timeString];
    //设置Token
    Model_Rsp *modelRsp = (Model_Rsp *)rspPar;
    [mutablePara setObject:timeString forKey:@"tonce"];
    NSString *url = [NSString stringWithFormat:@"%@%@", [NSString stringIsEmpty:modelRsp.serverVersionSubpath] ? @"" : modelRsp.serverVersionSubpath, ![NSString stringIsEmpty:modelRsp.interfacePath] ? modelRsp.interfacePath : [[NSStringFromClass([reqPar class]) substringWithRange:NSMakeRange(6, NSStringFromClass([reqPar class]).length-10)] stringByReplacingOccurrencesOfString:@"_" withString:@"/"]];
    [JLNetHelper setToken:manager url:[NSString stringWithFormat:@"/%@", url] para:mutablePara isGET:NO timeString:timeString];
    
    
    NSString *baseUrl = [NSString stringWithFormat:@"%@%@%@",modelRsp.baseUrl, [NSString stringIsEmpty:modelRsp.serverVersionSubpath] ? @"" : modelRsp.serverVersionSubpath, [NSString stringIsEmpty:modelRsp.interfacePath] ? [[NSStringFromClass([reqPar class]) substringWithRange:NSMakeRange(6, NSStringFromClass([reqPar class]).length-10)] stringByReplacingOccurrencesOfString:@"_" withString:@"/"] : modelRsp.interfacePath];
    __block id rsp = rspPar;
    
    
    [manager POST:baseUrl parameters:[reqPar toDictionary] headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:fileData name:parasName fileName:fileName mimeType:@"image/jpeg"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //网络获取数据成功
        NSString *jsonStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        JSONModelError *error;
        rsp = [rsp initWithString : jsonStr error : &error];
        if (error) {
            NSLog(@"jsonError : %@",error);
        }
        NSLog(@"当前的请求接口====%@,当前请求参数为===%@，当前接口的响应数据======%@",baseUrl,[reqPar toJSONString],jsonStr);
        Model_Rsp *rspBase = (Model_Rsp*)rsp;
        
        if (rspBase.head.code.integerValue == 1000) {
            if (callBackBlock) {
                callBackBlock(YES,rspBase.head.msg,rspBase.head.code.integerValue);
            }
            [JLNetHelper removeProtectView];
        } else {
            if (callBackBlock) {
                callBackBlock(NO,rspBase.head.msg,rspBase.head.code.integerValue);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        BOOL isTimeout = [JLNetHelper isTimeOut:error task:task];
        if (isTimeout) {
            [JLNetHelper requestTimeOut:task error:error showError:YES];
        }
        if (callBackBlock) {
            ErrorRoot * rootError = [self serializationError:error];
            ErrorHead * errorHead = rootError.head;
            callBackBlock(NO,errorHead.msg, errorHead.code);
        }
        if (!isTimeout) {
            [JLNetHelper dealErrorWith:task error:error needError:YES];
        }
    }];
}

/// 文件上传 多个图片
/// @param reqPar 请求参数
/// @param rspPar 请求应答
/// @param fileNameArray 文件名称数组
/// @param fileDataArray 文件数据数组
/// @param callBackBlock 请求回调
+ (void)netRequestUploadImagesParameters:(id)reqPar respondParameters:(id)rspPar fileNames:(NSArray *)fileNameArray fileData:(NSArray *)fileDataArray callBack:(void(^)(BOOL netIsWork, NSString *errorStr, NSInteger errorCode))callBackBlock {
    AFHTTPSessionManager *manager = [JLNetHelper getUploadSessionManager];
    NSMutableDictionary * mutablePara = [NSMutableDictionary dictionaryWithDictionary:[reqPar toDictionary]];
    //获取时间戳
    NSString *timeString = [JLNetHelper getTimeString];
    //头部设置
    [JLNetHelper managerHeadBaseConfig:manager withTime:timeString];
    //设置Token
    Model_Rsp *modelRsp = (Model_Rsp *)rspPar;
    [mutablePara setObject:timeString forKey:@"tonce"];
    NSString *url = [NSString stringWithFormat:@"%@%@", [NSString stringIsEmpty:modelRsp.serverVersionSubpath] ? @"" : modelRsp.serverVersionSubpath, ![NSString stringIsEmpty:modelRsp.interfacePath] ? modelRsp.interfacePath : [[NSStringFromClass([reqPar class]) substringWithRange:NSMakeRange(6, NSStringFromClass([reqPar class]).length-10)] stringByReplacingOccurrencesOfString:@"_" withString:@"/"]];
    [JLNetHelper setToken:manager url:[NSString stringWithFormat:@"/%@", url] para:mutablePara isGET:NO timeString:timeString];
    
    
    NSString *baseUrl = [NSString stringWithFormat:@"%@%@%@",modelRsp.baseUrl, [NSString stringIsEmpty:modelRsp.serverVersionSubpath] ? @"" : modelRsp.serverVersionSubpath, [NSString stringIsEmpty:modelRsp.interfacePath] ? [[NSStringFromClass([reqPar class]) substringWithRange:NSMakeRange(6, NSStringFromClass([reqPar class]).length-10)] stringByReplacingOccurrencesOfString:@"_" withString:@"/"] : modelRsp.interfacePath];
    __block id rsp = rspPar;
    
    
    [manager POST:baseUrl parameters:[reqPar toDictionary] headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i = 0; i < fileNameArray.count; i++) {
            NSString *fileTimeString = [NSString stringWithFormat:@"%@%d", [JLNetHelper getTimeString], (arc4random() % 999999)];
            NSData *fileData = fileDataArray[i];
            NSString *fileName = fileNameArray[i];
            [formData appendPartWithFileData:fileData name:fileName fileName:[NSString stringWithFormat:@"%@.png",fileTimeString] mimeType:@"image/jpeg"];
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //网络获取数据成功
        NSString *jsonStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        JSONModelError *error;
        rsp = [rsp initWithString : jsonStr error : &error];
        if (error) {
            NSLog(@"jsonError : %@",error);
        }
        NSLog(@"当前的请求接口====%@,当前请求参数为===%@，当前接口的响应数据======%@",baseUrl,[reqPar toJSONString],jsonStr);
        Model_Rsp *rspBase = (Model_Rsp*)rsp;
        
        if (rspBase.head.code.integerValue == 1000) {
            if (callBackBlock) {
                callBackBlock(YES,rspBase.head.msg,rspBase.head.code.integerValue);
            }
            [JLNetHelper removeProtectView];
        } else {
            if (callBackBlock) {
                callBackBlock(NO,rspBase.head.msg,rspBase.head.code.integerValue);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        BOOL isTimeout = [JLNetHelper isTimeOut:error task:task];
        if (isTimeout) {
            [JLNetHelper requestTimeOut:task error:error showError:YES];
        }
        if (callBackBlock) {
            ErrorRoot * rootError = [self serializationError:error];
            ErrorHead * errorHead = rootError.head;
            callBackBlock(NO,errorHead.msg, errorHead.code);
        }
        if (!isTimeout) {
            [JLNetHelper dealErrorWith:task error:error needError:YES];
        }
    }];
}

/// 文件上传 多个图片
/// @param reqPar 请求参数
/// @param rspPar 请求应答
/// @param fileNameArray 文件名称数组
/// @param fileDataArray 文件数据数组
/// @param callBackBlock 请求回调
+ (void)netRequestUploadImagesParameters:(id)reqPar respondParameters:(id)rspPar paramsNames:(NSArray *)paramsArray fileNames:(NSArray *)fileNameArray fileData:(NSArray *)fileDataArray fileType:(NSArray *)fileTypeArray callBack:(void(^)(BOOL netIsWork, NSString *errorStr, NSInteger errorCode))callBackBlock {
    AFHTTPSessionManager *manager = [JLNetHelper getUploadSessionManager];
    NSMutableDictionary * mutablePara = [NSMutableDictionary dictionaryWithDictionary:[reqPar toDictionary]];
    //获取时间戳
    NSString *timeString = [JLNetHelper getTimeString];
    //头部设置
    [JLNetHelper managerHeadBaseConfig:manager withTime:timeString];
    //设置Token
    Model_Rsp *modelRsp = (Model_Rsp *)rspPar;
    [mutablePara setObject:timeString forKey:@"tonce"];
    NSString *url = [NSString stringWithFormat:@"%@%@", [NSString stringIsEmpty:modelRsp.serverVersionSubpath] ? @"" : modelRsp.serverVersionSubpath, ![NSString stringIsEmpty:modelRsp.interfacePath] ? modelRsp.interfacePath : [[NSStringFromClass([reqPar class]) substringWithRange:NSMakeRange(6, NSStringFromClass([reqPar class]).length-10)] stringByReplacingOccurrencesOfString:@"_" withString:@"/"]];
    [JLNetHelper setToken:manager url:[NSString stringWithFormat:@"/%@", url] para:mutablePara isGET:NO timeString:timeString];
    
    
    NSString *baseUrl = [NSString stringWithFormat:@"%@%@%@",modelRsp.baseUrl, [NSString stringIsEmpty:modelRsp.serverVersionSubpath] ? @"" : modelRsp.serverVersionSubpath, [NSString stringIsEmpty:modelRsp.interfacePath] ? [[NSStringFromClass([reqPar class]) substringWithRange:NSMakeRange(6, NSStringFromClass([reqPar class]).length-10)] stringByReplacingOccurrencesOfString:@"_" withString:@"/"] : modelRsp.interfacePath];
    __block id rsp = rspPar;
    
    
    [manager POST:baseUrl parameters:[reqPar toDictionary] headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i = 0; i < fileNameArray.count; i++) {
            NSData *fileData = fileDataArray[i];
            NSString *fileName = fileNameArray[i];
            NSString *paramsName = paramsArray[i];
            NSString *fileType = fileTypeArray[i];
            if ([fileType isEqualToString:@"gif"]) {
                [formData appendPartWithFileData:fileData name:paramsName fileName:fileName mimeType:@"image/gif"];
            } else {
                [formData appendPartWithFileData:fileData name:paramsName fileName:fileName mimeType:@"image/jpeg"];
            }
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //网络获取数据成功
        NSString *jsonStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        JSONModelError *error;
        rsp = [rsp initWithString : jsonStr error : &error];
        if (error) {
            NSLog(@"jsonError : %@",error);
        }
        NSLog(@"当前的请求接口====%@,当前请求参数为===%@，当前接口的响应数据======%@",baseUrl,[reqPar toJSONString],jsonStr);
        Model_Rsp *rspBase = (Model_Rsp*)rsp;
        
        if (rspBase.head.code.integerValue == 1000) {
            if (callBackBlock) {
                callBackBlock(YES,rspBase.head.msg,rspBase.head.code.integerValue);
            }
            [JLNetHelper removeProtectView];
        } else {
            if (callBackBlock) {
                callBackBlock(NO,rspBase.head.msg,rspBase.head.code.integerValue);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        BOOL isTimeout = [JLNetHelper isTimeOut:error task:task];
        if (isTimeout) {
            [JLNetHelper requestTimeOut:task error:error showError:YES];
        }
        if (callBackBlock) {
            ErrorRoot * rootError = [self serializationError:error];
            ErrorHead * errorHead = rootError.head;
            callBackBlock(NO,errorHead.msg, errorHead.code);
        }
        if (!isTimeout) {
            [JLNetHelper dealErrorWith:task error:error needError:YES];
        }
    }];
}

/// 文件上传 视频
/// @param reqPar 请求参数
/// @param rspPar 请求应答
/// @param fileNameArray 文件名称数组
/// @param fileDataArray 文件数据数组
/// @param callBackBlock 请求回调
+ (void)netRequestUploadVideoParameters:(id)reqPar respondParameters:(id)rspPar paramsNames:(NSArray *)paramsArray fileNames:(NSArray *)fileNameArray fileData:(NSArray *)fileDataArray fileType:(NSArray *)fileTypeArray callBack:(void(^)(BOOL netIsWork, NSString *errorStr, NSInteger errorCode))callBackBlock {
    AFHTTPSessionManager *manager = [JLNetHelper getUploadSessionManager];
    NSMutableDictionary * mutablePara = [NSMutableDictionary dictionaryWithDictionary:[reqPar toDictionary]];
    //获取时间戳
    NSString *timeString = [JLNetHelper getTimeString];
    //头部设置
    [JLNetHelper managerHeadBaseConfig:manager withTime:timeString];
    //设置Token
    Model_Rsp *modelRsp = (Model_Rsp *)rspPar;
    [mutablePara setObject:timeString forKey:@"tonce"];
    NSString *url = [NSString stringWithFormat:@"%@%@", [NSString stringIsEmpty:modelRsp.serverVersionSubpath] ? @"" : modelRsp.serverVersionSubpath, ![NSString stringIsEmpty:modelRsp.interfacePath] ? modelRsp.interfacePath : [[NSStringFromClass([reqPar class]) substringWithRange:NSMakeRange(6, NSStringFromClass([reqPar class]).length-10)] stringByReplacingOccurrencesOfString:@"_" withString:@"/"]];
    [JLNetHelper setToken:manager url:[NSString stringWithFormat:@"/%@", url] para:mutablePara isGET:NO timeString:timeString];
    
    
    NSString *baseUrl = [NSString stringWithFormat:@"%@%@%@",modelRsp.baseUrl, [NSString stringIsEmpty:modelRsp.serverVersionSubpath] ? @"" : modelRsp.serverVersionSubpath, [NSString stringIsEmpty:modelRsp.interfacePath] ? [[NSStringFromClass([reqPar class]) substringWithRange:NSMakeRange(6, NSStringFromClass([reqPar class]).length-10)] stringByReplacingOccurrencesOfString:@"_" withString:@"/"] : modelRsp.interfacePath];
    __block id rsp = rspPar;
    
    
    [manager POST:baseUrl parameters:[reqPar toDictionary] headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i = 0; i < fileNameArray.count; i++) {
            NSData *fileData = fileDataArray[i];
            NSString *fileName = fileNameArray[i];
            NSString *paramsName = paramsArray[i];
            NSString *fileType = fileTypeArray[i];
            if ([fileType isEqualToString:@"mp4"]) {
                [formData appendPartWithFileData:fileData name:paramsName fileName:fileName mimeType:@"video/quicktime"];
            }else if ([fileType isEqualToString:@"gif"]) {
                [formData appendPartWithFileData:fileData name:paramsName fileName:fileName mimeType:@"image/gif"];
            } else {
                [formData appendPartWithFileData:fileData name:paramsName fileName:fileName mimeType:@"image/jpeg"];
            }
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //网络获取数据成功
        NSString *jsonStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        JSONModelError *error;
        rsp = [rsp initWithString : jsonStr error : &error];
        if (error) {
            NSLog(@"jsonError : %@",error);
        }
        NSLog(@"当前的请求接口====%@,当前请求参数为===%@，当前接口的响应数据======%@",baseUrl,[reqPar toJSONString],jsonStr);
        Model_Rsp *rspBase = (Model_Rsp*)rsp;
        
        if (rspBase.head.code.integerValue == 1000) {
            if (callBackBlock) {
                callBackBlock(YES,rspBase.head.msg,rspBase.head.code.integerValue);
            }
            [JLNetHelper removeProtectView];
        } else {
            if (callBackBlock) {
                callBackBlock(NO,rspBase.head.msg,rspBase.head.code.integerValue);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        BOOL isTimeout = [JLNetHelper isTimeOut:error task:task];
        if (isTimeout) {
            [JLNetHelper requestTimeOut:task error:error showError:YES];
        }
        if (callBackBlock) {
            ErrorRoot * rootError = [self serializationError:error];
            ErrorHead * errorHead = rootError.head;
            callBackBlock(NO,errorHead.msg, errorHead.code);
        }
        if (!isTimeout) {
            [JLNetHelper dealErrorWith:task error:error needError:YES];
        }
    }];
}

/// 文件上传 zip文件上传
/// @param reqPar 请求参数
/// @param rspPar 请求应答
/// @param paramName 参数名称
/// @param fileName 文件名称
/// @param fileData 文件数据
/// @param callBackBlock 请求回调
+ (void)netRequestUploadZipFileParameters:(id)reqPar respondParameters:(id)rspPar paramName:(NSString *)paramName fileName:(NSString *)fileName fileData:(NSData *)fileData callBack:(void(^)(BOOL netIsWork, NSString *errorStr, NSInteger errorCode))callBackBlock {
    AFHTTPSessionManager *manager = [JLNetHelper getUploadSessionManager];
    NSMutableDictionary * mutablePara = [NSMutableDictionary dictionaryWithDictionary:[reqPar toDictionary]];
    //获取时间戳
    NSString *timeString = [JLNetHelper getTimeString];
    //头部设置
    [JLNetHelper managerHeadBaseConfig:manager withTime:timeString];
    //设置Token
    Model_Rsp *modelRsp = (Model_Rsp *)rspPar;
    [mutablePara setObject:timeString forKey:@"tonce"];
    NSString *url = [NSString stringWithFormat:@"%@%@", [NSString stringIsEmpty:modelRsp.serverVersionSubpath] ? @"" : modelRsp.serverVersionSubpath, ![NSString stringIsEmpty:modelRsp.interfacePath] ? modelRsp.interfacePath : [[NSStringFromClass([reqPar class]) substringWithRange:NSMakeRange(6, NSStringFromClass([reqPar class]).length-10)] stringByReplacingOccurrencesOfString:@"_" withString:@"/"]];
    [JLNetHelper setToken:manager url:[NSString stringWithFormat:@"/%@", url] para:mutablePara isGET:NO timeString:timeString];
    
    
    NSString *baseUrl = [NSString stringWithFormat:@"%@%@%@",modelRsp.baseUrl, [NSString stringIsEmpty:modelRsp.serverVersionSubpath] ? @"" : modelRsp.serverVersionSubpath, [NSString stringIsEmpty:modelRsp.interfacePath] ? [[NSStringFromClass([reqPar class]) substringWithRange:NSMakeRange(6, NSStringFromClass([reqPar class]).length-10)] stringByReplacingOccurrencesOfString:@"_" withString:@"/"] : modelRsp.interfacePath];
    __block id rsp = rspPar;
    
    
    [manager POST:baseUrl parameters:[reqPar toDictionary] headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:fileData name:paramName fileName:fileName mimeType:@"application/zip"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //网络获取数据成功
        NSString *jsonStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        JSONModelError *error;
        rsp = [rsp initWithString : jsonStr error : &error];
        if (error) {
            NSLog(@"jsonError : %@",error);
        }
        NSLog(@"当前的请求接口====%@,当前请求参数为===%@，当前接口的响应数据======%@",baseUrl,[reqPar toJSONString],jsonStr);
        Model_Rsp *rspBase = (Model_Rsp*)rsp;
        
        if (rspBase.head.code.integerValue == 1000) {
            if (callBackBlock) {
                callBackBlock(YES,rspBase.head.msg,rspBase.head.code.integerValue);
            }
            [JLNetHelper removeProtectView];
        } else {
            if (callBackBlock) {
                callBackBlock(NO,rspBase.head.msg,rspBase.head.code.integerValue);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        BOOL isTimeout = [JLNetHelper isTimeOut:error task:task];
        if (isTimeout) {
            [JLNetHelper requestTimeOut:task error:error showError:YES];
        }
        if (callBackBlock) {
            ErrorRoot * rootError = [self serializationError:error];
            ErrorHead * errorHead = rootError.head;
            callBackBlock(NO,errorHead.msg, errorHead.code);
        }
        if (!isTimeout) {
            [JLNetHelper dealErrorWith:task error:error needError:YES];
        }
    }];
}

#pragma mark ----------------设置Token----------------
+ (void)setToken:(AFHTTPSessionManager*)manager url:(NSString *)url para:(NSDictionary *)para isGET:(BOOL)isGET timeString:(NSString*)timeString {
    NSString * token = [AppSingleton getToken];
    token = [JLUtils trimSpace:token];
    if (![NSString stringIsEmpty:token]) {
        //设置token
        [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
        //设置签名
        RequestType type = isGET ? RequestTypeGet : RequestTypePost;
        NSString *resultStr = [JLNetHelper getSignatureurl:url para:para requesType:type timeString:timeString];
        [manager.requestSerializer setValue:resultStr forHTTPHeaderField:@"Sign"];
    } else {
        [manager.requestSerializer setValue:nil forHTTPHeaderField:@"Authorization"];
        [manager.requestSerializer setValue:nil forHTTPHeaderField:@"Sign"];
    }
}

#pragma mark 设置签名
+ (NSString*)getSignatureurl:(NSString *)url para:(NSDictionary *)para requesType:(RequestType)type timeString:(NSString*)timeString {
    //设置签名
    //HMAC-SHA256('GET|/api/v3/markets|abc=xxx&foo=bar&tonce=123456789', '2018-03-14 09:52:35')
    NSMutableString * mutableStr = [NSMutableString string];
    NSString *typeString = [JLNetHelper getRequestString:type];
    [mutableStr appendString:typeString];
    
    [mutableStr appendString:url];
    [mutableStr appendString:@"|"];
    
    if(para && [para allKeys].count != 0){
        NSArray *keys = [para allKeys];
        NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
            return [obj1 compare:obj2 options:NSNumericSearch];
        }];
        for (int i = 0; i < sortedArray.count; i++) {
            NSString * valueStr;
            id obj = [para objectForKey:[sortedArray objectAtIndex:i]];
            if([obj isKindOfClass:[NSString class]]) {
                valueStr = [para objectForKey:[sortedArray objectAtIndex:i]];
            } else {
                valueStr = [[para objectForKey:[sortedArray objectAtIndex:i]] stringValue];
            }
            [mutableStr appendString:[NSString stringWithFormat:@"%@=%@",[sortedArray objectAtIndex:i],valueStr]];
            if (i != sortedArray.count - 1) {
                [mutableStr appendString:@"&"];
            }
        }
    }
    NSString *expireAtStr = [AppSingleton getTokenExpireAtKey];
    NSString *resultStr = [JLUtils hmac:mutableStr withKey:expireAtStr];
    return resultStr;
}

//获取请求类型字符
+ (NSString*)getRequestString:(RequestType)type {
    if (type == RequestTypeGet) {
        return @"GET|";
    } else if (type == RequestTypeDelete) {
        return @"DELETE|";
    }
    return @"POST|";
}

#pragma mark  ----------------头部基本设置----------------
+ (void)managerHeadBaseConfig:(AFHTTPSessionManager*)manager withTime:(NSString*)nowTime {
    //设置时间戳
    [manager.requestSerializer setValue:nowTime forHTTPHeaderField:@"Tonce"];
    //设置Accept
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //设置Platform
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"Platform"];
    //设置Device
    [manager.requestSerializer setValue:[self getBuildCode] forHTTPHeaderField:@"Device"];
    //设置version
    [manager.requestSerializer setValue:[self versionCode] forHTTPHeaderField:@"VersionCode"];
    //设置语言
    NSString *language = [JLNetHelper getAcceptLanguage];
    [manager.requestSerializer setValue:language forHTTPHeaderField:@"Accept-Language"];
    //设置UUID
    [manager.requestSerializer setValue:[JLKeyChain getDeviceUuid] forHTTPHeaderField:@"uuid"];
}

+(NSString*)getBuildCode{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return app_build;
}

+(NSString*)versionCode{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleVersion"];
    return app_Version;
}

//设置语言
+ (NSString*)getAcceptLanguage {
    //设置语言
    NSArray *langArr1 = [[NSUserDefaults standardUserDefaults] valueForKey:@"AppleLanguages"];
    NSString *language1 = langArr1.firstObject;
    if ([language1 hasPrefix:@"zh"]) {
        return @"zh-CN";
    }
    return @"en";
}

//获取时间戳
+ (NSString*)getTimeString {
    //获取时间戳
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval time=[date timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    return timeString;
}

#pragma mark token过期重新登录
+ (void)reloadLogin:(NSInteger)showTabIndex {
    [AppSingleton sharedAppSingleton].userBody = nil;
    // 删除登录token信息
    [JLLoginUtil logout];
    // 重新登录
    [JLLoginUtil loginWallet];
}

+ (BOOL)isTimeOut:(NSError*)error task:(NSURLSessionDataTask*)task {
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
    if (response.statusCode == 503) {
        return NO;
    }
    ErrorRoot * rootError = [self serializationError:error];
    ErrorHead * errorHead = rootError.head;
    if (errorHead) {
        return NO;
    }
    //无网络排除
    if (error.code != kCFURLErrorNotConnectedToInternet) {
        return YES;
    }
    return NO;
}

+ (ErrorRoot*)serializationError:(NSError*)error {
    NSDictionary * infoDict = error.userInfo;
    NSData * errorData = [infoDict objectForKey:@"com.alamofire.serialization.response.error.data"];
    ErrorRoot * rootError = nil;
    if (errorData) {
        NSDictionary * errorDict = [NSJSONSerialization JSONObjectWithData:errorData options:NSJSONReadingMutableLeaves error:nil];
        rootError = [ErrorRoot modelObjectWithDictionary:errorDict];
    }
    return rootError;
}

#pragma mark -处理请求超时，切换访问域名
+ (void)requestTimeOut:(NSURLSessionDataTask *)task error:(NSError*)error showError:(BOOL)showError {
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
    if (response.statusCode==503) {
        return;
    }
    [JLNetHelper showTimeOutToast:error];
}

#pragma mark 显示超时信息
+ (void)showTimeOutToast:(NSError*)error {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (error.code == kCFURLErrorNotConnectedToInternet) {
            [[JLLoading sharedLoading] showMBFailedTipMessage:@"网络加载失败，请检查！" hideTime:KToastDismissDelayTimeInterval];
        } else {
            [[JLLoading sharedLoading] showMBFailedTipMessage:@"请求超时，请稍后重试。" hideTime:KToastDismissDelayTimeInterval];
        }
    });
}

+ (void)dealErrorWith:(NSURLSessionDataTask*)task error:(NSError*)error needError:(BOOL)needError {
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
    //系统维护
    if (response.statusCode == 503) {
        [JLNetHelper dealWithHeadError:(NSHTTPURLResponse *)task.response];
        return;
    }
    [JLNetHelper dealWithAllError:error needError:needError];
}

#pragma mark 处理请求头信息
+ (void)dealWithHeadError:(NSHTTPURLResponse *)response {
    if (response.statusCode == 503) {
        UIViewController *topVC = [JLViewControllerTool topViewController];
        if (!topVC.presentingViewController) {
            [topVC.navigationController popToRootViewControllerAnimated:NO];
        }
        UITabBarController * tabBarController = [[AppSingleton sharedAppSingleton].globalNavController.viewControllers objectAtIndex:0];
        [tabBarController setSelectedIndex:0];
//        [AppSingleton sharedAppSingleton].protectView = [JLProtectView start];
    }
}

+ (void)removeProtectView{
//    if ([AppSingleton sharedAppSingleton].protectView.coverProView) {
//        [[AppSingleton sharedAppSingleton].protectView dismissProView];
//        [AppSingleton sharedAppSingleton].protectView= nil;
//    }
}

+ (void)dealWithAllError:(NSError*)error needError:(BOOL)needDealError {
    if (needDealError) {
        [self dealWithError:error];
    }
}

#pragma mark 处理错误信息
+ (void)dealWithError:(NSError*)error {
    ErrorRoot * rootError = [JLNetHelper serializationError:error];
    ErrorHead * errorHead = rootError.head;
    if (errorHead) {
        //对错误码进行处理
        //重新登录
        if (errorHead.code == 1032 || errorHead.code == 1070) {
            [JLNetHelper reloadLogin:0];
//            [[JLLoading sharedLoading] showMBFailedTipMessage:@"很抱歉，您还未登录" hideTime:KToastDismissDelayTimeInterval];
            return;
        }
        
        if(errorHead.msg.length>0) {
            [[JLLoading sharedLoading] showMBFailedTipMessage:errorHead.msg hideTime:KToastDismissDelayTimeInterval];
        } else {
            [[JLLoading sharedLoading] hideLoading];
        }
    } else {
        [JLNetHelper showTimeOutToast:error];
    }
}

@end
