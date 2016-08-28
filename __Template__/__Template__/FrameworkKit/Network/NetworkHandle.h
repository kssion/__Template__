//
//  NetworkHandle.h
//  __Template__
//
//  Created by Chance on 16/8/12.
//  Copyright © 2016年 Chance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkConfig.h"

@interface NetworkHandle : NSObject

+ (void)postPHPWithURL:(NSString *)url appName:(NSString *)appName className:(NSString *)className params:(NSDictionary *)parameters
               success:(void (^)(NSURLResponse *response, NSData *data))success
               failure:(void (^)(NSURLResponse *response, NSError *error))failure
              complete:(void (^)())complete;

@end
