//
//  JXFeeRingView.m
//  RoadRescue
//
//  Created by mac on 16/5/20.
//  Copyright © 2016年 mac. All rights reserved.
//

#define JXTitleLabelFont [UIFont systemFontOfSize:11]
#define JXPayLabelFont [UIFont systemFontOfSize:15]
#define JXRingRedColor JXColor(251,98,48)
#define JXRingBlueColor JXColor(84,130,255)
#define JXRingGreenColor JXColor(88,197,84)
#define JXRingOrangeColor JXColor(249,160,48)
#define JXTitleLabelColor JXColor(117, 117, 117)

#import "JXFeeRingView.h"
#import "UIView+JXExtension.h"

@interface JXFeeRingView()

@property (nonatomic, weak) UILabel *blueTitleLabel;
@property (nonatomic, weak) UILabel *bluePayLabel;
@property (nonatomic, weak) UIView *blueSeparator;
@property (nonatomic, assign) CGPoint blueLeftPoint;
@property (nonatomic, assign) CGPoint blueCenterPoint;
@property (nonatomic, assign) CGPoint blueRightPoint;

@property (nonatomic, weak) UILabel *greenTitleLabel;
@property (nonatomic, weak) UILabel *greenPayLabel;
@property (nonatomic, weak) UIView *greenSeparator;
@property (nonatomic, assign) CGPoint greenLeftPoint;
@property (nonatomic, assign) CGPoint greenCenterPoint;
@property (nonatomic, assign) CGPoint greenRightPoint;

@property (nonatomic, weak) UILabel *orangeTitleLabel;
@property (nonatomic, weak) UILabel *orangePayLabel;
@property (nonatomic, weak) UIView *orangeSeparator;
@property (nonatomic, assign) CGPoint orangeLeftPoint;
@property (nonatomic, assign) CGPoint orangeCenterPoint;
@property (nonatomic, assign) CGPoint orangeRightPoint;
@property (nonatomic, assign) CGPoint ringCenter;

@property (nonatomic, weak) UILabel *redTitleLabel;
@property (nonatomic, weak) UILabel *redPayLabel;
@property (nonatomic, weak) UIView *redSeparator;
@property (nonatomic, assign) CGPoint redLeftPoint;
@property (nonatomic, assign) CGPoint redCenterPoint;
@property (nonatomic, assign) CGPoint redRightPoint;

@property (nonatomic, weak) UILabel *totalPriceLabel;

@property (nonatomic, strong) UIButton *tipButton;

/** 圆环遮盖图 */
@property (nonatomic, weak) UIImageView *circleCorver;

@end

@implementation JXFeeRingView

static CGFloat circleW = 23; // 圆环宽度
static CGFloat radius = 60; // 圆环半径
static CGFloat blankAngle = M_PI*0.05; // 空白角度
static CGFloat hoMargin = 20; // 图形距离整个view的左右的边距
//static CGFloat alMargin = 10; // 图形距离整个view的上下的边距

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
//        self.backgroundColor = [UIColor whiteColor];
        // 计算圆心
        self.ringCenter = CGPointMake(hoMargin + circleW*0.5 + radius, self.jx_height*0.5);
    }
    return self;
}

