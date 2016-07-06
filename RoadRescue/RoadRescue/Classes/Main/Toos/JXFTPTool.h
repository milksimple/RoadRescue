//
//  JXFTPTool.h
//  JXFTPGetDemo
//
//  Created by mac on 16/6/28.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JXFTPTool : NSObject

/** 是否正在下载 */
@property (nonatomic, assign, readonly ) BOOL isReceiving;

/**
 *  下载文件
 *
 *  @param url              下载文件的ftp地址
 *  @param username         ftp服务器用户名
 *  @param password         ftp服务器密码
 *  @param downloadProgress 下载进度block
 *  @param complete         下载完成block
 *  @param error            下载出错block
 */
- (void)download:(NSString *)url username:(NSString *)username password:(NSString *)password progress:(void (^)(NSUInteger totalBytesWritten, CGFloat progress))downloadProgress complete:(void (^)(NSString *filePath))complete error:(void (^)(NSString *error))error;

/**
 *  停止下载
 *
 *  @param block 停止后返回的block，totalBytesWritten:参数返回当前已下载的大小, fileSize:要下载的文件的总大小
 */
- (void)closeWithBlock:(void(^)(NSUInteger totalBytesWritten, NSUInteger fileSize))block;

/**
 *  通过要下载的文件名，获得文件大小(默认该文件在tmp文件夹中)
 *
 *  @param filename 要下载的文件名
 *
 *  @return 已下载的文件大小
 */
- (NSUInteger)fileSizeWithDownLoadFileName:(NSString *)filename;

@end
