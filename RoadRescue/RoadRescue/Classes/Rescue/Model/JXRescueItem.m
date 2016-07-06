//
//  JXRescueItem.m
//  RoadRescueTeam
//
//  Created by mac on 16/6/2.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "JXRescueItem.h"

@implementation JXRescueItem

- (void)setItemClass:(NSInteger)itemClass {
    _itemClass = itemClass;
    
    if (itemClass == 0) {
        self.name = @"柴油";
    }
    else {
        self.name = [NSString stringWithFormat:@"%zd#汽油", itemClass];
    }
}

- (JXRescueItem *)copyWithZone:(NSZone *)zone {
    JXRescueItem *item  = [[JXRescueItem allocWithZone:zone] init];
    item.itemType = _itemType;
    item.itemClass = _itemClass;
    item.sBase = _sBase;
    item.itemCnt = _itemCnt;
    item.itemPrice = _itemPrice;
    item.subsidy = _subsidy;
    item.allowance = _allowance;
    item.totalPrice = _totalPrice;
    item.unitPrice = _unitPrice;
    item.lastTime = _lastTime;
    item.name = _name;
    item.sCharges = _sCharges;
    return item;
}

// /** 项目类型<1-燃油耗尽> */
//@property (nonatomic, assign) NSInteger itemType;
///** 项目类别(itemType为1时)<0-柴油, 93-汽油, 97-汽油> */
//@property (nonatomic, assign) NSInteger itemClass;
///** 距离基准 */
//@property (nonatomic, assign) CGFloat sBase;
///** 份数 */
//@property (nonatomic, assign) NSInteger itemCnt;
///** 项目总金额 */
//@property (nonatomic, assign) CGFloat itemPrice;
///** 补贴金额单价 */
//@property (nonatomic, assign) CGFloat subsidy;
//
///** 计算后的补贴金额总价 */
//@property (nonatomic, assign) CGFloat allowance;
///** 单价 */
//@property (nonatomic, assign) CGFloat unitPrice;
///** 油价时间 */
//@property (nonatomic, copy) NSString *lastTime;
///** 油品名称 */
//@property (nonatomic, copy) NSString *name;
///** 计算后的运费 */
//@property (nonatomic, assign) CGFloat charge;
// */

@end
