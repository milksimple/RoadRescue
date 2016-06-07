//
//  JXOrderDetail.h
//  RoadRescue
//
//  Created by mac on 16/6/3.
//  Copyright © 2016年 mac. All rights reserved.
//  订单详情

/*
 itemList: 救援项目[
 {
 itemType: 项目类型<1-燃油耗尽>,
 itemClass: 项目类别(itemType为1时)<0-柴油,93-汽油,97-汽油>,
 itemCnt: 份数
 }
 ]
 */

#import <Foundation/Foundation.h>
#import "JXRescueItem.h"

@interface JXOrderDetail : NSObject
/** 订单号 */
@property (nonatomic, copy) NSString *orderNum;
/** 下单人手机号码 */
@property (nonatomic, copy) NSString *orderer;
/** 经度 */
@property (nonatomic, assign) CGFloat lon;
/** 纬度 */
@property (nonatomic, assign) CGFloat lat;
/** 下单位置简称 */
@property (nonatomic, copy) NSString *addressShort;
/** 下单位置描述 */
@property (nonatomic, copy) NSString *addressDes;
/** 救援项目类型 */
@property (nonatomic, assign) NSInteger itemTypes;
/** 救援项目数组，里面是JXRescueItem对象 */
@property (nonatomic, strong) NSArray *itemList;
/** 总价 */
@property (nonatomic, assign) CGFloat totalPrice;
/** 救援状态<-1-订单已取消,  0-已下单,1-已接单,2-完成等待付款,9-完成> */
@property (nonatomic, assign) NSInteger itemStatus;
/** 救援队mobile */
@property (nonatomic, copy) NSString *mobile;
/** 下单时间 */
@property (nonatomic, copy) NSString *title;
/** 救援指数 */
@property (nonatomic, assign) NSInteger rescueIndex;
/** 事故描述 */
@property (nonatomic, copy) NSString *accidentDes;

@end
