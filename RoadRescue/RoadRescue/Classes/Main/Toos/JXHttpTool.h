//
//  JXHttpTool.h
//  JMXMiJia
//
//  Created by 张盼盼 on 16/1/15.
//  Copyright © 2016年 mac. All rights reserved.
//  封装AFN

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

@interface JXHttpTool : NSObject

+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

+ (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

+ (void)post:(NSString *)url params:(NSDictionary *)params constructingWithBlock:(void(^)(id<AFMultipartFormData> formData))block success:(void(^)(id json))success failure:(void (^)(NSError *error))failure;
@end
