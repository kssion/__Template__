//
//  XPNetworkHandle.m
//  Template
//
//  Created by Chance on 16/5/26.
//  Copyright © 2016年 Chance. All rights reserved.
//

#import "XPRequestCachesHandle.h"
#import <CommonCrypto/CommonDigest.h>
#import "Function.h"

#ifdef DEBUG
#define XPLog(FORMAT, ...) fprintf(stderr,"%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define XPLog(FORMAT, ...) nil
#endif



@interface XPRequestCachesHandle () {
    NSString *_path;
}

@property (nonatomic, strong) NSURLSessionConfiguration *configuration;
@property (nonatomic, strong) NSOperationQueue *operationQueue;

@property (nonatomic, strong) NSUserDefaults *cachesInfo; /**< 缓存有效时间时间信息 */

@property (nonatomic, copy) void (^completion)(NSURLResponse *response, NSData *data, NSError *error);
@property (nonatomic, strong) NSMutableData *mutableData;

@end

@implementation XPRequestCachesHandle

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
        
        _path       = [NSString stringWithFormat:@"%@/Library/Caches/XPRequestCaches/", NSHomeDirectory()];
        _cachesInfo = [[NSUserDefaults alloc] initWithSuiteName:@"xp.network.caches"];
        
        _configuration  = [NSURLSessionConfiguration defaultSessionConfiguration];
        _operationQueue = [NSOperationQueue currentQueue];
        
        _mutableData = [NSMutableData data];
    }
    return self;
}



#pragma mark - 缓存

/** 缓存目录 */
- (NSString *)cachesPath {
    if (![[NSFileManager defaultManager] fileExistsAtPath:_path]) {
        
        NSError * __autoreleasing error;
        [[NSFileManager defaultManager] createDirectoryAtPath:_path withIntermediateDirectories:YES attributes:nil error:&error];
        
        if (error) {
            XPLog(@"缓存目录创建失败 %@", error);
        }
    }
    return _path;
}

/** 缓存文件路径 key：文件名 */
- (NSString *)cachesPathForKey:(NSString *)key {
    return [[self cachesPath] stringByAppendingString:key];
}

- (void)setCachesData:(NSData *)data forKey:(NSString *)key {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        BOOL cacheState = [data writeToFile:[self cachesPathForKey:key] atomically:YES];
        if (cacheState) {
            // 缓存持久
            [self setCacheForKey:key duration:3600 * 24];
            
            XPLog(@"本次请求已缓存！length: %@", @([data length]));
        } else {
            XPLog(@"本次请求缓存失败！length: %@.", @([data length]));
        }
    });
}

- (void)setCacheForKey:(NSString *)key duration:(NSTimeInterval)duration {
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] + duration;
    [self.cachesInfo setDouble:interval forKey:key];
}

- (BOOL)isValidCacheForKey:(NSString *)key {
    NSTimeInterval interval = [self.cachesInfo doubleForKey:key];
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:interval];
    
    NSTimeInterval t = [date timeIntervalSinceDate:[NSDate date]];
    XPLog(@"cache remain %.0fs", t);
    if (t > 0) {
        return YES;
    }
    return NO;
}

- (NSString *)getDataSign:(NSData *)data {
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return [self md5:string];
}

- (NSString *)generateCachesKeyForRequest:(NSURLRequest *)request {
    NSString *URL = @"";
    NSString *body = [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding];
    body = [body stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    if ([@[@"GET", @"HEAD", @"DELETE"] containsObject:[[request HTTPMethod] uppercaseString]]) {
        
        NSString *URLString = [[request.URL absoluteString] stringByAppendingFormat:request.URL.query ? @"&%@" : @"?%@", body];
        URL = [URLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
    } else {
        
        if (body) {
            URL = [[request.URL absoluteString] stringByAppendingFormat:@"%@", body];
        }
    }
    
    return [[self md5:URL] lowercaseString];
}

- (NSString *)md5:(NSString *)str {
    const char *cstr = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(cstr, (CC_LONG)strlen(cstr), result);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x",result[i]];
    }
    return output;
}

- (NSData *)getCachesDataWithRequest:(NSURLRequest *)request {
    NSString *key = [self generateCachesKeyForRequest:request];
    NSString *path = [self cachesPathForKey:key];
    
    /****** 缓存校验 ******/
    
    if (!fileExistsAtPath(path)) {
        XPLog(@"缓存文件不存在！");
        // 缓存不存在 重新请求
        return nil;
    }
    
    NSError *error = nil;
    NSData *sourceData = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:&error];
    
    if (error) {
        XPLog(@"加载缓存失败！%@", error);
        // 缓存文件无数据或加载失败 重新请求
        return nil;
    }
    
    if (!sourceData) {
        XPLog(@"没有缓存！");
        // 缓存文件无数据或加载失败 重新请求
        return nil;
    }
    
    if (![self isValidCacheForKey:key]) {
        XPLog(@"缓存已过期！");
        // 缓存文件无数据或加载失败 重新请求
        return nil;
    }
    return sourceData;
}

