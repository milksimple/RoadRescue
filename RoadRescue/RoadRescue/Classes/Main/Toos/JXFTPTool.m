//
//  JXFTPTool.m
//  JXFTPGetDemo
//
//  Created by mac on 16/6/28.
//  Copyright © 2016年 mac. All rights reserved.
//



#import "JXFTPTool.h"

typedef void (^JXProgressBlock)(NSUInteger totalBytesWritten, CGFloat progress);
typedef void (^JXCompleteBlock)(NSString *filePath);
typedef void (^JXErrorBlock)(NSString *error);

@interface JXFTPTool() <NSStreamDelegate>

/** 读取流 */
@property (nonatomic, strong, readwrite) NSInputStream *networkStream;
/** 文件下载路径 */
@property (nonatomic, copy,   readwrite) NSString *filePath;
/** 写入流 */
@property (nonatomic, strong, readwrite) NSOutputStream *fileStream;
/** 要下载的文件大小, 要开始下载后才能获得 */
@property (nonatomic, assign) NSUInteger fileSize;
/** 已经写入文件的总大小 */
@property (nonatomic, assign) NSUInteger totalBytesWritten;
/** 下载地址 */
@property (nonatomic, copy) NSString *url;
/** 服务器用户名 */
@property (nonatomic, copy) NSString *username;
/** 服务器密码 */
@property (nonatomic, copy) NSString *password;
/** 要从服务器的文件的哪个字节位置开始读 */
@property (nonatomic, assign) NSUInteger offset;
/** 下载进度block */
@property (nonatomic, copy) JXProgressBlock progress;
/** 下载完成block */
@property (nonatomic, copy) JXCompleteBlock complete;
/** 下载错误block */
@property (nonatomic, copy) JXErrorBlock error;

@end

@implementation JXFTPTool

#pragma mark - lazy
- (BOOL)isReceiving
{
    return (self.networkStream != nil);
}

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
- (void)download:(NSString *)url username:(NSString *)username password:(NSString *)password progress:(void (^)(NSUInteger totalBytesWritten, CGFloat progress))downloadProgress complete:(void (^)(NSString *filePath))complete error:(void (^)(NSString *error))error

{
    self.url = url;
    NSString *filename = url.lastPathComponent;
    self.filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:filename];
    self.username = username;
    self.password = password;
    self.offset = [self fileSizeWithDownLoadFileName:filename]; // 这里应该计算已下载文件大小
    self.totalBytesWritten = self.offset;
    
    self.progress = downloadProgress;
    self.complete = complete;
    self.error = error;
    
    JXLog(@"self.networkStream = %@", self.networkStream);
    if (self.isReceiving) return;
    // 开启下载
    [self startReceive];
}

/**
 *  通过要下载的文件名，获得文件大小(默认该文件在tmp文件夹中)
 *
 *  @param filename 要下载的文件名
 *
 *  @return 已下载的文件大小
 */
- (NSUInteger)fileSizeWithDownLoadFileName:(NSString *)filename {
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:filename];
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    NSDictionary *attrs = [mgr attributesOfItemAtPath:filePath error:nil];
    if (attrs) {
        return [attrs[NSFileSize] unsignedIntegerValue];
    }
    return 0;
}

- (void)startReceive
{
    NSURL *url = [NSURL URLWithString:self.url];
    
    self.fileStream = [NSOutputStream outputStreamToFileAtPath:self.filePath append:YES];
    [self.fileStream open];
    
    // Open a CFFTPStream for the URL.
    
    self.networkStream = CFBridgingRelease(
                                           CFReadStreamCreateWithFTPURL(NULL, (__bridge CFURLRef) url)
                                           );
    
    // 设置账号密码
    [self.networkStream setProperty:self.username forKey:(id)kCFStreamPropertyFTPUserName];
    [self.networkStream setProperty:self.password forKey:(id)kCFStreamPropertyFTPPassword];
    [self.networkStream setProperty:@(YES) forKey:(id)kCFStreamPropertyFTPFetchResourceInfo];
    [self.networkStream setProperty:@(self.offset) forKey:(id)kCFStreamPropertyFTPFileTransferOffset];
    self.networkStream.delegate = self;
    [self.networkStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
    [self.networkStream open];
    
}

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{
    
    switch (eventCode) {
        case NSStreamEventOpenCompleted: {
            //            [self updateStatus:@"Opened connection"];
            
        } break;
            
        case NSStreamEventHasBytesAvailable: {
            self.fileSize = [[self.networkStream propertyForKey:(id)kCFStreamPropertyFTPResourceSize] unsignedIntegerValue];
            NSInteger       bytesRead;
            uint8_t         buffer[32768];
            
            bytesRead = [self.networkStream read:buffer maxLength:sizeof(buffer)];
            if (bytesRead == -1) {
                [self stopReceiveWithStatus:@"Network read error"];
            } else if (bytesRead == 0) { // 下载完成
                if (self.complete) {
                    self.complete(self.filePath);
                }
//                // 执行完block后删除刚才下载的文件
//                NSFileManager *mgr = [NSFileManager defaultManager];
//                [mgr removeItemAtPath:self.filePath error:nil];
//                
                [self stopReceiveWithStatus:nil];
                
            } else {
                NSInteger   bytesWritten;
                NSInteger   bytesWrittenSoFar;
                
                // Write to the file.
                bytesWrittenSoFar = 0;
                do {
                    bytesWritten = [self.fileStream write:&buffer[bytesWrittenSoFar] maxLength:(NSUInteger) (bytesRead - bytesWrittenSoFar)];
                    
                    if (bytesWritten == -1) {
                        [self stopReceiveWithStatus:@"File write error"];
                        break;
                    } else {
                        bytesWrittenSoFar += bytesWritten;
                        self.totalBytesWritten += bytesWritten;
                        self.progress(self.totalBytesWritten, 1.0 * self.totalBytesWritten / self.fileSize);
                    }
                } while (bytesWrittenSoFar != bytesRead);
                
            }
        } break;
        case NSStreamEventHasSpaceAvailable: {
            // should never happen for the output stream
        } break;
        case NSStreamEventErrorOccurred: {
            [self stopReceiveWithStatus:@"Stream open error"];
        } break;
        case NSStreamEventEndEncountered: {
            // ignore
        } break;
        default: {
            
        } break;
    }
    
}

/**
 *  停止下载
 *
 *  @param block 停止后返回的block，totalBytesWritten:参数返回当前已下载的大小, fileSize:要下载的文件的总大小
 */
- (void)closeWithBlock:(void(^)(NSUInteger totalBytesWritten, NSUInteger fileSize))block {
    if (block) {
        block(self.totalBytesWritten, self.fileSize);
    }
    
    [self stopReceiveWithStatus:nil];
}

- (void)stopReceiveWithStatus:(NSString *)error
{
    if (self.networkStream != nil) {
        [self.networkStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        self.networkStream.delegate = nil;
        [self.networkStream close];
        self.networkStream = nil;
    }
    if (self.fileStream != nil) {
        [self.fileStream close];
        self.fileStream = nil;
    }
    
    self.filePath = nil;
    self.totalBytesWritten = 0;
    self.fileSize = 0;
    self.offset = 0;
    
    // 调用报错block
    if (error.length && self.error) {
        self.error(error);
    }
}

@end
