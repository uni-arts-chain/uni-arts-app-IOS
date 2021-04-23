//
//  JLLive2DCacheManager.m
//  CloudArtChain
//
//  Created by 朱彬 on 2020/8/24.
//  Copyright © 2020 朱彬. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JLLive2DCacheManager.h"
#import <AFNetworking.h>
#import "SSZipArchive.h"


#define localLive2DPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"Live2DFiles"]

#define localLive2DTempPath [localLive2DPath stringByAppendingPathComponent:@"temp"]

#define localLive2DPathWithKey(key) [localLive2DPath stringByAppendingPathComponent:key]

#define localLive2DTempPathWithKey(key) [localLive2DTempPath stringByAppendingPathComponent:key]

@interface JLLive2DCacheManager()<NSURLSessionDelegate>

/** 当前正在缓存的文件 */
@property (nonatomic, strong) NSMutableArray *cacheArr;
/** 下载 */
@property (nonatomic, strong) AFURLSessionManager *manager;

/** 文件名缓存数组 */
@property (nonatomic, strong) NSMutableArray *keyArr;

/** 正在缓存中的任务 */
@property (nonatomic, strong) NSMutableArray *taskArr;

@end

static NSString *const keyArrKey = @"Live2DCackeKeyArr";

@implementation JLLive2DCacheManager

-(AFURLSessionManager *)manager {
    if (!_manager) {
        _manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        AFCompoundResponseSerializer *serializer = [AFCompoundResponseSerializer serializer];
        serializer.acceptableContentTypes = [NSSet setWithObject:@"application/x-zip-compressed"];
        _manager.responseSerializer = serializer;
    }
    return _manager;
}

-(NSMutableArray *)taskArr {
    if (!_taskArr) {
        _taskArr = [NSMutableArray array];
    }
    return _taskArr;
}

-(NSMutableArray *)cacheArr {
    if (!_cacheArr) {
        _cacheArr = [NSMutableArray array];
    }
    return _cacheArr;
}

-(NSMutableArray *)keyArr {
    if (!_keyArr) {
        _keyArr = [[[NSUserDefaults standardUserDefaults] objectForKey:keyArrKey] mutableCopy];
        if (!_keyArr) {
            _keyArr = [NSMutableArray array];
        }
    }
    return _keyArr;
}


+ (instancetype)shareManager {
    static JLLive2DCacheManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[JLLive2DCacheManager alloc] init];
    });
    [manager creatlocalLive2DPath];
    return manager;
}

