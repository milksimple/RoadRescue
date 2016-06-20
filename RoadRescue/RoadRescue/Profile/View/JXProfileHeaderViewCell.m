//
//  JXProfileHeaderViewCell.m
//  RoadRescueTeam
//
//  Created by mac on 16/5/25.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "JXProfileHeaderViewCell.h"

@implementation JXProfileHeaderViewCell

+ (instancetype)headerViewCell {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
}

+ (CGFloat)rowHeight {
    return 80;
}

@end
