//
//  JLLive2DCacheManager.h
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface JLLive2DCacheManager : NSObject

/** 限制缓存个数 */
@property (nonatomic, assign) NSInteger limitedCacheCount;

+ (instancetype)shareManager;

/// 获取本地的Live2D，若没有就缓存
/// @param path Live2D网络地址
/// @param fileKey 文件名
+ (NSURL *)live2DUrlWithPath:(NSString *)path fileKey:(NSString *)fileKey;

/// 获取本地的Live2D，若没有就缓存
/// @param path Live2D网络地址
+ (NSURL *)live2DUrlWithPath:(NSString *)path;

/// 获取本地的Live2D，若没有就缓存
/// @param path Live2D网络地址
/// @param fileKey 文件名
/// @param resulutBlock 下载成功回调
+ (NSURL *)live2DUrlWithPath:(NSString *)path fileKey:(NSString *)fileKey resulutBlock:(void(^)(NSURL *oldUrl,NSURL *newUrl))resulutBlock;

/// 获取本地的Live2D，若没有就缓存
/// @param path Live2D网络地址
/// @param resulutBlock 下载成功回调
+ (NSURL *)live2DUrlWithPath:(NSString *)path resulutBlock:(void(^)(NSURL *oldUrl,NSURL *newUrl))resulutBlock;

/// 获取本地Live2D数据
/// @param path 路径
+ (NSData *)dataWithLocalPath:(NSString *)path;

/// 获取本地Live2D数据
/// @param path 路径
/// @param fileKey 文件名
+ (NSData *)dataWithLocalPath:(NSString *)path fileKey:(NSString *)fileKey;

/// 获取本地Live2D数据
/// @param path Live2D网络地址
/// @param fileKey 文件名
/// @param resulutBlock 下载成功回调
+ (NSData *)dataWithLocalPath:(NSString *)path fileKey:(NSString *)fileKey resulutBlock:(void(^)(NSURL *oldUrl,NSURL *newUrl))resulutBlock;

/// 根据文件名获取本地路径
/// @param fileKey 文件名
+ (NSString *)localPathWithFileKey:(NSString *)fileKey;

/// 缓存数据
/// @param data 数据
/// @param fileKey 文件名
+ (BOOL)cacheLive2DWithData:(NSData *)data fileKey:(NSString *)fileKey;

/// 查询本地是否缓存了Live2D
/// @param url 视频地址
+ (BOOL)cachedVideoWithUrl:(NSURL *)url;


/// 获取文件大小 返回M
+ (CGFloat)getFileSize;


/// 下载Live2D到本地 并返回网络任务
/// @param path 视频网络地址
/// @param fileKey 存储文件名（若没有则默认路径最后一个）
/// @param progressBlock 缓存进度回调
/// @param successBlock 成功回调
/// @param failBlock 失败回调
- (NSURLSessionDownloadTask *)downLive2DWithPath:(NSString *)path
                                        fileID:(NSString *)fileId
                                        fileKey:(NSString *)fileKey
                                  progressBlock:(void(^)(CGFloat progress))progressBlock
                                        success:(void(^)(NSURL *URL))successBlock
                                           fail:(void(^)(NSString *message))failBlock;

/// 移除指定Live2D本地
/// @param path 视频网络地址
- (void)removeVideoPath:(NSString *)path;

/// 取消所有的下载
- (void)cancelAllDownloading;

/// 删除所有本地Live2D
- (void)clearAllCache;

@end