- (void)creatlocalLive2DPath {
    if (![[NSFileManager defaultManager] fileExistsAtPath:localLive2DPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:localLive2DPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if (![[NSFileManager defaultManager] fileExistsAtPath:localLive2DTempPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:localLive2DTempPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

+ (NSURL *)live2DUrlWithPath:(NSString *)path fileKey:(NSString *)fileKey {
    return [[JLLive2DCacheManager shareManager] live2DUrlForPath:path fileKey:fileKey resulutBlock:nil];
}

+ (NSURL *)live2DUrlWithPath:(NSString *)path {
   return [JLLive2DCacheManager live2DUrlWithPath:path fileKey:path.lastPathComponent resulutBlock:nil];
}

+ (NSURL *)live2DUrlWithPath:(NSString *)path fileKey:(NSString *)fileKey resulutBlock:(void(^)(NSURL *oldUrl,NSURL *newUrl))resulutBlock {
    
    return [[JLLive2DCacheManager shareManager] live2DUrlForPath:path fileKey:fileKey resulutBlock:resulutBlock];
}

+ (NSURL *)live2DUrlWithPath:(NSString *)path resulutBlock:(void(^)(NSURL *oldUrl,NSURL *newUrl))resulutBlock {
   return [JLLive2DCacheManager live2DUrlWithPath:path fileKey:path.lastPathComponent resulutBlock:resulutBlock];
}

+ (BOOL)cacheLive2DWithData:(NSData *)data fileKey:(NSString *)fileKey {
    return [[JLLive2DCacheManager shareManager] cacheLive2DWithData:data fileKey:fileKey];
}

+ (NSData *)dataWithLocalPath:(NSString *)path {
    return [JLLive2DCacheManager dataWithLocalPath:path fileKey:nil];
}

+ (NSData *)dataWithLocalPath:(NSString *)path fileKey:(NSString *)fileKey {
    return [[JLLive2DCacheManager shareManager] dataWithLocalPath:path fileKey:fileKey resulutBlock:nil];
}

+ (NSData *)dataWithLocalPath:(NSString *)path fileKey:(NSString *)fileKey resulutBlock:(void(^)(NSURL *oldUrl,NSURL *newUrl))resulutBlock {
    return [[JLLive2DCacheManager shareManager] dataWithLocalPath:path fileKey:fileKey resulutBlock:resulutBlock];
}

+ (NSString *)localPathWithFileKey:(NSString *)fileKey {
    if ([NSString stringIsEmpty:fileKey]) {
        return nil;
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:localLive2DPathWithKey(fileKey) isDirectory:YES]) {
        return localLive2DPathWithKey(fileKey);
    } else if ([[NSFileManager defaultManager] fileExistsAtPath:localLive2DTempPathWithKey(fileKey) isDirectory:YES]) {
        return localLive2DTempPathWithKey(fileKey);
    }
    return nil;
}

+ (BOOL)cachedLive2DWithUrl:(NSURL *)url {
    if ([[NSFileManager defaultManager] fileExistsAtPath:url.path]) {
        return YES;
    }
    return NO;
}

+ (CGFloat)getFileSize {
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:localLive2DPath]) {
        NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:localLive2DPath] objectEnumerator];
        NSString* fileName;
        CGFloat folderSize = 0;
        while ((fileName = [childFilesEnumerator nextObject]) != nil){
            NSString* fileAbsolutePath = [localLive2DPath stringByAppendingPathComponent:fileName];
            if ([manager fileExistsAtPath:fileAbsolutePath]){
                CGFloat everySize = [[manager attributesOfItemAtPath:fileAbsolutePath error:nil] fileSize];
                folderSize += everySize;
            }
        }
        return folderSize / 1024.0f / 1024.0f;
    }
    return 0.0f;
}



- (NSURLSessionDownloadTask *)downLive2DWithPath:(NSString *)path
                                          fileID:(NSString *)fileId
                                        fileKey:(NSString *)fileKey
                                  progressBlock:(void(^)(CGFloat progress))progressBlock
                                        success:(void(^)(NSURL *URL))successBlock
                                           fail:(void(^)(NSString *message))failBlock {
    WS(weakSelf)
//    if ([JLLive2DCacheManager cachedLive2DWithUrl:[NSURL URLWithString:path]]) {
//        if (successBlock) {
//            successBlock([NSURL URLWithString:path]);
//        }
//        return nil;
//    }
    // 文件存储位置
    NSString *live2DFileDir = [localLive2DPath stringByAppendingPathComponent:fileId];
    if (![[NSFileManager defaultManager] fileExistsAtPath:live2DFileDir]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:live2DFileDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:path]];
    NSURLSessionDownloadTask *downloadTask = [self.manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (progressBlock) {
                progressBlock(downloadProgress.fractionCompleted);
            }
        });
        NSLog(@"下载进度：%.0f％", downloadProgress.fractionCompleted * 100);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        /* 设定下载到的位置 */
        NSURL *targetUrl = [NSURL fileURLWithPath:localLive2DTempPathWithKey(fileKey)];
        return targetUrl;
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        //完成
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                // 解压文件
                NSString *tempFilePath = [filePath.filePathURL.absoluteString stringByReplacingOccurrencesOfString:@"file://" withString:@""];
