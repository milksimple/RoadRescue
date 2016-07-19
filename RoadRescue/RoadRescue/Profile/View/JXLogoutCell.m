//
//  JXLogoutCell.m
//  RoadRescue
//
//  Created by mac on 16/7/18.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "JXLogoutCell.h"

@implementation JXLogoutCell

+ (instancetype)logoutCell {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}

+ (NSString *)reuseIdentifier {
    return @"logoutCell";
}

+ (CGFloat)rowHeight {
    return 70;
}

- (IBAction)logoutButtonDidClicked {
    if ([self.delegate respondsToSelector:@selector(logoutCellDidClickedLogoutButton)]) {
        [self.delegate logoutCellDidClickedLogoutButton];
    }
}

@end
