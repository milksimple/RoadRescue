//
//  JXRescueItem.h
//  RoadRescueTeam
//
//  Created by mac on 16/6/2.
//  Copyright © 2016年 mac. All rights reserved.
//  救援项目

#import <Foundation/Foundation.h>

@interface JXRescueItem : NSObject <NSCopying>
/** 项目类型<1-燃油耗尽> */
@property (nonatomic, assign) NSInteger itemType;
/** 项目类别(itemType为1时)<0-柴油, 93-汽油, 97-汽油> */
@property (nonatomic, assign) NSInteger itemClass;
/** 距离基准 */
@property (nonatomic, assign) CGFloat sBase;
/** 份数 */
@property (nonatomic, assign) NSInteger itemCnt;
/** 项目总金额 */
@property (nonatomic, assign) CGFloat itemPrice;

/** 项目应付金额 */
@property (nonatomic, assign) CGFloat totalPrice;
/** 补贴金额单价 */
@property (nonatomic, assign) CGFloat subsidy;

/** 计算后的补贴金额总价 */
@property (nonatomic, assign) CGFloat allowance;
/** 单价 */
@property (nonatomic, assign) CGFloat unitPrice;
/** 油价时间 */
@property (nonatomic, copy) NSString *lastTime;
/** 油品名称 */
@property (nonatomic, copy) NSString *name;
/** 计算后的运费 */
@property (nonatomic, assign) CGFloat sCharges;


/** 红包金额 */
/*
@property (nonatomic, assign) CGFloat giftMoney;
 */
@end
