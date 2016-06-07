//
//  JXAccountTool.m
//  JMXMiJia
//
//  Created by mac on 16/1/12.
//  Copyright © 2016年 mac. All rights reserved.
//

// 账号的存储路径
#define JXAccountPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.archive"]

#import "JXAccountTool.h"

@implementation JXAccountTool
/**
 *  存储账号信息
 *
 *  @param account 账号模型
 */
+ (void)saveAccount:(JXAccount *)account
{
    // 自定义对象的存储必须用NSKeyedArchiver，不再有什么writeToFile方法
    [NSKeyedArchiver archiveRootObject:account toFile:JXAccountPath];
}

/**
 *  返回当前登录的账号信息, 如果不存在返回nil
 */
+ (JXAccount *)account {
    // 加载模型
    JXAccount *account = [NSKeyedUnarchiver unarchiveObjectWithFile:JXAccountPath];
    
    return account;
}


@end
