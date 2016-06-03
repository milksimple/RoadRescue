//
//  JXOrder.h
//  RoadRescueTeam
//
//  Created by mac on 16/6/2.
//  Copyright © 2016年 mac. All rights reserved.
//  订单

#import <Foundation/Foundation.h>
#import "JXRescueItem.h"

@interface JXOrder : NSObject
/** 订单号 */
@property (nonatomic, copy) NSString *orderNum;
/** 下单人手机号码 */
@property (nonatomic, copy) NSString *orderer;
/** 下单位置-经度, 保留小数点后6位 */
@property (nonatomic, assign) CGFloat lon;
/** 下单位置-纬度 */
@property (nonatomic, assign) CGFloat lat;
/** 下单位置简称 */
@property (nonatomic, copy) NSString *addressShort;
/** 下单位置描述 */
@property (nonatomic, copy) NSString *addressDes;
/** 救援项目类型 */
@property (nonatomic, assign) NSInteger itemTypes;
/** 救援项目数组 */
@property (nonatomic, strong) NSArray *itemList;
/** 总价 */
@property (nonatomic, assign) CGFloat totalPrice;
/** 救援状态<0-已下单,1-已接单,2-完成等待付款,9-完成> */
@property (nonatomic, assign) NSInteger itemStatus;
/** 救援队mobile */
@property (nonatomic, copy) NSString *mobile;
/** <救援队名称, 下单时间> */
@property (nonatomic, copy) NSString *title;
/**  救援指数*/
@property (nonatomic, assign) NSInteger rescueIndex;

@end