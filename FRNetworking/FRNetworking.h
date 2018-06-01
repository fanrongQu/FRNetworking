//
//  FRNetworking.h
//  FRDemo
//
//  Created by 1860 on 16/1/5.
//  Copyright © 2016年 QuFanrong. All rights reserved.
//

#import <Foundation/Foundation.h>

#if __has_include(<AFNetworking/AFNetworking.h>)

#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>
#else

#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"
#endif

#if __has_include(<FRNetworking/FRNetworking.h>)

#import <FRNetworking/FRNetworkReachabilityManager.h>
#import <FRNetworking/FRNetworkConfig.h>
#import <FRNetworking/FRNetworkCache.h>
#import <FRNetworking/FRFormData.h>

#else

#import "FRNetworkReachabilityManager.h"
#import "FRNetworkConfig.h"
#import "FRNetworkCache.h"
#import "FRFormData.h"

#endif /* __has_include */


@interface FRNetworking : NSObject


typedef NS_ENUM(NSUInteger, FRRequestSerializer) {
    /** 设置请求数据为JSON格式*/
    FRRequestSerializerJSON,
    /** 设置请求数据为二进制格式*/
    FRRequestSerializerHTTP,
};

typedef NS_ENUM(NSUInteger, FRResponseSerializer) {
    /** 设置响应数据为JSON格式*/
    FRResponseSerializerJSON,
    /** 设置响应数据为二进制格式*/
    FRResponseSerializerHTTP,
};


#pragma mark - 取消网络请求
+ (void)cancelAllRequest;

+ (void)cancelRequestWithURLString:(NSString *)URLString;

#pragma mark - GET异步请求网络数据
/**
 *  发送一个GET请求
 *
 *  @param URLString        请求路径
 *  @param parameters       请求参数
 *  @param success          请求成功后的回调
 *  @param failure          请求失败后的回调
 */
+ (NSURLSessionDataTask *)getWithURLString:(NSString *)URLString
                                parameters:(NSDictionary *)parameters
                                   success:(void (^)(id responseObject))success
                                   failure:(void (^)(NSError *error))failure;
/**
 *  发送一个GET请求(有缓存)
 *
 *  @param URLString        请求路径
 *  @param parameters       请求参数
 *  @param responseCache    网络缓存
 *  @param success          请求成功后的回调
 *  @param failure          请求失败后的回调
 */
+ (NSURLSessionDataTask *)getWithURLString:(NSString *)URLString
                                parameters:(NSDictionary *)parameters
                             responseCache:(void (^)(id responseCache))responseCache
                                   success:(void (^)(id responseObject))success
                                   failure:(void (^)(NSError *error))failure;

/**
 *  发送一个GET请求(有下载进度参数，有缓存)
 *
 *  @param URLString        请求路径
 *  @param parameters       请求参数
 *  @param progress         数据请求进度
 *  @param responseCache    缓存数据回调
 *  @param success          请求成功后的回调
 *  @param failure          请求失败后的回调
 */
+ (NSURLSessionDataTask *)getWithURLString:(NSString *)URLString
                                parameters:(NSDictionary *)parameters
                                  progress:(void (^)(NSProgress *downloadProgress)) progress
                             responseCache:(void (^)(id responseCache))responseCache
                                   success:(void (^)(id responseObject))success
                                   failure:(void (^)(NSError *error))failure;

#pragma mark - POST异步请求网络数据
/**
 *  发送一个POST请求
 *
 *  @param URLString        请求路径
 *  @param parameters       请求参数
 *  @param success          请求成功后的回调
 *  @param failure          请求失败后的回调
 */
+ (NSURLSessionDataTask *)postWithURLString:(NSString *)URLString
                                 parameters:(NSDictionary *)parameters
                                    success:(void (^)(id responseObject))success
                                    failure:(void (^)(NSError *error))failure;
/**
 *  发送一个POST请求(有缓存)
 *
 *  @param URLString        请求路径
 *  @param parameters       请求参数
 *  @param responseCache    缓存数据回调
 *  @param success          请求成功后的回调
 *  @param failure          请求失败后的回调
 */
+ (NSURLSessionDataTask *)postWithURLString:(NSString *)URLString
                                 parameters:(NSDictionary *)parameters
                              responseCache:(void (^)(id responseCache))responseCache
                                    success:(void (^)(id responseObject))success
                                    failure:(void (^)(NSError *error))failure;

/**
 *  发送一个POST请求(有下载进度参数，有缓存)
 *
 *  @param URLString        请求路径
 *  @param parameters       请求参数
 *  @param progress         数据请求进度
 *  @param responseCache    缓存数据回调
 *  @param success          请求成功后的回调
 *  @param failure          请求失败后的回调
 */
+ (NSURLSessionDataTask *)postWithURLString:(NSString *)URLString
                                 parameters:(NSDictionary *)parameters
                                   progress:(void (^)(NSProgress *downloadProgress)) progress
                              responseCache:(void (^)(id responseCache))responseCache
                                    success:(void (^)(id responseObject))success
                                    failure:(void (^)(NSError *error))failure;


#pragma mark - POST异步上传网络数据
/**
 *  发送一个POST请求(上传网络数据,没有上传进度参数)
 *
 *  @param URLString        请求路径
 *  @param parameters       请求参数
 *  @param success          请求成功后的回调
 *  @param failure          请求失败后的回调
 */
+ (NSURLSessionDataTask *)postWithURLString:(NSString *)URLString
               parameters:(NSDictionary *)parameters
                 formData:(FRFormData *)frFormData
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure;

/**
 *  发送一个POST请求(上传网络数据，带有上传进度参数)
 *
 *  @param URLString        请求路径
 *  @param parameters       请求参数
 *  @param progress         下载进度
 *  @param success          请求成功后的回调
 *  @param failure          请求失败后的回调
 */
+ (NSURLSessionDataTask *)postWithURLString:(NSString *)URLString
               parameters:(NSDictionary *)parameters
                 formData:(FRFormData *)frFormData
                 progress:(void (^)(NSProgress *downloadProgress))progress
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure;



#pragma mark - 下载文件
/**
 下载文件

 @param URLString       文件地址
 @param fileDirectory   文件存储的问价夹名称
 @param progress        下载进度
 @param success         请求成功后的回调
 @param failure         请求失败后的回调
 */
+ (NSURLSessionTask *)downloadWithURLString:(NSString *)URLString
                              fileDirectory:(NSString *)fileDirectory
                                   progress:(void (^)(NSProgress *downloadProgress))progress
                                    success:(void (^)(id responseObject))success
                                    failure:(void (^)(NSError *error))failure;


#pragma mark - 重置AFHTTPSessionManager相关属性

+ (void)setAFHTTPSessionManagerProperty:(void (^)(AFHTTPSessionManager *))sessionManager;

+ (void)setRequestSerializer:(FRRequestSerializer)requestSerializer;

+ (void)setResponseSerializer:(FRResponseSerializer)responseSerializer;

+ (void)setRequestTimeoutInterval:(NSTimeInterval)time;

+ (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field;

+ (void)openNetworkActivityIndicator:(BOOL)open;

+ (void)setSecurityPolicyWithCerPath:(NSString *)cerPath validatesDomainName:(BOOL)validatesDomainName;

@end