//                BOOL unzipSuccess = [SSZipArchive unzipFileAtPath:localLive2DTempPathWithKey(fileKey) toDestination:localLive2DPath];
                [SSZipArchive unzipFileAtPath:localLive2DTempPathWithKey(fileKey) toDestination:live2DFileDir progressHandler:^(NSString * _Nonnull entry, unz_file_info zipInfo, long entryNumber, long total) {
                    
                } completionHandler:^(NSString * _Nonnull path, BOOL succeeded, NSError * _Nonnull error) {
                    [[NSFileManager defaultManager] removeItemAtURL:filePath error:nil];
                    if (succeeded) {
                        if (successBlock) {
        //                    [weakSelf cacheFileKey:fileKey];
                            successBlock(filePath);
                        }
                    } else {
                        NSLog(@"error: %@", error);
                    }
                }];
            } else {
                if (failBlock) {
                    failBlock(@"下载失败");
                }
            }
        });
        
    }];
    
    [downloadTask resume];
    return downloadTask;
}



- (void)removeLive2DPath:(NSString *)path {
    NSString *key = path.lastPathComponent;
    if ([NSString stringIsEmpty:path] || [NSString stringIsEmpty:key]) {
        return ;
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:localLive2DPathWithKey(key)]) {
        BOOL success = [[NSFileManager defaultManager] removeItemAtPath:localLive2DPathWithKey(key) error:nil];
        if (success) {
            [self.keyArr removeObject:key];
            [self cacheKeyArr];
        }
    }
}

- (void)clearAllCache {
    if ([[NSFileManager defaultManager] fileExistsAtPath:localLive2DPath isDirectory:YES]) {
        BOOL success = [[NSFileManager defaultManager] removeItemAtPath:localLive2DPath error:nil];
        if (success) {
            [self.keyArr removeAllObjects];
            [self cacheKeyArr];
        }
    }
}

- (void)cancelAllDownloading {
    for (NSURLSessionTask *task in self.taskArr) {
        [task cancel];
    }
    [self.cacheArr removeAllObjects];
}


#pragma mark 私有方法
- (NSURL *)live2DUrlForPath:(NSString *)path fileKey:(NSString *)fileKey resulutBlock:(void(^)(NSURL *oldUrl,NSURL *newUrl))resulutBlock {
    if ([NSString stringIsEmpty:path]) {
        return nil;
    }
    if ([NSString stringIsEmpty:fileKey]) {
        fileKey = path.lastPathComponent;
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:localLive2DPathWithKey(fileKey)]) {
        [self cacheFileKey:fileKey];
        NSURL *url = [NSURL fileURLWithPath:localLive2DPathWithKey(fileKey)];
        return url;
    } else {
        path = [path stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [self cacheLive2DWithPath:path fileKey:fileKey resulutBlock:^(NSURL *targetUrl) {
            if (resulutBlock) {
                resulutBlock([NSURL fileURLWithPath:localLive2DTempPathWithKey(fileKey)],targetUrl);
            }
        }];
        if ([[NSFileManager defaultManager] fileExistsAtPath:localLive2DTempPathWithKey(fileKey) isDirectory:YES]) {
            NSURL *url = [NSURL fileURLWithPath:localLive2DTempPathWithKey(fileKey)];
            return url;
        }
        NSURL *url = [NSURL URLWithString:path];
        return url;
    }
}

- (NSData *)dataWithLocalPath:(NSString *)path fileKey:(NSString *)fileKey resulutBlock:(void(^)(NSURL *oldUrl,NSURL *newUrl))resulutBlock {
    if ([NSString stringIsEmpty:path] || [NSString stringIsEmpty:fileKey]) {
        return nil;
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:localLive2DPathWithKey(fileKey)]) {
        NSData *data = [NSData dataWithContentsOfFile:localLive2DPathWithKey(fileKey)];
        return data;
    } else {
        path = [path stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [self cacheLive2DWithPath:path fileKey:fileKey resulutBlock:^(NSURL *targetUrl) {
            if (resulutBlock) {
                resulutBlock([NSURL fileURLWithPath:localLive2DTempPathWithKey(fileKey)],targetUrl);
            }
        }];
        if ([[NSFileManager defaultManager] fileExistsAtPath:localLive2DTempPathWithKey(fileKey) isDirectory:YES]) {
            NSData *data = [NSData dataWithContentsOfFile:localLive2DTempPathWithKey(fileKey)];
            return data;
        }
        return nil;
    }
}


