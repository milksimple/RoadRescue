//
//  JXHttpTool.m
//  JMXMiJia
//
//  Created by 张盼盼 on 16/1/15.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "JXHttpTool.h"

@implementation JXHttpTool

+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure {
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.requestSerializer.timeoutInterval = 12;
    [mgr GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

+ (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure {
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
//    JXLog(@"HTTPRequestHeaders = %@", mgr.requestSerializer.HTTPRequestHeaders);
//    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
//    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    mgr.requestSerializer.timeoutInterval = 12;
    [mgr POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)post:(NSString *)url params:(NSDictionary *)params constructingWithBlock:(void(^)(id<AFMultipartFormData> formData))block success:(void(^)(id json))success failure:(void (^)(NSError *error))failure {
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
//    mgr.requestSerializer.timeoutInterval = 10;
    [mgr POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (block) {
            block(formData);
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}
@end
