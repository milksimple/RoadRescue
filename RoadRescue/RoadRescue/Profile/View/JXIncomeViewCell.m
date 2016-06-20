//
//  JXIncomeViewCell.m
//  RoadRescueTeam
//
//  Created by mac on 16/5/25.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "JXIncomeViewCell.h"

@implementation JXIncomeViewCell

+ (instancetype)incomeViewCell {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
}

+ (CGFloat)rowHeight {
    return 60;
}

@end
