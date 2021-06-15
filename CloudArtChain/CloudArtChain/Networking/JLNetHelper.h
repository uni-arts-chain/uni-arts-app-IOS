//
//  JLNetHelper.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

typedef enum
{
    RequestTypeGet,
    RequestTypePost,
    RequestTypeDelete,
    RequestTypeUpload
}RequestType;

@interface JLNetHelper : NSObject
/**
 Post请求

 @param reqPar 请求参数
 @param rspPar 请求应答
 @param callBack 请求回调
 */
+ (void)netRequestPostParameters:(id)reqPar responseParameters:(id)rspPar callBack:(void(^)(BOOL netIsWork,NSString *errorStr, NSInteger errorCode))callBack;

/**
 Get请求

 @param reqPar 请求参数
 @param rspPar 请求应答
 @param callBackBlock 请求回调
 */
+ (void)netRequestGetParameters:(id)reqPar respondParameters:(id)rspPar callBack:(void(^)(BOOL netIsWork, NSString *errorStr, NSInteger errorCode))callBackBlock;


/// Delete请求
/// @param reqPar 请求参数
/// @param rspPar 请求应答
/// @param callBackBlock 请求回调
+ (NSURLSessionDataTask*)netRequestDeleteParameters:(id)reqPar respondParameters:(id)rspPar callBack:(void (^)(BOOL netIsWork, NSString *errorStr, NSInteger errorCode))callBackBlock;

//上传数据方法 没经过当前项目测试 暂时不用
+ (void)netRequestUploadDataWithUrl:(NSString *)url
                     para:(NSDictionary *)para
                 fileData:(NSData *)fileData
                     name:(NSString *)name
                  callBack:(void(^)(BOOL netIsWork, NSString *errorStr, NSInteger errorCode))callBackBlock;


/// 文件上传 并完成Post 请求 身份核验
/// @param reqPar 请求参数
/// @param rspPar 请求应答
/// @param fileName 文件名称
/// @param fileData 文件数据
/// @param callBackBlock 请求回调
+ (void)netRequestPostUploadParameters:(id)reqPar respondParameters:(id)rspPar fileName:(NSString *)fileName fileData:(NSData *)fileData callBack:(void(^)(BOOL netIsWork, NSString *errorStr, NSInteger errorCode))callBackBlock;

/// 文件上传 视频
/// @param reqPar 请求参数
/// @param rspPar 请求应答
/// @param fileNameArray 文件名称数组
/// @param fileDataArray 文件数据数组
/// @param callBackBlock 请求回调
+ (void)netRequestUploadVideoParameters:(id)reqPar respondParameters:(id)rspPar paramsNames:(NSArray *)paramsArray fileNames:(NSArray *)fileNameArray fileData:(NSArray *)fileDataArray fileType:(NSArray *)fileTypeArray callBack:(void(^)(BOOL netIsWork, NSString *errorStr, NSInteger errorCode))callBackBlock;

/// 文件上传 并完成Post 请求 身份核验
/// @param reqPar 请求参数
/// @param rspPar 请求应答
/// @param parasName 请求参数 文件名
/// @param fileName 文件名称
/// @param fileData 文件数据
/// @param callBackBlock 请求回调
+ (void)netRequestPostUploadParameters:(id)reqPar respondParameters:(id)rspPar paramsName:(NSString *)parasName fileName:(NSString *)fileName fileData:(NSData *)fileData callBack:(void(^)(BOOL netIsWork, NSString *errorStr, NSInteger errorCode))callBackBlock;


/// 文件上传 多个图片
/// @param reqPar 请求参数
/// @param rspPar 请求应答
/// @param fileNameArray 文件名称数组
/// @param fileDataArray 文件数据数组
/// @param callBackBlock 请求回调
+ (void)netRequestUploadImagesParameters:(id)reqPar respondParameters:(id)rspPar fileNames:(NSArray *)fileNameArray fileData:(NSArray *)fileDataArray callBack:(void(^)(BOOL netIsWork, NSString *errorStr, NSInteger errorCode))callBackBlock;

/// 文件上传 多个图片
/// @param reqPar 请求参数
/// @param rspPar 请求应答
/// @param fileNameArray 文件名称数组
/// @param fileDataArray 文件数据数组
/// @param callBackBlock 请求回调
+ (void)netRequestUploadImagesParameters:(id)reqPar respondParameters:(id)rspPar paramsNames:(NSArray *)paramsArray fileNames:(NSArray *)fileNameArray fileData:(NSArray *)fileDataArray fileType:(NSArray *)fileTypeArray callBack:(void(^)(BOOL netIsWork, NSString *errorStr, NSInteger errorCode))callBackBlock;

/// 文件上传 zip文件上传
/// @param reqPar 请求参数
/// @param rspPar 请求应答
/// @param paramName 参数名称
/// @param fileName 文件名称
/// @param fileData 文件数据
/// @param callBackBlock 请求回调
+ (void)netRequestUploadZipFileParameters:(id)reqPar respondParameters:(id)rspPar paramName:(NSString *)paramName fileName:(NSString *)fileName fileData:(NSData *)fileData callBack:(void(^)(BOOL netIsWork, NSString *errorStr, NSInteger errorCode))callBackBlock;

+ (NSString*)getTimeString;
+ (void)managerHeadBaseConfig:(AFHTTPSessionManager*)manager withTime:(NSString*)nowTime;
+ (void)setToken:(AFHTTPSessionManager*)manager url:(NSString *)url para:(NSDictionary *)para isGET:(BOOL)isGET timeString:(NSString*)timeString;
+ (void)reloadLogin:(NSInteger)showTabIndex;
@end
