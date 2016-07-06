//
//  JXProfileHeaderViewCell.h
//  RoadRescueTeam
//
//  Created by mac on 16/5/25.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXAccount.h"

@interface JXProfileHeaderViewCell : UITableViewCell

+ (instancetype)headerViewCell;

+ (CGFloat)rowHeight;

/** 账号信息 */
@property (nonatomic, strong) JXAccount *account;

@end
