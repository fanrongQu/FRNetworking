//
//  FRNetworkReachabilityManager.m
//  FRNetworking-Demo
//
//  Created by mac on 2018/5/30.
//  Copyright © 2018年 fanrongQu. All rights reserved.
//

#import "FRNetworkReachabilityManager.h"

@implementation FRNetworkReachabilityManager


+ (BOOL)isNetwork {
    return [AFNetworkReachabilityManager sharedManager].reachable;
}

+ (BOOL)isWWANNetwork {
    return [AFNetworkReachabilityManager sharedManager].reachableViaWWAN;
}

+ (BOOL)isWiFiNetwork {
    return [AFNetworkReachabilityManager sharedManager].reachableViaWiFi;
}

+ (void)networkReachability:(void (^)(AFNetworkReachabilityStatus status))block {
    // 检测网络状态
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (block) {
            block(status);
        }
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

+ (void)stopMonitoring {
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}


@end
