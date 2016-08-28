//
//  UITableView+XPNetworkHandle.m
//  Honda
//
//  Created by Chance on 16/8/25.
//  Copyright © 2016年 Chance. All rights reserved.
//

#import "UITableView+XPNetworkHandle.h"
#import <objc/runtime.h>

@interface UITableView ()
@property (nonatomic, copy) NSString *URLString;
@property (nonatomic, copy) NSMutableDictionary *parameters;
@property (nonatomic, copy) void (^success)(NSURLResponse *, id, void (^)(NSArray *));
@property (nonatomic, copy) void (^failure)(NSURLResponse *, NSError *);
@property (nonatomic, copy) void (^complete)();

@end

@implementation UITableView (XPNetworkHandle)

#pragma mark - 分页信息

- (NSInteger)startIndex {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}
- (void)setStartIndex:(NSInteger)startIndex {
    objc_setAssociatedObject(self, @selector(startIndex), @(startIndex), OBJC_ASSOCIATION_RETAIN);
}

- (NSInteger)pageIndex {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}
- (void)setPageIndex:(NSInteger)pageIndex {
    objc_setAssociatedObject(self, @selector(pageIndex), @(pageIndex), OBJC_ASSOCIATION_RETAIN);
}

- (NSInteger)pageSize {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}
- (void)setPageSize:(NSInteger)pageSize {
    objc_setAssociatedObject(self, @selector(pageSize), @(pageSize), OBJC_ASSOCIATION_RETAIN);
}

- (NSString *)pageIndexKey {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setPageIndexKey:(NSString *)pageIndexKey {
    objc_setAssociatedObject(self, @selector(pageIndexKey), pageIndexKey, OBJC_ASSOCIATION_COPY);
}

- (NSString *)pageSizeKey {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setPageSizeKey:(NSString *)pageSizeKey {
    objc_setAssociatedObject(self, @selector(pageSizeKey), pageSizeKey, OBJC_ASSOCIATION_COPY);
}

- (NSMutableArray *)dataArray {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setDataArray:(NSMutableArray *)dataArray {
    objc_setAssociatedObject(self, @selector(dataArray), dataArray, OBJC_ASSOCIATION_ASSIGN);
}


#pragma mark - 请求信息

- (NSString *)URLString {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setURLString:(NSString *)URLString {
    objc_setAssociatedObject(self, @selector(URLString), URLString, OBJC_ASSOCIATION_COPY);
}

- (NSMutableDictionary *)parameters {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setParameters:(NSMutableDictionary *)parameters {
    objc_setAssociatedObject(self, @selector(parameters), parameters, OBJC_ASSOCIATION_COPY);
}

- (void (^)(NSURLResponse *, id, void (^)(NSArray *)))success {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setSuccess:(void (^)(NSURLResponse *, id, void (^)(NSArray *)))success {
    objc_setAssociatedObject(self, @selector(success), success, OBJC_ASSOCIATION_COPY);
}

- (void (^)(NSURLResponse *, NSError *))failure {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setFailure:(void (^)(NSURLResponse *, NSError *))failure {
    objc_setAssociatedObject(self, @selector(failure), failure, OBJC_ASSOCIATION_COPY);
}

- (void (^)())complete {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setComplete:(void (^)())complete {
    objc_setAssociatedObject(self, @selector(complete), complete, OBJC_ASSOCIATION_COPY);
}


#pragma mark - 添加上拉和下拉

- (void)addHeaderFooterRefresh {
    
    __weak __typeof(self) _self = self;
    
    [self addHeaderWithCallback:^{
        _self.pageIndex = _self.startIndex - 1;
        [_self requestData];
    }];
    
    [self addFooterWithCallback:^{
        [_self requestData];
    }];
}

- (void)setPageSize:(NSInteger)pageSize startPage:(NSInteger)startPage {
    self.pageSize = pageSize;
    self.startIndex = startPage;
}

- (void)setPageIndexKey:(NSString *)indexKey pageSizeKey:(NSString *)sizeKey {
    self.pageIndexKey = indexKey;
    self.pageSizeKey = sizeKey;
}

- (void)setPageStartIndex:(NSInteger)startIndex pageSize:(NSInteger)pageSize pageIndexKey:(NSString *)pageIndexKey pageSizeKey:(NSString *)pageSizeKey {
    
    self.startIndex = startIndex;
    self.pageSize = pageSize;
    self.pageIndexKey = pageIndexKey;
    self.pageSizeKey = pageSizeKey;
}


#pragma mark -

- (void)requestData {
    
    NSAssert(self.pageIndexKey, @"pageIndex Key not set!");
    NSAssert(self.pageSizeKey, @"pageSize Key not set!");
    
    __weak __typeof(self) _self = self;
    
    [self.parameters setObject:@(self.pageIndex + 1) forKey:self.pageIndexKey];
    [self.parameters setObject:@(self.pageSize) forKey:self.pageSizeKey];
    
    [XPNetworkHandle GET:self.URLString parameters:self.parameters success:^(NSURLResponse *response, id object) {
        
        if (_self.success) {
            
            _self.success(response, object, ^(NSArray *list){
                if (list && [list isKindOfClass:[NSArray class]] && [list count] > 0) {
                    
                    _self.pageIndex ++;
                    
                    if (_self.pageIndex == _self.startIndex) {
                        [_self.dataArray removeAllObjects];
                    }
                    [_self.dataArray addObjectsFromArray:list];
                    
                    [_self reloadData];
                }
            });
        }
        
    } failure:^(NSURLResponse *response, NSError *error) {
        
    } complete:^{
        [_self headerEndRefreshing];
        [_self footerEndRefreshing];
    }];
}


#pragma mark -

- (void)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLResponse *, id, void (^)(NSArray *)))success failure:(void (^)(NSURLResponse *, NSError *))failure complete:(void (^)())complete
{
    self.URLString = URLString;
    self.parameters = [parameters mutableCopy];
    self.success = success;
    self.failure = failure;
    self.complete = complete;
    
    [self requestData];
}

- (void)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLResponse *, id, void (^)(NSArray *)))success failure:(void (^)(NSURLResponse *, NSError *))failure complete:(void (^)())complete
{
    self.URLString = URLString;
    self.parameters = [parameters mutableCopy];
    self.success = success;
    self.failure = failure;
    self.complete = complete;
    
    [self requestData];
}


@end
