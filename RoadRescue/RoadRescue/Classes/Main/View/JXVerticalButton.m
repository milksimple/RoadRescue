//
//  JXVerticalButton.m
//  RoadRescue
//
//  Created by mac on 16/5/20.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "JXVerticalButton.h"
#import "UIView+JXExtension.h"

@implementation JXVerticalButton

- (void)setup
{
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [self setup];
}

- (void)setHighlighted:(BOOL)highlighted {
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 调整图片
    self.imageView.jx_x = 0;
    self.imageView.jx_y = 0;
    self.imageView.jx_width = self.jx_width;
    self.imageView.jx_height = self.imageView.jx_width;
    
    // 调整文字
    self.titleLabel.jx_x = 0;
    self.titleLabel.jx_y = self.imageView.jx_height;
    self.titleLabel.jx_width = self.jx_width;
    self.titleLabel.jx_height = self.jx_height - self.titleLabel.jx_y;
}


@end
