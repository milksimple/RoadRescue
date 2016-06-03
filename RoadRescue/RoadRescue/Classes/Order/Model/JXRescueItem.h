//
//  JXRescueItem.h
//  RoadRescueTeam
//
//  Created by mac on 16/6/2.
//  Copyright © 2016年 mac. All rights reserved.
//  救援项目

#import <Foundation/Foundation.h>

@interface JXRescueItem : NSObject
/** 项目类型<1-燃油耗尽> */
@property (nonatomic, assign) NSInteger itemType;
/** 项目类别(itemType为1时)<0-柴油, 93-汽油, 97-汽油> */
@property (nonatomic, assign) NSInteger itemClass;
/** 份数 */
@property (nonatomic, assign) NSInteger itemCnt;
/** 项目总金额 */
@property (nonatomic, assign) CGFloat itemPrice;
/** 补贴金额 */
@property (nonatomic, assign) CGFloat subsidy;
/** 红包金额 */
@property (nonatomic, assign) CGFloat giftMoney;
@end
