//
//  XPNetworkHandle.h
//  Template
//
//  Created by Chance on 16/5/26.
//  Copyright © 2016年 Chance. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  带缓存的网络请求
 */
@interface XPRequestCachesHandle : NSObject <NSURLSessionDataDelegate>

+ (XPRequestCachesHandle *)handle;



#pragma mark - 

/**
 *  清空本地的网络请求缓存
 */
+ (void)clearAllCaches;



#pragma mark -
// 缓存请求 在/Library/Caches/XPRequestCaches文件夹下

/**
 *  通用请求 XPRequestHandle
 *
 *  @param URLString  请求URL
 *  @param method     请求方法
 *  @param parameters 请求参数
 *  @param success    成功
 *  @param failure    失败
 *  @param complete   完成
 */
- (void)requestWithURL:(NSString *)URLString HTTPMethod:(NSString *)method parameters:(NSDictionary *)parameters
               success:(void (^)(NSURLResponse *response, id object))success
               failure:(void (^)(NSURLResponse *response, NSError *error))failure
               complete:(void (^)())complete;


#pragma mark -

/**
 *  HEAD请求
 */
+ (void)HEAD:(NSString *)URLString parameters:(id)parameters completion:(void (^)(NSURLResponse *response, NSError *error))completion;

/**
 *  GET请求
 */
+ (void)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLResponse *response, id object))success failure:(void (^)(NSURLResponse *response, NSError *error))failure complete:(void (^)())complete;

/**
 *  POST请求
 */
+ (void)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLResponse *response, id object))success failure:(void (^)(NSURLResponse *response, NSError *error))failure complete:(void (^)())complete;

/**
 *  PUT请求
 */
+ (void)PUT:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLResponse *response, id object))success failure:(void (^)(NSURLResponse *response, NSError *error))failure complete:(void (^)())complete;

/**
 *  PATCH请求
 */
+ (void)PATCH:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLResponse *response, id object))success failure:(void (^)(NSURLResponse *response, NSError *error))failure complete:(void (^)())complete;

/**
 *  DELETE请求
 */
+ (void)DELETE:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLResponse *response, id object))success failure:(void (^)(NSURLResponse *response, NSError *error))failure complete:(void (^)())complete;

@end
