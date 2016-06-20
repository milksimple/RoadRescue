//
//  JXOrderPopView.m
//  RoadRescue
//
//  Created by mac on 16/5/19.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "JXOrderPopView.h"

@interface JXOrderPopView()
@property (weak, nonatomic) IBOutlet UIView *container;

@end

@implementation JXOrderPopView

+ (instancetype)popView {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.frame = [UIScreen mainScreen].bounds;
}

- (IBAction)knowButtonClicked {
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
