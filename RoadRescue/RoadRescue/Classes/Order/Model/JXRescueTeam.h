//
//  JXRescueTeam.h
//  RoadRescue
//
//  Created by mac on 16/7/6.
//  Copyright © 2016年 mac. All rights reserved.
//  救援队信息

#import <Foundation/Foundation.h>

@interface JXRescueTeam : NSObject

/** 救援队名称 */
@property (nonatomic, copy) NSString *name;
/** 救援队电话 */
@property (nonatomic, copy) NSString *mobile;

@end
