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

- (void)setLon:(CGFloat)lon {
    _lon = round(lon*1000000)/1000000;
}

- (void)setLat:(CGFloat)lat {
    _lat = round(lat*1000000)/1000000;
}

@end

 