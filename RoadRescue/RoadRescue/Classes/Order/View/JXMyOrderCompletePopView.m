//
//  JXMyOrderCompletePopView.m
//  RoadRescue
//
//  Created by mac on 16/5/20.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "JXMyOrderCompletePopView.h"

@implementation JXMyOrderCompletePopView

+ (instancetype)completePopView {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.frame = [UIScreen mainScreen].bounds;
}

- (IBAction)confirmButtonClicked {
    [self dismiss];
}

- (void)show {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
}

- (void)dismiss {
    [self removeFromSuperview];
}

@end