- (BOOL)cacheLive2DWithData:(NSData *)data fileKey:(NSString *)fileKey {
    NSURL *fileUrl = [NSURL fileURLWithPath:localLive2DPathWithKey(fileKey)];
    if ([JLLive2DCacheManager cachedVideoWithUrl:fileUrl]) {
        return YES;
    }
    NSError *error;
    BOOL success = [data writeToFile:localLive2DPathWithKey(fileKey) options:NSDataWritingAtomic error:&error];
    if (success && !error) {
        NSLog(@"视频缓存成功");
        [self cacheFileKey:fileKey];
        return YES;
    }
    NSLog(@"视频缓存失败");
    return NO;
}


- (void)cacheLive2DWithPath:(NSString *)path fileKey:(NSString *)fileKey resulutBlock:(void(^)(NSURL *targetUrl))resulutBlock {
    WS(weakSelf)
    if (![self.cacheArr containsObject:fileKey]) {
        [self.cacheArr addObject:fileKey];
        [self fileBytesWithURLStr:path fileKey:fileKey resultBlock:^(BOOL isComplete) {
            if (!isComplete) {
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    [weakSelf continueDownLive2DWithPath:path fileKey:fileKey progressBlock:nil success:^(NSURL *URL) {
                        [weakSelf.cacheArr removeObject:fileKey];
                        if (resulutBlock) {
                            resulutBlock(URL);
                        }
                    } fail:^(NSString *message) {
                        [weakSelf.cacheArr removeObject:fileKey];
                    }];
                });
            }
        }];
    }
}


- (void)continueDownLive2DWithPath:(NSString *)path
                          fileKey:(NSString *)fileKey
                    progressBlock:(void(^)(CGFloat progress))progressBlock
                          success:(void(^)(NSURL *URL))successBlock
                             fail:(void(^)(NSString *message))failBlock{
    WS(weakSelf)
    // 创建下载URL
    NSURL *url = [NSURL URLWithString:path];
    // 创建request请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //获取本地文件长度
    __block NSInteger currentLength = [self localFileBytesWithFileKey:fileKey];
    __block NSInteger totalLength = 0;
    //文件句柄
    __block NSFileHandle *fileHandle;
    // 设置HTTP请求头中的Range
    NSString *range = [NSString stringWithFormat:@"bytes=%zd-", currentLength];
    [request setValue:range forHTTPHeaderField:@"Range"];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    AFCompoundResponseSerializer *serializer = [AFCompoundResponseSerializer serializer];
    serializer.acceptableContentTypes = [NSSet setWithObject:@"application/x-zip-compressed"];
    manager.responseSerializer = serializer;
    
    NSURLSessionDataTask *downloadTask = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        [weakSelf.taskArr removeObject:downloadTask];
        // 关闭fileHandle
        [fileHandle closeFile];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                NSError *err;
                [[NSFileManager defaultManager] moveItemAtPath:localLive2DTempPathWithKey(fileKey) toPath:localLive2DPathWithKey(fileKey) error:&err];
                if (successBlock && !err) {
                    [weakSelf cacheFileKey:fileKey];
                    successBlock([NSURL fileURLWithPath:localLive2DPathWithKey(fileKey)]);
                }
            } else {
                if (failBlock) {
                    failBlock(@"下载失败");
                }
            }
        });
    }];
    
    [self.taskArr addObject:downloadTask];
    [manager setDataTaskDidReceiveResponseBlock:^NSURLSessionResponseDisposition(NSURLSession * _Nonnull session, NSURLSessionDataTask * _Nonnull dataTask, NSURLResponse * _Nonnull response) {
        // 每次唤醒task的时候会回调这个block
        // 获得下载文件的总长度：请求下载的文件长度 + 当前已经下载的文件长度
        totalLength = response.expectedContentLength + currentLength;
        // 创建一个空的文件到沙盒中
        NSFileManager *manager = [NSFileManager defaultManager];
        if (![manager fileExistsAtPath:localLive2DTempPathWithKey(fileKey)]) {
            // 如果没有下载文件的话，就创建一个文件。如果有下载文件的话，则不用重新创建(不然会覆盖掉之前的文件)
            [manager createFileAtPath:localLive2DTempPathWithKey(fileKey) contents:nil attributes:nil];
        }
        // 创建文件句柄
        fileHandle = [NSFileHandle fileHandleForWritingAtPath:localLive2DTempPathWithKey(fileKey)];
        // 允许处理服务器的响应，才会继续接收服务器返回的数据
        return NSURLSessionResponseAllow;
    }];

    [manager setDataTaskDidReceiveDataBlock:^(NSURLSession * _Nonnull session, NSURLSessionDataTask * _Nonnull dataTask, NSData * _Nonnull data) {
        // 一直回调，直到下载完成
        // 指定数据的写入位置 -- 文件内容的最后面
        [fileHandle seekToEndOfFile];
        // 向沙盒写入数据
        [fileHandle writeData:data];
        // 拼接文件总长度
        currentLength += data.length;
        // 获取主线程，不然无法正确显示进度。
        dispatch_async(dispatch_get_main_queue(), ^{
            if (progressBlock) {
                progressBlock(100.0 * currentLength / totalLength);
            }
            // 下载进度
            NSLog(@"当前下载进度:%.2f%%",100.0 * currentLength / totalLength);
        });
    }];
    
    [downloadTask resume];
}


