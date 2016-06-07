//
//  JXOrderDetail.m
//  RoadRescue
//
//  Created by mac on 16/6/3.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "JXOrderDetail.h"
#import <MJExtension.h>

@implementation JXOrderDetail

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"itemList":[JXRescueItem class]};
}

@end

 