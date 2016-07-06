//
//  JXSkin.h
//  RoadRescue
//
//  Created by mac on 16/6/29.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JXSkin : NSObject

/** 中文名称 */
@property (nonatomic, copy) NSString *title;
/** 英文名(下载包名) */
@property (nonatomic, copy) NSString *packageName;
/** 图标 */
@property (nonatomic, copy) NSString *frontcover;
/** 下载地址 */
@property (nonatomic, copy) NSString *skinPath;
/** 皮肤大小 */
@property (nonatomic, assign) NSUInteger size;

@end
