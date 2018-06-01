//
//  FRNetworkConfig.h
//  FRNetworking-Demo
//
//  Created by mac on 2018/5/20.
//  Copyright © 2018年 fanrongQu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FRNetworkConfig : NSObject

+ (FRNetworkConfig *)shareConfig;

/**
 公共请求主机地址，默认为空
 */
@property(nonatomic, strong)NSString *hostURL;
/**
 特殊主机地址，默认为空
 key为具体地址，value为主机地址
 */
@property(nonatomic, strong)NSDictionary *hostURLDict;

/**
 公共请求参数，默认为空
 */
@property(nonatomic, strong)NSDictionary *baseParameters;


@end
