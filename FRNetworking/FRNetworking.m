//
//  FRNetworking.m
//  FRDemo
//
//  Created by 1860 on 16/1/5.
//  Copyright © 2016年 QuFanrong. All rights reserved.
//

#import "FRNetworking.h"

static AFHTTPSessionManager *manager = nil;
static NSMutableArray *_allSessionTask;

@implementation FRNetworking

/**
 *  创建一个AFHTTPSessionManager网络请求管理者
 *
 *  @return AFHTTPSessionManager对象
 */
+ (AFHTTPSessionManager *)shareSessionManager{

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*", nil];
        
        manager.requestSerializer.timeoutInterval = 30.f;
        // 打开状态栏的等待菊花
        [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    });
    return manager;
}

#pragma mark - 取消网络请求
+ (void)cancelAllRequest {
    // 锁操作
    @synchronized(self) {
        [[self allSessionTask] enumerateObjectsUsingBlock:^(NSURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            [task cancel];
        }];
        [[self allSessionTask] removeAllObjects];
    }
}

+ (void)cancelRequestWithURLString:(NSString *)URLString {
    if (!URLString) { return; }
    @synchronized (self) {
        URLString = [self buildRequestUrlString:URLString];
        [[self allSessionTask] enumerateObjectsUsingBlock:^(NSURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([task.currentRequest.URL.absoluteString hasPrefix:URLString]) {
                [task cancel];
                [[self allSessionTask] removeObject:task];
                *stop = YES;
            }
        }];
    }
}


#pragma mark - GET异步请求网络数据
+ (NSURLSessionDataTask *)getWithURLString:(NSString *)URLString
                                parameters:(NSDictionary *)parameters
                                  progress:(void (^)(NSProgress *downloadProgress))progress
                             responseCache:(void (^)(id responseCache))responseCache
                                   success:(void (^)(id responseObject))success
                                   failure:(void (^)(NSError *error))failure {
    
    NSString *url = [self buildRequestUrlString:URLString];
    parameters = [self buildRequestParameters:parameters];
#if DEBUG
    NSMutableString *getString = [[NSMutableString alloc] initWithFormat:@"%@?",url];
    if (parameters) {
        for (NSString *each in parameters) {
            id value = parameters[each];
            [getString appendFormat:@"%@=%@&",each, value];
        }
    }
    NSLog(@"\n✨✨✨✨✨✨✨✨✨✨\nGET URL = %@\n",getString);
#endif
   if (responseCache) responseCache([FRNetworkCache httpCacheForURL:URLString parameters:parameters]);
    
    NSURLSessionDataTask *sessionDataTask = [[self shareSessionManager] GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progress) {
            progress(downloadProgress);
        }
    }  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) success(responseObject);
        NSLog(@"\nresponseObject = %@",responseObject);
        //对数据进行异步缓存
        if (responseCache) [FRNetworkCache setHttpCache:responseObject URL:URLString parameters:parameters];
        [[self allSessionTask] removeObject:task];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) failure(error);
        
        NSLog(@"\nerror = %@",error);
        [[self allSessionTask] removeObject:task];
    }];
    
    if (sessionDataTask) [[self allSessionTask] addObject:sessionDataTask];
    return sessionDataTask;
}

+ (NSURLSessionDataTask *)getWithURLString:(NSString *)URLString
                                parameters:(NSDictionary *)parameters
                             responseCache:(void (^)(id responseCache))responseCache
                                   success:(void (^)(id responseObject))success
                                   failure:(void (^)(NSError *error))failure {
    return [self getWithURLString:URLString parameters:parameters progress:nil responseCache:responseCache success:success failure:failure];
}

+ (NSURLSessionDataTask *)getWithURLString:(NSString *)URLString
                                parameters:(NSDictionary *)parameters
                                   success:(void (^)(id responseObject))success
                                   failure:(void (^)(NSError *error))failure {
    return [self getWithURLString:URLString parameters:parameters progress:nil responseCache:nil success:success failure:failure];
}




