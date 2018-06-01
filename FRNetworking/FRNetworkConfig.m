//
//  FRNetworkConfig.m
//  FRNetworking-Demo
//
//  Created by mac on 2018/5/20.
//  Copyright © 2018年 fanrongQu. All rights reserved.
//

#import "FRNetworkConfig.h"

@implementation FRNetworkConfig
#pragma mark - 单例对象
static id _instance;
    
+ (FRNetworkConfig *)shareConfig {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

-(id)copyWithZone:(NSZone *)zone {
    return _instance;
}

-(id)mutableCopyWithZone:(NSZone *)zone {
    return _instance;
}

@end