#pragma mark - lazy
- (UIButton *)tipButton {
    if (_tipButton == nil) {
        _tipButton = [[UIButton alloc] init];
        _tipButton.userInteractionEnabled = NO;
        UIColor *titleColor = [JXSkinTool skinToolColorWithKey:@"rescue_detail_title_text"];
        [_tipButton setTitleColor:titleColor forState:UIControlStateNormal];
        _tipButton.layer.borderColor = titleColor.CGColor;
        _tipButton.layer.cornerRadius = 5;
        _tipButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_tipButton addTarget:self action:@selector(tipButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tipButton;
}

- (void)tipButtonDidClicked:(UIButton *)tipButton {
    [tipButton removeFromSuperview];
    
    // 通知代理
    if ([self.delegate respondsToSelector:@selector(feeRingViewDidClickedReloadButton)]) {
        [self.delegate feeRingViewDidClickedReloadButton];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // 计算圆心
    self.ringCenter = CGPointMake(hoMargin + circleW*0.5 + radius, self.jx_height*0.5);
}

//+ (instancetype)feeRingViewWithTotalPrice:(CGFloat)totalPrice redBagFee:(CGFloat)redBagFee allowanceFee:(CGFloat)allowanceFee fareFee:(CGFloat)fareFee actuallyPay:(CGFloat)actuallyPay {
//    JXFeeRingView *feeRingView = [[JXFeeRingView alloc] init];
//    feeRingView.totalPrice = totalPrice;
//    feeRingView.redBagFee = redBagFee;
//    feeRingView.allowanceFee = allowanceFee;
//    feeRingView.fareFee = fareFee;
//    feeRingView.actuallyPay = actuallyPay;
//    return feeRingView;
//}

+ (instancetype)feeRingViewWithAllowanceFareOilPrice:(CGFloat)allowanceFareOilPrice allowanceFee:(CGFloat)allowanceFee fareFee:(CGFloat)fareFee oilPending:(CGFloat)oilPending {
    JXFeeRingView *feeRingView = [[JXFeeRingView alloc] init];
    feeRingView.allowanceFareOilPrice = allowanceFareOilPrice;
    feeRingView.allowanceFee = allowanceFee;
    feeRingView.fareFee = fareFee;
    feeRingView.oilPending = oilPending;
    return feeRingView;
}

- (void)setup {
    UIColor *titleColor = [JXSkinTool skinToolColorWithKey:@"rescue_detail_title_text"];
    
    // 加上背景遮盖图
    UIImageView *circleCorver = [[UIImageView alloc] initWithImage:[JXSkinTool skinToolImageWithImageName:@"rescue_circle_corver"]];
    [self addSubview:circleCorver];
    self.circleCorver = circleCorver;
    
    // 总价
    UILabel *totalPriceLabel = [[UILabel alloc] init];
    totalPriceLabel.textColor = JXMiOrangeColor;
    totalPriceLabel.font = [UIFont systemFontOfSize:15];
    totalPriceLabel.textAlignment = NSTextAlignmentCenter;
    totalPriceLabel.numberOfLines = 0;
    totalPriceLabel.text = [NSString stringWithFormat:@"应付\n¥%.2f", self.totalPending];
    [self addSubview:totalPriceLabel];
    self.totalPriceLabel = totalPriceLabel;
    
    // 红包
    /*
    UILabel *redTitleLabel = [[UILabel alloc] init];
    redTitleLabel.textColor = titleColor;
    redTitleLabel.font = JXTitleLabelFont;
    redTitleLabel.text = @"红包返利";
    [self addSubview:redTitleLabel];
    self.redTitleLabel = redTitleLabel;
     
    
    UILabel *redPayLabel = [[UILabel alloc] init];
    redPayLabel.textColor = JXRingRedColor;
    redPayLabel.font = JXPayLabelFont;
    redPayLabel.adjustsFontSizeToFitWidth = YES;
    redPayLabel.text = @"-¥50";
    [self addSubview:redPayLabel];
    self.redPayLabel = redPayLabel;
    self.redPayLabel.text = [NSString stringWithFormat:@"-¥%.2f", self.redBagFee];
    
    UIView *redSeparator = [[UIView alloc] init];
    redSeparator.backgroundColor = JXRingRedColor;
    [self addSubview:redSeparator];
    self.redSeparator = redSeparator;
    */
     
    // 优惠
    UILabel *blueTitleLabel = [[UILabel alloc] init];
    blueTitleLabel.textColor = titleColor;
    blueTitleLabel.font = JXTitleLabelFont;
    blueTitleLabel.text = @"优惠";
    [self addSubview:blueTitleLabel];
    self.blueTitleLabel = blueTitleLabel;
    
    
    UILabel *bluePayLabel = [[UILabel alloc] init];
    bluePayLabel.textColor = JXRingBlueColor;
    bluePayLabel.adjustsFontSizeToFitWidth = YES;
    bluePayLabel.font = JXPayLabelFont;
    bluePayLabel.text = @"-¥635";
    [self addSubview:bluePayLabel];
    self.bluePayLabel = bluePayLabel;
    self.bluePayLabel.text = [NSString stringWithFormat:@"-¥%.2f", self.allowanceFee];
    
    UIView *blueSeparator = [[UIView alloc] init];
    blueSeparator.backgroundColor = JXRingBlueColor;
    [self addSubview:blueSeparator];
    self.blueSeparator = blueSeparator;
    
    // 运费
    UILabel *greenTitleLabel = [[UILabel alloc] init];
    greenTitleLabel.textColor = titleColor;
    greenTitleLabel.font = JXTitleLabelFont;
    greenTitleLabel.text = @"运费";
    [self addSubview:greenTitleLabel];
    self.greenTitleLabel = greenTitleLabel;
    
    UILabel *greenPayLabel = [[UILabel alloc] init];
    greenPayLabel.textColor = JXRingGreenColor;
    greenPayLabel.font = JXPayLabelFont;
    greenPayLabel.adjustsFontSizeToFitWidth = YES;
    greenPayLabel.text = @"¥50";
    [self addSubview:greenPayLabel];
    self.greenPayLabel = greenPayLabel;
    self.greenPayLabel.text = [NSString stringWithFormat:@"¥%.2f", self.fareFee];
    
    UIView *greenSeparator = [[UIView alloc] init];
    greenSeparator.backgroundColor = JXRingGreenColor;
    [self addSubview:greenSeparator];
    self.greenSeparator = greenSeparator;
    
    // 待付油款
    UILabel *orangeTitleLabel = [[UILabel alloc] init];
    orangeTitleLabel.textColor = titleColor;
    orangeTitleLabel.font = JXTitleLabelFont;
    orangeTitleLabel.text = @"油款";
    [self addSubview:orangeTitleLabel];
    self.orangeTitleLabel = orangeTitleLabel;
    
    UILabel *orangePayLabel = [[UILabel alloc] init];
    orangePayLabel.textColor = JXRingOrangeColor;
    orangePayLabel.adjustsFontSizeToFitWidth = YES;
    orangePayLabel.font = JXPayLabelFont;
    [self addSubview:orangePayLabel];
    self.orangePayLabel = orangePayLabel;
    self.orangePayLabel.text = [NSString stringWithFormat:@"¥%.2f", self.oilPending];
    
    
    UIView *orangeSeparator = [[UIView alloc] init];
    orangeSeparator.backgroundColor = JXRingOrangeColor;
    [self addSubview:orangeSeparator];
    self.orangeSeparator = orangeSeparator;
    
    // 小计
    UILabel *redTitleLabel = [[UILabel alloc] init];
    redTitleLabel.textColor = titleColor;
    redTitleLabel.font = JXTitleLabelFont;
    redTitleLabel.text = @"小计";
    [self addSubview:redTitleLabel];
    self.redTitleLabel = redTitleLabel;


    UILabel *redPayLabel = [[UILabel alloc] init];
    redPayLabel.textColor = JXRingRedColor;
    redPayLabel.font = JXPayLabelFont;
    redPayLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:redPayLabel];
    self.redPayLabel = redPayLabel;
    self.redPayLabel.text = [NSString stringWithFormat:@"¥%.2f", self.subtotalFee];

    UIView *redSeparator = [[UIView alloc] init];
    redSeparator.backgroundColor = JXRingRedColor;
    [self addSubview:redSeparator];
    self.redSeparator = redSeparator;
    

}

- (void)redraw {
    [self setNeedsDisplay];
}

- (void)setTipStr:(NSString *)tipStr {
    _tipStr = tipStr;
    
    [self.tipButton setTitle:tipStr forState:UIControlStateNormal];
}

- (void)setLoadSuccess:(BOOL)loadSuccess message:(NSString *)message {
    if (loadSuccess) {
        [self.tipButton setTitle:message forState:UIControlStateNormal];
        self.tipButton.userInteractionEnabled = NO;
        self.tipButton.layer.borderWidth = 0;
    }
    else {
        [self.tipButton setTitle:message forState:UIControlStateNormal];
        self.tipButton.userInteractionEnabled = YES;
        self.tipButton.layer.borderWidth = 1;
    }
    
    [self setNeedsDisplay];
}

/** 总价 */
- (void)setAllowanceFareOilPrice:(CGFloat)allowanceFareOilPrice {
    _allowanceFareOilPrice = allowanceFareOilPrice;
    
}

- (void)setTotalPending:(CGFloat)totalPending {
    _totalPending = totalPending;
    
    self.totalPriceLabel.text = [NSString stringWithFormat:@"应付\n¥%.2f", totalPending];
}

///** 红包返利 */
//- (void)setRedBagFee:(CGFloat)redBagFee {
//    _redBagFee = redBagFee;
//    
//    if (self.totalPrice == 0) return;
//    self.redBagPercentage = redBagFee / 1.0 / self.totalPrice;
//}

/** 优惠补贴 */
- (void)setAllowanceFee:(CGFloat)allowanceFee {
    _allowanceFee = allowanceFee;
    
    if (self.allowanceFareOilPrice == 0) return;
    self.allowancePercentage = allowanceFee / 1.0 / self.allowanceFareOilPrice;
}

/** 运费 */
- (void)setFareFee:(CGFloat)fareFee {
    _fareFee = fareFee;
    
    if (self.allowanceFareOilPrice == 0) return;
    self.farePercentage = fareFee / 1.0 / self.allowanceFareOilPrice;
}

/** 待付油款 */
- (void)setOilPending:(CGFloat)oilPending {
    _oilPending = oilPending;
    
    if (self.allowanceFareOilPrice == 0) return;
    self.oilPendingPercentage = oilPending / 1.0 / self.allowanceFareOilPrice;
}

///** 红包返利 */
//- (void)setRedBagPercentage:(CGFloat)redBagPercentage {
//    _redBagPercentage = redBagPercentage;
//    
//    [self setNeedsDisplay];
//}

/** 优惠补贴 */
- (void)setAllowancePercentage:(CGFloat)allowancePercentage {
    _allowancePercentage = allowancePercentage;
    
    [self setNeedsDisplay];
}

/** 运费 */
- (void)setFarePercentage:(CGFloat)farePercentage {
    _farePercentage = farePercentage;
    
    [self setNeedsDisplay];
}

/** 待付油款 */
- (void)setOilPendingPercentage:(CGFloat)oilPendingPercentage {
    _oilPendingPercentage = oilPendingPercentage;
    
    [self setNeedsDisplay];
}

//- (void)setFreeFare:(BOOL)freeFare {
//    _freeFare = freeFare;
//    
//    [self setNeedsDisplay];
//}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 圆环遮盖
    self.circleCorver.center = self.ringCenter;
    
    // 提示按钮
    self.tipButton.jx_size = CGSizeMake(300, 40);
    self.tipButton.center = self.center;
    
    // 总价
    CGRect totalPriceLabelRect = CGRectMake(self.ringCenter.x - radius + circleW, self.ringCenter.y - radius + circleW, (radius - circleW)*2, (radius - circleW)*2);
    self.totalPriceLabel.frame = totalPriceLabelRect;
    
    // label高度
    CGFloat labelH = 15;
    // 竖线间的垂直间距
    CGFloat separatorMargin = (self.jx_height - 2 * labelH  *4)/5.0;
    
    // 优惠补贴
    CGFloat blueTitleLabelW = 70;
    CGFloat blueTitleLabelH = labelH;
    CGFloat blueTitleLabelX = self.jx_width - hoMargin - blueTitleLabelW;
    CGFloat blueTitleLabelY = separatorMargin;
    self.blueTitleLabel.frame = CGRectMake(blueTitleLabelX, blueTitleLabelY, blueTitleLabelW, blueTitleLabelH);
    
    CGFloat bluePayLabelX = blueTitleLabelX;
    CGFloat bluePayLabelY = CGRectGetMaxY(self.blueTitleLabel.frame);
    CGFloat bluePayLabelW = blueTitleLabelW;
    CGFloat bluePayLabelH = blueTitleLabelH;
    self.bluePayLabel.frame = CGRectMake(bluePayLabelX, bluePayLabelY, bluePayLabelW, bluePayLabelH);
    
    CGFloat blueSeparatorW = 2;
    CGFloat blueSeparatorH = blueTitleLabelH + bluePayLabelH;
    CGFloat blueSeparatorX = bluePayLabelX - 5 - blueSeparatorW;
    CGFloat blueSeparatorY = blueTitleLabelY;
    self.blueSeparator.frame = CGRectMake(blueSeparatorX, blueSeparatorY, blueSeparatorW, blueSeparatorH);
    
    self.blueRightPoint = CGPointMake(blueSeparatorX - 5, blueSeparatorY + blueSeparatorH*0.5);
    
    // 运费
    CGFloat greenTitleLabelW = blueTitleLabelW;
    CGFloat greenTitleLabelH = blueTitleLabelH;
    CGFloat greenTitleLabelX = blueTitleLabelX;
    CGFloat greenTitleLabelY = CGRectGetMaxY(self.bluePayLabel.frame) + separatorMargin;
    self.greenTitleLabel.frame = CGRectMake(greenTitleLabelX, greenTitleLabelY, greenTitleLabelW, greenTitleLabelH);
    
    CGFloat greenPayLabelX = blueTitleLabelX;
    CGFloat greenPayLabelY = CGRectGetMaxY(self.greenTitleLabel.frame);
    CGFloat greenPayLabelW = blueTitleLabelW;
    CGFloat greenPayLabelH = blueTitleLabelH;
    self.greenPayLabel.frame = CGRectMake(greenPayLabelX, greenPayLabelY, greenPayLabelW, greenPayLabelH);
    
    CGFloat greenSeparatorW = blueSeparatorW;
    CGFloat greenSeparatorH = blueSeparatorH;
    CGFloat greenSeparatorX = blueSeparatorX;
    CGFloat greenSeparatorY = greenTitleLabelY;
    self.greenSeparator.frame = CGRectMake(greenSeparatorX, greenSeparatorY, greenSeparatorW, greenSeparatorH);
    
    self.greenRightPoint = CGPointMake(greenSeparatorX - 5, greenSeparatorY + greenSeparatorH*0.5);
    
    // 待付油款
    CGFloat orangeTitleLabelW = blueTitleLabelW;
    CGFloat orangeTitleLabelH = blueTitleLabelH;
    CGFloat orangeTitleLabelX = blueTitleLabelX;
    CGFloat orangeTitleLabelY = CGRectGetMaxY(self.greenPayLabel.frame) + separatorMargin;
    self.orangeTitleLabel.frame = CGRectMake(orangeTitleLabelX, orangeTitleLabelY, orangeTitleLabelW, orangeTitleLabelH);
    
    CGFloat orangePayLabelX = blueTitleLabelX;
    CGFloat orangePayLabelY = CGRectGetMaxY(self.orangeTitleLabel.frame);
    CGFloat orangePayLabelW = blueTitleLabelW;
    CGFloat orangePayLabelH = blueTitleLabelH;
    self.orangePayLabel.frame = CGRectMake(orangePayLabelX, orangePayLabelY, orangePayLabelW, orangePayLabelH);
    
    CGFloat orangeSeparatorW = blueSeparatorW;
    CGFloat orangeSeparatorH = blueSeparatorH;
    CGFloat orangeSeparatorX = blueSeparatorX;
    CGFloat orangeSeparatorY = orangeTitleLabelY;
    self.orangeSeparator.frame = CGRectMake(orangeSeparatorX, orangeSeparatorY, orangeSeparatorW, orangeSeparatorH);
    
    self.orangeRightPoint = CGPointMake(orangeSeparatorX - 5, orangeSeparatorY + orangeSeparatorH*0.5);
    
    // 小计
    CGFloat redTitleLabelW = 70;
    CGFloat redTitleLabelH = labelH;
    CGFloat redTitleLabelX = self.jx_width - hoMargin - redTitleLabelW;
    CGFloat redTitleLabelY = CGRectGetMaxY(self.orangePayLabel.frame) + separatorMargin;
    self.redTitleLabel.frame = CGRectMake(redTitleLabelX, redTitleLabelY, redTitleLabelW, redTitleLabelH);

    CGFloat redPayLabelX = redTitleLabelX;
    CGFloat redPayLabelY = CGRectGetMaxY(self.redTitleLabel.frame);
    CGFloat redPayLabelW = redTitleLabelW;
    CGFloat redPayLabelH = labelH;
    self.redPayLabel.frame = CGRectMake(redPayLabelX, redPayLabelY, redPayLabelW, redPayLabelH);

    CGFloat redSeparatorW = 2;
    CGFloat redSeparatorH = redTitleLabelH + redPayLabelH;
    CGFloat redSeparatorX = redPayLabelX - 5 - redSeparatorW;
    CGFloat redSeparatorY = redTitleLabelY;
    self.redSeparator.frame = CGRectMake(redSeparatorX, redSeparatorY, redSeparatorW, redSeparatorH);

    self.redRightPoint = CGPointMake(redSeparatorX - 5, redSeparatorY + redSeparatorH*0.5);
}

- (void)drawRect:(CGRect)rect {
    if (self.oilPending == 0) {
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self addSubview:self.tipButton];
        
        return;
    }
    
    // 获得当前上下文
    CGContextRef ctx =UIGraphicsGetCurrentContext();
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    // 必须先添加进其他label，separator等控件，下面画点的时候坐标才正确
    [self setup];
    [self layoutIfNeeded];
    
    // 现在一圈不是360度，而是
    CGFloat completeAngle = M_PI * 1.9;
    
    // 圆心
    CGPoint center = CGPointMake(hoMargin + circleW*0.5 + radius, self.jx_height*0.5);
    // 外面的点所在圆半径
    CGFloat bigRadius = radius + circleW*0.5 + 10;
    // 中间的折点的基准线
    CGFloat turnX = self.blueSeparator.jx_x - 30; // 30是大概值
    
    /*
    // 红包
    CGFloat redStartAngle = -M_PI_2;
    CGFloat redEndAngle = redStartAngle + self.redBagPercentage * completeAngle;
    [self drawRingWithCenter:center radius:radius startAngle:redStartAngle endAngle:redEndAngle clockwise:YES lineWidth:circleW color:JXRingRedColor];
    
    // 左边的红点的角度
    CGFloat redBigAngle = (redStartAngle - redEndAngle)*0.5 + redEndAngle;
    self.redLeftPoint = CGPointMake(center.x + bigRadius*cosf(redBigAngle), center.y + bigRadius*sinf(redBigAngle));
    // 画出左边红点
    [self drawDotWithPoint:self.redLeftPoint color:JXRingRedColor];
    // 画出右边红点
    [self drawDotWithPoint:self.redRightPoint color:JXRingRedColor];
    
    // 中间的折点
    self.redCenterPoint = CGPointMake(turnX, self.redRightPoint.y);
    // 画出左边点到中间点虚线
    [self drawDottedLineFromPoint:self.redLeftPoint toPoint:self.redCenterPoint withContext:ctx lineColor:JXRingRedColor];
    // 画出中间点到右边点虚线
    [self drawDottedLineFromPoint:self.redCenterPoint toPoint:self.redRightPoint withContext:ctx lineColor:JXRingRedColor];
     */
    
    // 优惠补贴
    CGFloat blueStartAngle = -M_PI_2;
    CGFloat blueEndAngle = blueStartAngle + self.allowancePercentage * completeAngle;
    [self drawRingWithCenter:center radius:radius startAngle:blueStartAngle endAngle:blueEndAngle clockwise:YES lineWidth:circleW color:JXRingBlueColor];
    
    // 左边的蓝点的角度
    CGFloat blueBigAngle = (blueStartAngle - blueEndAngle)*0.5 + blueEndAngle;
    self.blueLeftPoint = CGPointMake(center.x + bigRadius*cosf(blueBigAngle), center.y + bigRadius*sinf(blueBigAngle));
    // 画出左边蓝点
    [self drawDotWithPoint:self.blueLeftPoint color:JXRingBlueColor];
    // 画出右边蓝点
    [self drawDotWithPoint:self.blueRightPoint color:JXRingBlueColor];
    // 中间的折点
    self.blueCenterPoint = CGPointMake(turnX, self.blueRightPoint.y);
    // 画出左边点到中间点虚线
    [self drawDottedLineFromPoint:self.blueLeftPoint toPoint:self.blueCenterPoint withContext:ctx lineColor:JXRingBlueColor];
    // 画出中间点到右边点虚线
    [self drawDottedLineFromPoint:self.blueCenterPoint toPoint:self.blueRightPoint withContext:ctx lineColor:JXRingBlueColor];
    
    // 运费
    CGFloat greenStartAngle = blueEndAngle + blankAngle;
    CGFloat greenEndAngle = greenStartAngle + self.farePercentage * completeAngle;
    [self drawRingWithCenter:center radius:radius startAngle:greenStartAngle endAngle:greenEndAngle clockwise:YES lineWidth:circleW color:JXRingGreenColor];
    
    // 左边的绿点的角度
    CGFloat greenBigAngle = (greenStartAngle - greenEndAngle)*0.5 + greenEndAngle;
    self.greenLeftPoint = CGPointMake(center.x + bigRadius*cosf(greenBigAngle), center.y + bigRadius*sinf(greenBigAngle));
    // 画出左边绿点
    [self drawDotWithPoint:self.greenLeftPoint color:JXRingGreenColor];
    // 画出右边绿点
    [self drawDotWithPoint:self.greenRightPoint color:JXRingGreenColor];
    
    // 中间的折点
    self.greenCenterPoint = CGPointMake(turnX, self.greenRightPoint.y);
    // 画出左边点到中间点虚线
    [self drawDottedLineFromPoint:self.greenLeftPoint toPoint:self.greenCenterPoint withContext:ctx lineColor:JXRingGreenColor];
    // 画出中间点到右边点虚线
    [self drawDottedLineFromPoint:self.greenCenterPoint toPoint:self.greenRightPoint withContext:ctx lineColor:JXRingGreenColor];
    
    // 实付
    CGFloat orangeStartAngle = greenEndAngle;
    CGFloat orangeEndAngle = orangeStartAngle + self.oilPendingPercentage * completeAngle;
    [self drawRingWithCenter:center radius:radius startAngle:orangeStartAngle endAngle:orangeEndAngle clockwise:YES lineWidth:circleW color:JXRingOrangeColor];
    
    // 左边的橘色点的角度
    CGFloat orangeBigAngle = orangeStartAngle + blankAngle;
    self.orangeLeftPoint = CGPointMake(center.x + bigRadius*cosf(orangeBigAngle), center.y + bigRadius*sinf(orangeBigAngle));
    // 画出左边橘色点
    [self drawDotWithPoint:self.orangeLeftPoint color:JXRingOrangeColor];
    // 画出右边橘色点
    [self drawDotWithPoint:self.orangeRightPoint color:JXRingOrangeColor];
    
    // 中间的折点
    self.orangeCenterPoint = CGPointMake(turnX, self.orangeRightPoint.y);
    // 画出左边点到中间点虚线
    [self drawDottedLineFromPoint:self.orangeLeftPoint toPoint:self.orangeCenterPoint withContext:ctx lineColor:JXRingOrangeColor];
    // 画出中间点到右边点虚线
    [self drawDottedLineFromPoint:self.orangeCenterPoint toPoint:self.orangeRightPoint withContext:ctx lineColor:JXRingOrangeColor];
}