- (void)cacheFileKey:(NSString *)key {
    if ([NSString stringIsEmpty:key]) {
        return;
    }
    if ([self.keyArr containsObject:key]) {
        [self.keyArr removeObject:key];
    }
    [self.keyArr insertObject:key atIndex:0];
    if (self.keyArr.count > self.limitedCacheCount && self.limitedCacheCount != 0) {
        NSString *lastKey = self.keyArr.lastObject;
        NSError *removeError;
        [[NSFileManager defaultManager] removeItemAtPath:lastKey error:&removeError];
        if (!removeError) {
            [self.keyArr removeLastObject];
        }
    }
    [self cacheKeyArr];
}

- (void)cacheKeyArr {
    [[NSUserDefaults standardUserDefaults] setObject:[self.keyArr copy] forKey:keyArrKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)fileBytesWithURLStr:(NSString *)urlStr fileKey:(NSString *)fileKey resultBlock:(void(^)(BOOL isComplete))resultBlock {
    WS(weakSelf)
    NSURL* URL = [NSURL URLWithString:urlStr];
    //创建请求对象
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:URL];
    //设置请求方式
    [request setHTTPMethod:@"HEAD"];
    //获取请求头信息
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    [manager HEAD:urlStr parameters:nil headers:nil success:^(NSURLSessionDataTask * _Nonnull task) {
        NSInteger fileBytes = task.countOfBytesExpectedToReceive;
        NSInteger localFileBytes = [weakSelf localFileBytesWithFileKey:fileKey];
        if (resultBlock) {
            resultBlock(localFileBytes == fileBytes);
        }
    } failure:nil];
}

- (NSInteger)localFileBytesWithFileKey:(NSString *)fileKey {
    NSString* fileAbsolutePath = [localLive2DPath stringByAppendingPathComponent:fileKey];
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileAbsolutePath]){
        CGFloat fileSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:fileAbsolutePath error:nil] fileSize];
        return fileSize;
    }
    NSString* tempPath = [localLive2DTempPath stringByAppendingPathComponent:fileKey];
    if ([[NSFileManager defaultManager] fileExistsAtPath:tempPath]){
        CGFloat fileSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:tempPath error:nil] fileSize];
        return fileSize;
    }
    return 0;
}

@end
