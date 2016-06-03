//
//  JXMyOrderTableViewCell.m
//  RoadRescue
//
//  Created by mac on 16/5/19.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "JXMyOrderTableViewCell.h"
#import "UIView+JXExtension.h"
#import "JXOrder.h"

@interface JXMyOrderTableViewCell()
{
    NSString *_title; // 顶部标题
    NSString *_time; // 时间
    NSString *_seeButtonTitle; // 按钮显示标题
    BOOL _oilSelected; // 油料救援按钮选中状态
    BOOL _fixSelected; // 简易维修按钮选中状态
    NSString *_oilName; // 购买的油料名称
    
    NSString *_topBgImgName; // 顶部背景图片名
    NSString *_translucentImgName; // 中间遮罩背景图名
    
    NSString *_seeBtnBgImgName; // 查看按钮背景图名
}
@property (weak, nonatomic) IBOutlet UIImageView *cellTopBgView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIImageView *waveBgView;
@property (weak, nonatomic) IBOutlet UIImageView *translucentView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *oilNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *oilCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *addressButton;
@property (weak, nonatomic) IBOutlet UIButton *oilRescueButton;
@property (weak, nonatomic) IBOutlet UIButton *fixRescueButton;
@property (weak, nonatomic) IBOutlet UIButton *seeButton;


@end

@implementation JXMyOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.jx_width = JXScreenW;
    [self layoutIfNeeded];
    
    // 设置layer圆角半径
    self.cellTopBgView.layer.cornerRadius = 3.0;
    self.cellTopBgView.clipsToBounds = YES;
    // 即阴影颜色值
    self.containerView.layer.shadowColor=[[UIColor colorWithWhite:0.3 alpha:0.5] CGColor];
    // 即阴影相对于Y轴有1个像素点的向下位移。
    self.containerView.layer.shadowOffset = CGSizeMake(2, 5);
    //设置阴影的不透明度
    self.containerView.layer.shadowOpacity = 1;
    // 阴影的模糊度
    self.containerView.layer.shadowRadius = 3.0;
    // 阴影的位置
    self.containerView.layer.shadowPath = [[UIBezierPath bezierPathWithRect:self.containerView.bounds] CGPath];
    //设置缓存 仅复用时设置此项
    self.containerView.layer.shouldRasterize=YES;
    //设置抗锯齿边缘
    self.containerView.layer.rasterizationScale=[UIScreen mainScreen].scale;

    UIImage *waveBgImg = [JXSkinTool skinToolImageWithImageName:@"order_wave_bg"];
    UIImage *resizableImg = [waveBgImg resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 10, 0) resizingMode:UIImageResizingModeTile];
    self.waveBgView.image = resizableImg;
    
    self.translucentView.image = [JXSkinTool skinToolImageWithImageName:@"order_translucent_bg"];
}

- (void)setOrder:(JXOrder *)order {
    _order = order;
    
    NSArray *orderList = order.itemList;
    JXRescueItem *rescueItem = orderList[0];
    
    switch (order.itemTypes) {
        case 1: // 油料
            _oilSelected = YES;
            _fixSelected = NO;
            break;
            
        case 2: // 维修
            _oilSelected = NO;
            _fixSelected = YES;
            break;
            
        case 3: // 油料 + 维修
            _oilSelected = YES;
            _fixSelected = YES;
            break;
            
        default:
            break;
    }
    
    switch (order.itemStatus) {
        case 0: // 已下单
            _title = @"燃油耗尽";
            _time = nil;
            _seeButtonTitle = @"查看";
            _topBgImgName = @"order_doing_bg";
            _seeBtnBgImgName = @"order_see_button_green";
            break;
            
        case 1: // 已接单
            _title = [NSString stringWithFormat:@"%@ 正在执行中...", order.title];
            _time = nil;
            _seeButtonTitle = @"查看";
            _topBgImgName = @"order_doing_bg";
            _seeBtnBgImgName = @"order_see_button_green";
            break;
            
//        case 2: // 完成等待付款
//            self.titleLabel.text = order.title;
//            self.timeLabel.text = nil;
//            break;
            
        case 9: // 完成
            _title = @"燃油耗尽";
            _time = order.title;
            _seeButtonTitle = @"评价";
            _topBgImgName = @"order_complete_bg";
            _seeBtnBgImgName = @"order_see_button_orange";
            break;
            
        default:
            break;
    }
    
    switch (rescueItem.itemClass) {
        case 0: // 柴油
            _oilName = @"柴油";
            break;
            
        case 93:
            _oilName = @"93#汽油";
            break;
            
        case 97:
            _oilName = @"97#汽油";
            break;
        default:
            break;
    }
    
    
    [self.addressButton setTitle:order.addressDes forState:UIControlStateNormal];
    self.totalPriceLabel.text = [NSString stringWithFormat:@"¥%f", order.totalPrice];
    self.oilCountLabel.text = [NSString stringWithFormat:@"%zdL", rescueItem.itemCnt];
    
    self.oilRescueButton.selected = _oilSelected;
    self.fixRescueButton.selected = _fixSelected;
    
    self.titleLabel.text = _title;
    self.timeLabel.text = _time;
    [self.seeButton setTitle:_seeButtonTitle forState:UIControlStateNormal];
    
    self.oilNameLabel.text = _oilName;
    
    [self.seeButton setBackgroundImage:[UIImage imageNamed:_seeBtnBgImgName] forState:UIControlStateNormal];
    
    UIImage *cellTopBgImg = [JXSkinTool skinToolImageWithImageName:_topBgImgName];
    UIImage *brickResizableImg = [cellTopBgImg resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeTile];
    self.cellTopBgView.image = brickResizableImg;
}

/**
 *  查看按钮被点击了
 */
- (IBAction)seeButtonClicked {
    if ([self.delegate respondsToSelector:@selector(myOrderTableViewCellDidClickedSeeButtonWithOrderNum:)]) {
        [self.delegate myOrderTableViewCellDidClickedSeeButtonWithOrderNum:self.order.orderNum];
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
