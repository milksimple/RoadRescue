//
//  JXOrder.m
//  RoadRescueTeam
//
//  Created by mac on 16/6/2.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "JXOrder.h"
#import <MJExtension.h>


@implementation JXOrder

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"itemList":[JXRescueItem class]};
}

@end
