//
//  JXAccount.h
//  Fellow
//
//  Created by mac on 16/3/15.
//  Copyright © 2016年 mac. All rights reserved.
//

// 标题数组
#define JXSexs @[@"男", @"女"]

#import <Foundation/Foundation.h>

@interface JXAccount : NSObject <NSCoding>

@property (nonatomic, copy) NSString *telephone;

@property (nonatomic, copy) NSString *token;

@end
