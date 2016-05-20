//
//  JXMyOrderTableViewCell.m
//  RoadRescue
//
//  Created by mac on 16/5/19.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "JXMyOrderTableViewCell.h"
#import "UIView+JXExtension.h"

@interface JXMyOrderTableViewCell()
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation JXMyOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.jx_width = JXScreenW;
    [self layoutIfNeeded];
    
    // 设置layer圆角半径
    self.containerView.layer.cornerRadius=3.0;
    // 即阴影颜色值
    self.containerView.layer.shadowColor=[[UIColor colorWithWhite:0.3 alpha:0.5] CGColor];
    // 即阴影相对于Y轴有1个像素点的向下位移。
    self.containerView.layer.shadowOffset = CGSizeMake(2, 5);
    //设置阴影的不透明度
    self.containerView.layer.shadowOpacity = 1;
    // 阴影的模糊度
    self.containerView.layer.shadowRadius = 1.0;
    // 阴影的位置
    self.containerView.layer.shadowPath = [[UIBezierPath bezierPathWithRect:self.containerView.bounds] CGPath];
    //设置缓存 仅复用时设置此项
    self.containerView.layer.shouldRasterize=YES;
    //设置抗锯齿边缘
    self.containerView.layer.rasterizationScale=[UIScreen mainScreen].scale;

}

/**
 *  查看按钮被点击了
 */
- (IBAction)seeButtonClicked {
    if ([self.delegate respondsToSelector:@selector(myOrderTableViewCellDidClickedSeeButton)]) {
        [self.delegate myOrderTableViewCellDidClickedSeeButton];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString *)reuseIdentifier {
    return @"myOrderCell";
}

@end
