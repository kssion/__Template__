//
//  UITableView+XPNetworkHandle.h
//  Honda
//
//  Created by Chance on 16/8/25.
//  Copyright © 2016年 Chance. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  分页列表扩展
 */
@interface UITableView (XPNetworkHandle)
@property (nonatomic, readonly) NSInteger pageIndex; /**< 当前页索引 */

@property (nonatomic, assign) NSInteger startIndex; /**< 开始页索引 */
@property (nonatomic, assign) NSInteger pageSize; /**< 页大小 */

@property (nonatomic, copy) NSString *pageIndexKey; /**< 页索引 请求参数名 */
@property (nonatomic, copy) NSString *pageSizeKey; /**< 页大小 请求参数名 */

@property (nonatomic, weak) NSMutableArray *dataArray; /**< 数据源引用 */


/**
 *  添加分页 上拉和下拉
 */
- (void)addHeaderFooterRefresh;

/**
 *  设置分页信息
 *
 *  @param startPage 起始页码
 *  @param pageSize  页大小
 */
- (void)setPageSize:(NSInteger)pageSize startPage:(NSInteger)startPage;

/**
 *  设置请求参数中页索引和页大小的参数名
 *
 *  @param indexKey 页索引参数名
 *  @param sizeKey  页大小参数名
 */
- (void)setPageIndexKey:(NSString *)indexKey pageSizeKey:(NSString *)sizeKey;

/**
 *  设置分页信息
 *
 *  @param startIndex   起始页码
 *  @param size         每页大小
 *  @param pageIndexKey 页索引参数名
 *  @param pageSizeKey  页大小参数名
 */
- (void)setPageStartIndex:(NSInteger)startIndex pageSize:(NSInteger)size pageIndexKey:(NSString *)pageIndexKey pageSizeKey:(NSString *)pageSizeKey;


#pragma mark - 网络请求

/**
 *  GET请求
 */
- (void)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLResponse *response, id object, void(^addData)(NSArray *list)))success failure:(void (^)(NSURLResponse *response, NSError *error))failure complete:(void (^)())complete;

/**
 *  POST请求
 */
- (void)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLResponse *response, id object, void(^addData)(NSArray *list)))success failure:(void (^)(NSURLResponse *response, NSError *error))failure complete:(void (^)())complete;


@end