#pragma mark - POST异步请求网络数据
+ (NSURLSessionDataTask *)postWithURLString:(NSString *)URLString
                                 parameters:(NSDictionary *)parameters
                                   progress:(void (^)(NSProgress *downloadProgress)) progress
                              responseCache:(void (^)(id responseCache))responseCache
                                    success:(void (^)(id responseObject))success
                                    failure:(void (^)(NSError *error))failure {
    
    NSString *url = [self buildRequestUrlString:URLString];
    parameters = [self buildRequestParameters:parameters];
    
#if DEBUG
    NSMutableString *getString = [[NSMutableString alloc] initWithFormat:@"%@?",url];
    if (parameters) {
        for (NSString *each in parameters) {
            id value = parameters[each];
            [getString appendFormat:@"%@=%@&",each, value];
        }
    }
    NSLog(@"\n✨✨✨✨✨✨✨✨✨✨\nPOST URL = %@\n",getString);
#endif
    
    if (responseCache) responseCache([FRNetworkCache httpCacheForURL:URLString parameters:parameters]);
    
    NSURLSessionDataTask *sessionDataTask = [[self shareSessionManager] POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) success(responseObject);
        
        NSLog(@"\nresponseObject = %@",responseObject);
        //对数据进行异步缓存
        if (responseCache) [FRNetworkCache setHttpCache:responseObject URL:URLString parameters:parameters];
        [[self allSessionTask] removeObject:task];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
            NSLog(@"\nerror = %@",error);
        }
        [[self allSessionTask] removeObject:task];
    }];
    
    if (sessionDataTask) [[self allSessionTask] addObject:sessionDataTask];
    return sessionDataTask;
}

+ (NSURLSessionDataTask *)postWithURLString:(NSString *)URLString parameters:(NSDictionary *)parameters responseCache:(void (^)(id))responseCache success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    return [self postWithURLString:URLString parameters:parameters progress:nil responseCache:responseCache success:success failure:failure];
}

+ (NSURLSessionDataTask *)postWithURLString:(NSString *)URLString parameters:(NSDictionary *)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    return [self postWithURLString:URLString parameters:parameters progress:nil responseCache:nil success:success failure:failure];
}

#pragma mark - POST异步上传网络数据
/**
 Creates and runs an `NSURLSessionDataTask` with a multipart `POST` request.
 
 @param URLString The URL string used to create the request URL.
 @param parameters The parameters to be encoded according to the client request serializer.
 @param frFormData A block that takes a single argument and appends data to the HTTP body. The block argument is an object adopting the `AFMultipartFormData` protocol.
 @param progress A block object to be executed when the upload progress is updated. Note this block is called on the session queue, not the main queue.
 @param success A block object to be executed when the task finishes successfully. This block has no return value and takes two arguments: the data task, and the response object created by the client response serializer.
 @param failure A block object to be executed when the task finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes a two arguments: the data task and the error describing the network or parsing error that occurred.
 
 @see -dataTaskWithRequest:uploadProgress:downloadProgress:completionHandler:
 */
+ (NSURLSessionDataTask *)postWithURLString:(NSString *)URLString
                                 parameters:(NSDictionary *)parameters
                                   formData:(FRFormData *)frFormData
                                   progress:(void (^)(NSProgress *downloadProgress)) progress
                                    success:(void (^)(id responseObject))success
                                    failure:(void (^)(NSError *error))failure {
    
    
    NSString *url = [self buildRequestUrlString:URLString];
    parameters = [self buildRequestParameters:parameters];
    
#if DEBUG
    NSLog(@"✨✨✨✨✨✨✨✨✨✨\nPOST URL = %@     \n请求parameters = %@      \n请求data = %@      \n请求name = %@      \n请求fileName = %@      \n请求mimeType = %@",url,parameters,frFormData.data,frFormData.name,frFormData.fileName,frFormData.mimeType);
#endif
    NSURLSessionDataTask *sessionDataTask = [[self shareSessionManager] POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:frFormData.data name:frFormData.name fileName:frFormData.fileName mimeType:frFormData.mimeType];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
            NSLog(@"\nresponseObject = %@",responseObject);
        }
        [[self allSessionTask] removeObject:task];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
            NSLog(@"\nerror = %@",error);
        }
        [[self allSessionTask] removeObject:task];
    }];
    
    if (sessionDataTask) [[self allSessionTask] addObject:sessionDataTask];
    return sessionDataTask;
}


