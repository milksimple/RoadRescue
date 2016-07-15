//
//  JXProfileViewCell.h
//  RoadRescueTeam
//
//  Created by mac on 16/5/25.
//  Copyright © 2016年 mac. All rights reserved.
//

typedef enum {
    JXProfileViewCellTypeRedbag, // 红包
    JXProfileViewCellTypeLogout, // 注销
    JXProfileViewCellTypeHelp, // 帮助
    JXProfileViewCellTypeChangeSkin // 换肤
} JXProfileViewCellType;

#import <UIKit/UIKit.h>

@interface JXProfileViewCell : UITableViewCell

@property (nonatomic, assign) JXProfileViewCellType type;

+ (NSString *)reuseIdentifier;

@property (nonatomic, copy) NSString *title;

+ (CGFloat)rowHeight;

@end