- (void)clearAllCaches {
    NSString *path = [self cachesPath];
    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
    
    if (error) {
        XPLog(@"清空缓存失败: %@", error);
    } else {
        [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:@"xp.network.caches"];
        XPLog(@"已清空缓存");
    }
}

+ (void)clearAllCaches {
    [[self handle] clearAllCaches];
}



#pragma mark - 构建请求

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

static NSMutableURLRequest *baseRequestBySerializingRequest(NSURLRequest *request, NSDictionary *parameters) {
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    NSString *query = baseQueryStringWithParameters(parameters);
    
    if ([@[@"GET", @"HEAD", @"DELETE"] containsObject:[[request HTTPMethod] uppercaseString]]) {
        if (query) {
            NSString *URLString = [[mutableRequest.URL absoluteString] stringByAppendingFormat:mutableRequest.URL.query ? @"&%@" : @"?%@", query];
            URLString = [URLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            mutableRequest.URL = [NSURL URLWithString:URLString];
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

- (NSURLRequest *)baseRequestWithMethod:(NSString *)method URLString:(NSString *)URLString parameters:(NSDictionary *)parameters error:(NSError *__autoreleasing *)error {
    NSParameterAssert(method);
    NSParameterAssert(URLString);
    
    NSURL *url = [NSURL URLWithString:[URLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    
    NSParameterAssert(url);
    
    NSMutableURLRequest *mutableRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    [mutableRequest setHTTPMethod:[method uppercaseString]];
    [mutableRequest setTimeoutInterval:10];
    
    mutableRequest = baseRequestBySerializingRequest(mutableRequest, parameters);
    
    // 获取缓存数据
    NSData *cachesData = [self getCachesDataWithRequest:mutableRequest];
    
    if (cachesData) {
        // 获取签名
        NSString *cachesKey = [self getDataSign:cachesData];
        
        // 签名带给服务器
        [mutableRequest setValue:cachesKey forHTTPHeaderField:@"sign"];
    }
    
    return mutableRequest;
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
    XPLog(@"\n请求详情 *** %@: %@\n参数: %@\n", method, URLString, parameters);
    
    self.completion = completion;
    
    NSError * __autoreleasing error;
    NSURLRequest *request = [self baseRequestWithMethod:method URLString:URLString parameters:parameters error:&error];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:_configuration delegate:self delegateQueue:_operationQueue];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request];
    [dataTask resume];
}



#pragma mark -

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error {
    if (error) {
        
        XPLog(@"请求失败 ***: %@\n", error.localizedFailureReason);
        
        NSData *cachesData = [self getCachesDataWithRequest:task.originalRequest];
        if (cachesData) {
            XPLog(@"加载本地缓存");
            XPLog(@"缓存数据 *** \n%@\n", [[NSString alloc] initWithData:cachesData encoding:NSUTF8StringEncoding]);
            error = nil;
        }
        if (self.completion) self.completion(task.response, cachesData, error);
        
    } else {
        
        NSHTTPURLResponse *httpResponse = (id)task.response;
        
        NSString *sign = [httpResponse.allHeaderFields valueForKey:@"sign_code"];
        NSData *data = nil;
        
        if ([@"ok" isEqualToString:sign]) { // 缓存有效
            data = [self getCachesDataWithRequest:task.originalRequest];
            
            XPLog(@"加载本地缓存");
            XPLog(@"缓存数据 *** \n%@\n", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            
        } else {
            
            data = [self.mutableData copy];
            
            NSString *key = [self generateCachesKeyForRequest:task.originalRequest];
            [self setCachesData:data forKey:key];
            
            XPLog(@"返回数据 *** \n%@\n", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        }
        
        if (self.completion) self.completion(task.response, data, error);
    }
    
    [self.mutableData setLength:0];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    [self.mutableData setLength:0];
    
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    [self.mutableData appendData:data];
}



#pragma mark -

- (void)coreRequestWithURL:(NSString *)URLString HTTPMethod:(NSString *)method parameters:(NSDictionary *)parameters
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
                XPLog(@"JSON数据解析失败！%@", error);
                if (failure) failure(response, error);
            } else {
                if (success) success(response, object);
            }
        }
        if (complete) complete();
    }];
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