- (void)drawRingWithCenter:(CGPoint)center radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle clockwise:(BOOL)clockwise lineWidth:(CGFloat)lineWidth color:(UIColor *)color {
    UIBezierPath *ringPath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:clockwise];
    ringPath.lineWidth= lineWidth;
    ringPath.lineCapStyle = kCGLineCapButt;
    [color setStroke];
    [ringPath stroke];
}

- (void)drawDotWithPoint:(CGPoint)point color:(UIColor *)color {
    UIBezierPath *dotPath = [UIBezierPath bezierPathWithArcCenter:point radius:2 startAngle:0 endAngle:M_PI*2 clockwise:NO];
    dotPath.lineWidth = 1;
    dotPath.lineCapStyle = kCGLineCapButt;
    [color setFill];
    [dotPath fill];
}

- (void)drawDottedLineFromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint withContext:(CGContextRef)context lineColor:(UIColor *)color {
    CGContextSaveGState(context);
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGFloat lengths[] = {1,2};
    CGContextSetLineDash(context, 1, lengths,2);
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}

- (void)drawOilPath {
    UIBezierPath *oilPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(100, 150) radius:60 startAngle:-M_PI_2 - M_PI*0.05 endAngle:M_PI_4 + M_PI_4 * 0.5 + M_PI*0.05 clockwise:NO];
    oilPath.lineWidth= 23;
    oilPath.lineCapStyle = kCGLineCapButt;
    [JXRingOrangeColor setStroke];
    [oilPath stroke];
}

- (void)drawRedPath {
    UIBezierPath *redPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(100, 150) radius:60 startAngle:-M_PI_2 endAngle:-M_PI_2 + M_PI_4     clockwise:YES];
    redPath.lineWidth= 23;
    redPath.lineCapStyle = kCGLineCapButt;
    [JXRingRedColor setStroke];
    [redPath stroke];
}

- (void)drawBluePath {
    UIBezierPath *bluePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(100, 150) radius:60 startAngle:-M_PI_2 + M_PI_4 endAngle:M_PI_4     clockwise:YES];
    bluePath.lineWidth= 23;
    bluePath.lineCapStyle = kCGLineCapButt;
    [JXRingBlueColor setStroke];
    [bluePath stroke];
}

- (void)drawGreenPath {
    UIBezierPath *greenPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(100, 150) radius:60 startAngle:M_PI_4 endAngle:M_PI_4 + M_PI_4 * 0.5     clockwise:YES];
    greenPath.lineWidth= 23;
    greenPath.lineCapStyle = kCGLineCapButt;
    [JXRingGreenColor setStroke];
    [greenPath stroke];
}

@end
