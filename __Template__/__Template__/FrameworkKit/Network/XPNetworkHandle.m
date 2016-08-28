//
//  XPNetworkHandle.m
//  Template
//
//  Created by Chance on 16/5/26.
//  Copyright © 2016年 Chance. All rights reserved.
//

#import "XPNetworkHandle.h"

#ifdef DEBUG
#define XPLog(FORMAT, ...) fprintf(stderr,"%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define XPLog(FORMAT, ...) nil
#endif


@interface XPNetworkHandle ()

@property (nonatomic, strong) NSURLSessionConfiguration *configuration;
@property (nonatomic, strong) NSOperationQueue *operationQueue;

@end

@implementation XPNetworkHandle

+ (instancetype)handle {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
        _configuration  = [NSURLSessionConfiguration defaultSessionConfiguration];
        _operationQueue = [NSOperationQueue currentQueue];
    }
    return self;
}

#pragma mark - Base
static NSString *baseQueryStringWithParameters(NSDictionary *parameters) {
    __block NSMutableString *query = [NSMutableString string];
    if ([parameters isKindOfClass:[NSDictionary class]]) {
        [parameters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [query appendFormat:@"%@=%@&", key, obj];
        }];
        return [query substringToIndex:[query length] - 1];
    }
    return nil;
}

static NSURLRequest *baseRequestBySerializingRequest(NSURLRequest *request, NSDictionary *parameters) {
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    NSString *query = baseQueryStringWithParameters(parameters);
    
    if ([@[@"GET", @"HEAD", @"DELETE"] containsObject:[[request HTTPMethod] uppercaseString]]) {
        if (query) {
            mutableRequest.URL = [NSURL URLWithString:[[mutableRequest.URL absoluteString] stringByAppendingFormat:mutableRequest.URL.query ? @"&%@" : @"?%@", query]];
        }
    } else {
        if (![mutableRequest valueForHTTPHeaderField:@"Content-Type"]) {
            [mutableRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        }
        if (query) {
            [mutableRequest setHTTPBody:[query dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    return mutableRequest;
}

- (NSURLRequest *)structureRequestWithMethod:(NSString *)method URLString:(NSString *)URLString parameters:(NSDictionary *)parameters error:(NSError *__autoreleasing *)error {
    NSParameterAssert(method);
    NSParameterAssert(URLString);
    
    NSURL *url = [NSURL URLWithString:[URLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    
    NSParameterAssert(url);
    
    NSMutableURLRequest *mutableRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    [mutableRequest setHTTPMethod:[method uppercaseString]];
    [mutableRequest setTimeoutInterval:10];
    
    NSURLRequest *request = baseRequestBySerializingRequest(mutableRequest, parameters);
    
    return request;
}

#pragma mark - Core Request
/**
 *  核心请求
 *
 *  @param URLString  请求URL
 *  @param method     请求方法
 *  @param parameters 参数
 *  @param completion 完成Block
 */
- (void)coreRequestWithURL:(NSString *)URLString HTTPMethod:(NSString *)method parameters:(NSDictionary *)parameters completion:(void (^)(NSURLResponse *response, NSData *data, NSError *error))completion {
    NSLog(@"%@:%@\n%@", method, URLString, parameters);
    
    NSError * __autoreleasing error;
    NSURLRequest *request = [self structureRequestWithMethod:method URLString:URLString parameters:parameters error:&error];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:_configuration delegate:nil delegateQueue:_operationQueue];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (completion) completion(response, data, error);
    }];
    [dataTask resume];
}

- (void)requestOriginalWithURL:(NSString *)URLString HTTPMethod:(NSString *)method parameters:(NSDictionary *)parameters
                       success:(void (^)(NSURLResponse *response, NSData *data))success
                       failure:(void (^)(NSURLResponse *response, NSError *error))failure
                      complete:(void (^)())complete {
    [self coreRequestWithURL:URLString HTTPMethod:method parameters:parameters completion:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            if (failure) failure(response, error);
        } else {
            if (success) success(response, data);
        }
        if (complete) complete();
    }];
}

#pragma mark - Currency Request
- (void)requestWithURL:(NSString *)URLString HTTPMethod:(NSString *)method parameters:(NSDictionary *)parameters
               success:(void (^)(NSURLResponse *response, id object))success
               failure:(void (^)(NSURLResponse *response, NSError *error))failure
               complete:(void (^)())complete {
    [self coreRequestWithURL:URLString HTTPMethod:method parameters:parameters completion:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            if (failure) failure(response, error);
        } else {
            
            NSError * __autoreleasing error;
            id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            
            if (error) {
                if (failure) failure(response, error);
            } else {
                if (success) success(response, object);
            }
        }
        if (complete) complete();
    }];
}

#pragma mark -
+ (void)uploadImageWithURL:(NSString *)URLString images:(NSDictionary *)images parameters:(NSDictionary *)parameters {
    
}

#pragma mark -
+ (void)HEAD:(NSString *)URLString parameters:(id)parameters completion:(void (^)(NSURLResponse *response, NSError *error))completion {
    [[self handle] coreRequestWithURL:URLString HTTPMethod:@"HEAD" parameters:parameters completion:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (completion) completion(response, error);
    }];
}

+ (void)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLResponse *response, id object))success failure:(void (^)(NSURLResponse *response, NSError *error))failure complete:(void (^)())complete {
    [[self handle] requestWithURL:URLString HTTPMethod:@"GET" parameters:parameters success:success failure:failure complete:complete];
}

+ (void)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLResponse *response, id object))success failure:(void (^)(NSURLResponse *response, NSError *error))failure complete:(void (^)())complete {
    [[self handle] requestWithURL:URLString HTTPMethod:@"POST" parameters:parameters success:success failure:failure complete:complete];
}

+ (void)PUT:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLResponse *response, id object))success failure:(void (^)(NSURLResponse *response, NSError *error))failure complete:(void (^)())complete {
    [[self handle] requestWithURL:URLString HTTPMethod:@"PUT" parameters:parameters success:success failure:failure complete:complete];
}

+ (void)PATCH:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLResponse *response, id object))success failure:(void (^)(NSURLResponse *response, NSError *error))failure complete:(void (^)())complete {
    [[self handle] requestWithURL:URLString HTTPMethod:@"PATCH" parameters:parameters success:success failure:failure complete:complete];
}

+ (void)DELETE:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLResponse *response, id object))success failure:(void (^)(NSURLResponse *response, NSError *error))failure complete:(void (^)())complete {
    [[self handle] requestWithURL:URLString HTTPMethod:@"DELETE" parameters:parameters success:success failure:failure complete:complete];
}

@end
