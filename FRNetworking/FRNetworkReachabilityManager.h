//
//  FRNetworkReachabilityManager.h
//  FRNetworking-Demo
//
//  Created by mac on 2018/5/30.
//  Copyright © 2018年 fanrongQu. All rights reserved.
//
//   判断网络状态

#import <Foundation/Foundation.h>

#if __has_include(<AFNetworking/AFNetworking.h>)

#import <AFNetworking/AFNetworkReachabilityManager.h>
#else

#import "AFNetworkReachabilityManager.h"
#endif

@interface FRNetworkReachabilityManager : NSObject

+ (BOOL)isNetwork;

+ (BOOL)isWWANNetwork;

+ (BOOL)isWiFiNetwork;

/**
 *  判端网络状态
 *
 *  @param block 网络状态
 */
+ (void)networkReachability:(void (^)(AFNetworkReachabilityStatus status))block;

+ (void)stopMonitoring;


@end