+ (NSURLSessionDataTask *)postWithURLString:(NSString *)URLString
               parameters:(NSDictionary *)parameters
                 formData:(FRFormData *)frFormData
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure {
    return [self postWithURLString:URLString parameters:parameters formData:frFormData progress:^(NSProgress *downloadProgress) {
    } success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


#pragma mark - 下载文件
+ (NSURLSessionTask *)downloadWithURLString:(NSString *)URLString
                              fileDirectory:(NSString *)fileDirectory
                                   progress:(void (^)(NSProgress *downloadProgress))progress
                                    success:(void (^)(id responseObject))success
                                    failure:(void (^)(NSError *error))failure {
    
    NSString *url = [self buildRequestUrlString:URLString];

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    __block NSURLSessionDownloadTask *downloadTask = [[self shareSessionManager] downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        //下载进度
        dispatch_sync(dispatch_get_main_queue(), ^{
            if(progress) progress(downloadProgress);
        });
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        //拼接缓存目录
        NSString *downloadDirectory = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:fileDirectory ? fileDirectory : @"Download"];
        //打开文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        //创建Download目录
        [fileManager createDirectoryAtPath:downloadDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        //拼接文件路径
        NSString *filePath = [downloadDirectory stringByAppendingPathComponent:response.suggestedFilename];
        //返回文件位置的URL路径
        return [NSURL fileURLWithPath:filePath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        [[self allSessionTask] removeObject:downloadTask];
        if(failure && error) {failure(error) ; return ;};
        if(success) success(filePath.absoluteString /** NSURL->NSString*/);
    }];
    //开始下载
    [downloadTask resume];
    // 添加sessionTask到数组
    if (downloadTask) [[self allSessionTask] addObject:downloadTask];
    
    return downloadTask;
}


/**
 存储着所有的请求task数组
 */
+ (NSMutableArray *)allSessionTask {
    if (!_allSessionTask) {
        _allSessionTask = [[NSMutableArray alloc] init];
    }
    return _allSessionTask;
}

#pragma mark - 重置AFHTTPSessionManager相关属性

+ (void)setAFHTTPSessionManagerProperty:(void (^)(AFHTTPSessionManager *))sessionManager {
    sessionManager ? sessionManager([self shareSessionManager]) : nil;
}

+ (void)setRequestSerializer:(FRRequestSerializer)requestSerializer {
    [self shareSessionManager].requestSerializer = requestSerializer==FRRequestSerializerHTTP ? [AFHTTPRequestSerializer serializer] : [AFJSONRequestSerializer serializer];
}

+ (void)setResponseSerializer:(FRResponseSerializer)responseSerializer {
    [self shareSessionManager].responseSerializer = responseSerializer==FRResponseSerializerHTTP ? [AFHTTPResponseSerializer serializer] : [AFJSONResponseSerializer serializer];
}

+ (void)setRequestTimeoutInterval:(NSTimeInterval)time {
    [self shareSessionManager].requestSerializer.timeoutInterval = time;
}

+ (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field {
    [[self shareSessionManager].requestSerializer setValue:value forHTTPHeaderField:field];
}

+ (void)openNetworkActivityIndicator:(BOOL)open {
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:open];
}

+ (void)setSecurityPolicyWithCerPath:(NSString *)cerPath validatesDomainName:(BOOL)validatesDomainName {
    NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
    // 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    // 如果需要验证自建证书(无效证书)，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    // 是否需要验证域名，默认为YES;
    securityPolicy.validatesDomainName = validatesDomainName;
    securityPolicy.pinnedCertificates = [[NSSet alloc] initWithObjects:cerData, nil];
    
    [[self shareSessionManager] setSecurityPolicy:securityPolicy];
}

#pragma mark - 拼接通用域名、请求体
/**
 拼接通用域名
 */
+ (NSString *)buildRequestUrlString:(NSString *)urlString {
    //urlString带域名直接返回
    if (!([urlString rangeOfString:@"http://"].location != NSNotFound || [urlString rangeOfString:@"https://"].location != NSNotFound)) {
        
        NSString *baseUrl;
        NSDictionary *hostURLDict = [FRNetworkConfig shareConfig].hostURLDict;
        NSArray *array = [hostURLDict allKeys];
        if (array.count > 0) {//取特定地址的域名
            for (NSString *key in array) {
                if ([key isEqualToString:urlString]) {
                    baseUrl = hostURLDict[key];
                    break;
                }
            }
        }
        //地址非特定域名则选用全局域名
        if(!baseUrl) baseUrl = [FRNetworkConfig shareConfig].hostURL;
        if (baseUrl && baseUrl.length > 0) {
            urlString = [baseUrl stringByAppendingString:urlString];
        }
    }
    return [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
}

/**
 拼接公共请求参数
 */
+ (NSDictionary *)buildRequestParameters:(NSDictionary *)parameters {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [dict addEntriesFromDictionary:[FRNetworkConfig shareConfig].baseParameters];
    return [dict copy];
}

@end

