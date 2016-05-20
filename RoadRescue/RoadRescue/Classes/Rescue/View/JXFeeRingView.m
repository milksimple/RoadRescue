//
//  JXFeeRingView.m
//  RoadRescue
//
//  Created by mac on 16/5/20.
//  Copyright © 2016年 mac. All rights reserved.
//

#define JXTitleLabelFont [UIFont systemFontOfSize:11]
#define JXPayLabelFont [UIFont systemFontOfSize:15]

#import "JXFeeRingView.h"
#import "UIView+JXExtension.h"

@interface JXFeeRingView()

@property (nonatomic, weak) UILabel *redTitleLabel;
@property (nonatomic, weak) UILabel *redPayLabel;
@property (nonatomic, weak) UIView *redSeparator;
@property (nonatomic, assign) CGPoint redLeftPoint;
@property (nonatomic, assign) CGPoint redCenterPoint;
@property (nonatomic, assign) CGPoint redRightPoint;

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



@end

@implementation JXFeeRingView

static CGFloat circleW = 23; // 圆环宽度
static CGFloat radius = 60; // 圆环半径
static CGFloat blankAngle = M_PI*0.05; // 空白角度
static CGFloat hoMargin = 20; // 图形距离整个view的左右的边距
static CGFloat alMargin = 10; // 图形距离整个view的上下的边距

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        // 计算圆心
        self.ringCenter = CGPointMake(hoMargin + circleW*0.5 + radius, self.jx_height*0.5);
        
        [self setup];
    }
    return self;
}

+ (instancetype)feeRingViewWithTotalPrice:(NSInteger)totalPrice redBagFee:(NSInteger)redBagFee allowanceFee:(NSInteger)allowanceFee fareFee:(NSInteger)fareFee actuallyPay:(NSInteger)actuallyPay {
    JXFeeRingView *feeRingView = [[JXFeeRingView alloc] init];
    feeRingView.totalPrice = totalPrice;
    feeRingView.redBagFee = redBagFee;
    feeRingView.allowanceFee = allowanceFee;
    feeRingView.fareFee = fareFee;
    feeRingView.actuallyPay = actuallyPay;
    return feeRingView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
//    self.jx_width = JXScreenW;
//    [self setup];
//    [self layoutIfNeeded];
//    [self setNeedsDisplay];
}

- (void)setup {
    // 总价
    UILabel *totalPriceLabel = [[UILabel alloc] init];
    
    // 红包
    UILabel *redTitleLabel = [[UILabel alloc] init];
    redTitleLabel.font = JXTitleLabelFont;
    redTitleLabel.text = @"红包返利";
    [self addSubview:redTitleLabel];
    self.redTitleLabel = redTitleLabel;
    
    UILabel *redPayLabel = [[UILabel alloc] init];
    redPayLabel.font = JXPayLabelFont;
    redPayLabel.adjustsFontSizeToFitWidth = YES;
    redPayLabel.text = @"-¥50";
    [self addSubview:redPayLabel];
    self.redPayLabel = redPayLabel;
    self.redPayLabel.text = [NSString stringWithFormat:@"-¥%zd", self.redBagFee];
    
    UIView *redSeparator = [[UIView alloc] init];
    redSeparator.backgroundColor = [UIColor redColor];
    [self addSubview:redSeparator];
    self.redSeparator = redSeparator;
    
    // 优惠
    UILabel *blueTitleLabel = [[UILabel alloc] init];
    blueTitleLabel.font = JXTitleLabelFont;
    blueTitleLabel.text = @"优惠补贴";
    [self addSubview:blueTitleLabel];
    self.blueTitleLabel = blueTitleLabel;
    
    
    UILabel *bluePayLabel = [[UILabel alloc] init];
    bluePayLabel.adjustsFontSizeToFitWidth = YES;
    bluePayLabel.font = JXPayLabelFont;
    bluePayLabel.text = @"-¥635";
    [self addSubview:bluePayLabel];
    self.bluePayLabel = bluePayLabel;
    self.bluePayLabel.text = [NSString stringWithFormat:@"-¥%zd", self.allowanceFee];
    
    UIView *blueSeparator = [[UIView alloc] init];
    blueSeparator.backgroundColor = [UIColor blueColor];
    [self addSubview:blueSeparator];
    self.blueSeparator = blueSeparator;
    
    // 运费
    UILabel *greenTitleLabel = [[UILabel alloc] init];
    greenTitleLabel.font = JXTitleLabelFont;
    greenTitleLabel.text = @"运费";
    [self addSubview:greenTitleLabel];
    self.greenTitleLabel = greenTitleLabel;
    
    UILabel *greenPayLabel = [[UILabel alloc] init];
    greenPayLabel.font = JXPayLabelFont;
    greenPayLabel.adjustsFontSizeToFitWidth = YES;
    greenPayLabel.text = @"¥50";
    [self addSubview:greenPayLabel];
    self.greenPayLabel = greenPayLabel;
    self.greenPayLabel.text = [NSString stringWithFormat:@"¥%zd", self.fareFee];
    
    UIView *greenSeparator = [[UIView alloc] init];
    greenSeparator.backgroundColor = [UIColor greenColor];
    [self addSubview:greenSeparator];
    self.greenSeparator = greenSeparator;
    
    // 实付
    UILabel *orangeTitleLabel = [[UILabel alloc] init];
    orangeTitleLabel.font = JXTitleLabelFont;
    orangeTitleLabel.text = @"待付油款";
    [self addSubview:orangeTitleLabel];
    self.orangeTitleLabel = orangeTitleLabel;
    
    UILabel *orangePayLabel = [[UILabel alloc] init];
    orangePayLabel.adjustsFontSizeToFitWidth = YES;
    orangePayLabel.font = JXPayLabelFont;
    orangePayLabel.text = @"¥200000";
    [self addSubview:orangePayLabel];
    self.orangePayLabel = orangePayLabel;
    self.orangePayLabel.text = [NSString stringWithFormat:@"¥%zd", self.actuallyPay];
    
    UIView *orangeSeparator = [[UIView alloc] init];
    orangeSeparator.backgroundColor = [UIColor orangeColor];
    [self addSubview:orangeSeparator];
    self.orangeSeparator = orangeSeparator;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 红包
    CGFloat redTitleLabelW = 70;
    CGFloat redTitleLabelH = 20;
    CGFloat redTitleLabelX = self.jx_width - hoMargin - redTitleLabelW;
    CGFloat redTitleLabelY = alMargin;
    self.redTitleLabel.frame = CGRectMake(redTitleLabelX, redTitleLabelY, redTitleLabelW, redTitleLabelH);
    
    CGFloat redPayLabelX = redTitleLabelX;
    CGFloat redPayLabelY = CGRectGetMaxY(self.redTitleLabel.frame);
    CGFloat redPayLabelW = redTitleLabelW;
    CGFloat redPayLabelH = 20;
    self.redPayLabel.frame = CGRectMake(redPayLabelX, redPayLabelY, redPayLabelW, redPayLabelH);
    
    CGFloat redSeparatorW = 2;
    CGFloat redSeparatorH = redTitleLabelH + redPayLabelH;
    CGFloat redSeparatorX = redPayLabelX - 5 - redSeparatorW;
    CGFloat redSeparatorY = redTitleLabelY;
    self.redSeparator.frame = CGRectMake(redSeparatorX, redSeparatorY, redSeparatorW, redSeparatorH);
    
    self.redRightPoint = CGPointMake(redSeparatorX - 5, redSeparatorY + redSeparatorH*0.5);
    
    // 竖线间的垂直间距
    CGFloat separatorMargin = (self.jx_height - 2*alMargin - 4*redSeparatorH)/3.0;
    
    // 优惠补贴
    CGFloat blueTitleLabelW = redTitleLabelW;
    CGFloat blueTitleLabelH = redTitleLabelH;
    CGFloat blueTitleLabelX = redTitleLabelX;
    CGFloat blueTitleLabelY = CGRectGetMaxY(self.redPayLabel.frame) + separatorMargin;
    self.blueTitleLabel.frame = CGRectMake(blueTitleLabelX, blueTitleLabelY, blueTitleLabelW, blueTitleLabelH);
    
    CGFloat bluePayLabelX = redTitleLabelX;
    CGFloat bluePayLabelY = CGRectGetMaxY(self.blueTitleLabel.frame);
    CGFloat bluePayLabelW = redTitleLabelW;
    CGFloat bluePayLabelH = redTitleLabelH;
    self.bluePayLabel.frame = CGRectMake(bluePayLabelX, bluePayLabelY, bluePayLabelW, bluePayLabelH);
    
    CGFloat blueSeparatorW = redSeparatorW;
    CGFloat blueSeparatorH = redSeparatorH;
    CGFloat blueSeparatorX = redSeparatorX;
    CGFloat blueSeparatorY = blueTitleLabelY;
    self.blueSeparator.frame = CGRectMake(blueSeparatorX, blueSeparatorY, blueSeparatorW, blueSeparatorH);
    
    self.blueRightPoint = CGPointMake(blueSeparatorX - 5, blueSeparatorY + blueSeparatorH*0.5);
    
    // 运费
    CGFloat greenTitleLabelW = redTitleLabelW;
    CGFloat greenTitleLabelH = redTitleLabelH;
    CGFloat greenTitleLabelX = redTitleLabelX;
    CGFloat greenTitleLabelY = CGRectGetMaxY(self.bluePayLabel.frame) + separatorMargin;
    self.greenTitleLabel.frame = CGRectMake(greenTitleLabelX, greenTitleLabelY, greenTitleLabelW, greenTitleLabelH);
    
    CGFloat greenPayLabelX = redTitleLabelX;
    CGFloat greenPayLabelY = CGRectGetMaxY(self.greenTitleLabel.frame);
    CGFloat greenPayLabelW = redTitleLabelW;
    CGFloat greenPayLabelH = redTitleLabelH;
    self.greenPayLabel.frame = CGRectMake(greenPayLabelX, greenPayLabelY, greenPayLabelW, greenPayLabelH);
    
    CGFloat greenSeparatorW = redSeparatorW;
    CGFloat greenSeparatorH = redSeparatorH;
    CGFloat greenSeparatorX = redSeparatorX;
    CGFloat greenSeparatorY = greenTitleLabelY;
    self.greenSeparator.frame = CGRectMake(greenSeparatorX, greenSeparatorY, greenSeparatorW, greenSeparatorH);
    
    self.greenRightPoint = CGPointMake(greenSeparatorX - 5, greenSeparatorY + greenSeparatorH*0.5);
    
    // 待付油款
    CGFloat orangeTitleLabelW = redTitleLabelW;
    CGFloat orangeTitleLabelH = redTitleLabelH;
    CGFloat orangeTitleLabelX = redTitleLabelX;
    CGFloat orangeTitleLabelY = CGRectGetMaxY(self.greenPayLabel.frame) + separatorMargin;
    self.orangeTitleLabel.frame = CGRectMake(orangeTitleLabelX, orangeTitleLabelY, orangeTitleLabelW, orangeTitleLabelH);
    
    CGFloat orangePayLabelX = redTitleLabelX;
    CGFloat orangePayLabelY = CGRectGetMaxY(self.orangeTitleLabel.frame);
    CGFloat orangePayLabelW = redTitleLabelW;
    CGFloat orangePayLabelH = redTitleLabelH;
    self.orangePayLabel.frame = CGRectMake(orangePayLabelX, orangePayLabelY, orangePayLabelW, orangePayLabelH);
    
    CGFloat orangeSeparatorW = redSeparatorW;
    CGFloat orangeSeparatorH = redSeparatorH;
    CGFloat orangeSeparatorX = redSeparatorX;
    CGFloat orangeSeparatorY = orangeTitleLabelY;
    self.orangeSeparator.frame = CGRectMake(orangeSeparatorX, orangeSeparatorY, orangeSeparatorW, orangeSeparatorH);
    
    self.orangeRightPoint = CGPointMake(orangeSeparatorX - 5, orangeSeparatorY + orangeSeparatorH*0.5);
}

- (void)redraw {
    [self setNeedsDisplay];
}

/** 总价 */
- (void)setTotalPrice:(NSInteger)totalPrice {
    _totalPrice = totalPrice;
    
}

/** 红包返利 */
- (void)setRedBagFee:(NSInteger)redBagFee {
    _redBagFee = redBagFee;
    
    if (self.totalPrice == 0) return;
    self.redBagPercentage = redBagFee / 1.0 / self.totalPrice;
}

/** 优惠补贴 */
- (void)setAllowanceFee:(NSInteger)allowanceFee {
    _allowanceFee = allowanceFee;
    
    if (self.totalPrice == 0) return;
    self.allowancePercentage = allowanceFee / 1.0 / self.totalPrice;
}

/** 运费 */
- (void)setFareFee:(NSInteger)fareFee {
    _fareFee = fareFee;
    
    if (self.totalPrice == 0) return;
    self.farePercentage = fareFee / 1.0 / self.totalPrice;
}

/** 待付油款 */
- (void)setActuallyPay:(NSInteger)actuallyPay {
    _actuallyPay = actuallyPay;
    
    if (self.totalPrice == 0) return;
    self.actuallyPaidPercentage = actuallyPay / 1.0 / self.totalPrice;
}

/** 红包返利 */
- (void)setRedBagPercentage:(CGFloat)redBagPercentage {
    _redBagPercentage = redBagPercentage;
    
    [self setNeedsDisplay];
}

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
- (void)setActuallyPaidPercentage:(CGFloat)actuallyPaidPercentage {
    _actuallyPaidPercentage = actuallyPaidPercentage;
    
    [self setNeedsDisplay];
}

- (void)setFreeFare:(BOOL)freeFare {
    _freeFare = freeFare;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    // 获得当前上下文
    CGContextRef ctx =UIGraphicsGetCurrentContext();
    
    if (self.totalPrice == 0) { // 画出提示
        NSString *tipStr = @"请稍后...";
        [tipStr drawInRect:CGRectMake(self.jx_centerX - 30, self.jx_centerY - 10, 60, 20) withAttributes:@{NSFontAttributeName:JXPayLabelFont}];
        CGContextClosePath(ctx);
        
        return;
    }
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self setup];
    [self layoutIfNeeded];
    
    // 现在一圈不是360度，而是
    CGFloat completeAngle = M_PI * 1.9;
    
    // 圆心
    CGPoint center = CGPointMake(hoMargin + circleW*0.5 + radius, self.jx_height*0.5);
    // 外面的点所在圆半径
    CGFloat bigRadius = radius + circleW*0.5 + 10;
    // 中间的折点的基准线
    CGFloat turnX = center.x + radius + circleW*0.5 + 20;
    
    // 红包
    CGFloat redStartAngle = -M_PI_2;
    CGFloat redEndAngle = redStartAngle + self.redBagPercentage * completeAngle;
    [self drawRingWithCenter:center radius:radius startAngle:redStartAngle endAngle:redEndAngle clockwise:YES lineWidth:circleW color:[UIColor redColor]];
    
    // 左边的红点的角度
    CGFloat redBigAngle = (redStartAngle - redEndAngle)*0.5 + redEndAngle;
    self.redLeftPoint = CGPointMake(center.x + bigRadius*cosf(redBigAngle), center.y + bigRadius*sinf(redBigAngle));
    // 画出左边红点
    [self drawDotWithPoint:self.redLeftPoint color:[UIColor redColor]];
    // 画出右边红点
    [self drawDotWithPoint:self.redRightPoint color:[UIColor redColor]];
    
    // 中间的折点
    self.redCenterPoint = CGPointMake(turnX, self.redRightPoint.y);
    // 画出左边点到中间点虚线
    [self drawDottedLineFromPoint:self.redLeftPoint toPoint:self.redCenterPoint withContext:ctx lineColor:[UIColor redColor]];
    // 画出中间点到右边点虚线
    [self drawDottedLineFromPoint:self.redCenterPoint toPoint:self.redRightPoint withContext:ctx lineColor:[UIColor redColor]];
    
    // 优惠补贴
    CGFloat blueStartAngle = redEndAngle;
    CGFloat blueEndAngle = blueStartAngle + self.allowancePercentage * completeAngle;
    [self drawRingWithCenter:center radius:radius startAngle:blueStartAngle endAngle:blueEndAngle clockwise:YES lineWidth:circleW color:[UIColor blueColor]];
    
    // 左边的蓝点的角度
    CGFloat blueBigAngle = (blueStartAngle - blueEndAngle)*0.5 + blueEndAngle;
    self.blueLeftPoint = CGPointMake(center.x + bigRadius*cosf(blueBigAngle), center.y + bigRadius*sinf(blueBigAngle));
    // 画出左边蓝点
    [self drawDotWithPoint:self.blueLeftPoint color:[UIColor blueColor]];
    // 画出右边蓝点
    [self drawDotWithPoint:self.blueRightPoint color:[UIColor blueColor]];
    // 中间的折点
    self.blueCenterPoint = CGPointMake(turnX, self.blueRightPoint.y);
    // 画出左边点到中间点虚线
    [self drawDottedLineFromPoint:self.blueLeftPoint toPoint:self.blueCenterPoint withContext:ctx lineColor:[UIColor blueColor]];
    // 画出中间点到右边点虚线
    [self drawDottedLineFromPoint:self.blueCenterPoint toPoint:self.blueRightPoint withContext:ctx lineColor:[UIColor blueColor]];
    
    // 运费
    CGFloat greenStartAngle = 0;
    CGFloat greenEndAngle = 0;
    if (self.isFreeFare) { // 免运费
        greenStartAngle = blueEndAngle;
    }
    else {
        greenStartAngle = blueEndAngle + blankAngle;
    }
    greenEndAngle = greenStartAngle + self.farePercentage * completeAngle;
    [self drawRingWithCenter:center radius:radius startAngle:greenStartAngle endAngle:greenEndAngle clockwise:YES lineWidth:circleW color:[UIColor greenColor]];
    
    // 左边的绿点的角度
    CGFloat greenBigAngle = (greenStartAngle - greenEndAngle)*0.5 + greenEndAngle;
    self.greenLeftPoint = CGPointMake(center.x + bigRadius*cosf(greenBigAngle), center.y + bigRadius*sinf(greenBigAngle));
    // 画出左边绿点
    [self drawDotWithPoint:self.greenLeftPoint color:[UIColor greenColor]];
    // 画出右边绿点
    [self drawDotWithPoint:self.greenRightPoint color:[UIColor greenColor]];
    
    // 中间的折点
    self.greenCenterPoint = CGPointMake(turnX, self.greenRightPoint.y);
    // 画出左边点到中间点虚线
    [self drawDottedLineFromPoint:self.greenLeftPoint toPoint:self.greenCenterPoint withContext:ctx lineColor:[UIColor greenColor]];
    // 画出中间点到右边点虚线
    [self drawDottedLineFromPoint:self.greenCenterPoint toPoint:self.greenRightPoint withContext:ctx lineColor:[UIColor greenColor]];
    
    // 实付
    CGFloat orangeStartAngle = 0;
    CGFloat orangeEndAngle = 0;
    if (self.isFreeFare) { // 免运费
        orangeStartAngle = greenEndAngle + blankAngle;
    }
    else {
        orangeStartAngle = greenEndAngle;
    }
    orangeEndAngle = orangeStartAngle + self.actuallyPaidPercentage * completeAngle;
    [self drawRingWithCenter:center radius:radius startAngle:orangeStartAngle endAngle:orangeEndAngle clockwise:YES lineWidth:circleW color:[UIColor orangeColor]];
    
    // 左边的橘色点的角度
    CGFloat orangeBigAngle = orangeStartAngle + blankAngle;
    self.orangeLeftPoint = CGPointMake(center.x + bigRadius*cosf(orangeBigAngle), center.y + bigRadius*sinf(orangeBigAngle));
    // 画出左边橘色点
    [self drawDotWithPoint:self.orangeLeftPoint color:[UIColor orangeColor]];
    // 画出右边橘色点
    [self drawDotWithPoint:self.orangeRightPoint color:[UIColor orangeColor]];
    
    // 中间的折点
    self.orangeCenterPoint = CGPointMake(turnX, self.orangeRightPoint.y);
    // 画出左边点到中间点虚线
    [self drawDottedLineFromPoint:self.orangeLeftPoint toPoint:self.orangeCenterPoint withContext:ctx lineColor:[UIColor orangeColor]];
    // 画出中间点到右边点虚线
    [self drawDottedLineFromPoint:self.orangeCenterPoint toPoint:self.orangeRightPoint withContext:ctx lineColor:[UIColor orangeColor]];
    
    CGContextClosePath(ctx);
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
    CGContextSetLineWidth(context, 2.0);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGFloat lengths[] = {2,4};
    CGContextSetLineDash(context, 0, lengths,2);
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
    
}

- (void)drawOilPath {
    UIBezierPath *oilPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(100, 150) radius:60 startAngle:-M_PI_2 - M_PI*0.05 endAngle:M_PI_4 + M_PI_4 * 0.5 + M_PI*0.05 clockwise:NO];
    oilPath.lineWidth= 23;
    oilPath.lineCapStyle = kCGLineCapButt;
    [[UIColor orangeColor] setStroke];
    [oilPath stroke];
}

- (void)drawRedPath {
    UIBezierPath *redPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(100, 150) radius:60 startAngle:-M_PI_2 endAngle:-M_PI_2 + M_PI_4     clockwise:YES];
    redPath.lineWidth= 23;
    redPath.lineCapStyle = kCGLineCapButt;
    [[UIColor redColor] setStroke];
    [redPath stroke];
}

- (void)drawBluePath {
    UIBezierPath *bluePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(100, 150) radius:60 startAngle:-M_PI_2 + M_PI_4 endAngle:M_PI_4     clockwise:YES];
    bluePath.lineWidth= 23;
    bluePath.lineCapStyle = kCGLineCapButt;
    [[UIColor blueColor] setStroke];
    [bluePath stroke];
}

- (void)drawGreenPath {
    UIBezierPath *greenPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(100, 150) radius:60 startAngle:M_PI_4 endAngle:M_PI_4 + M_PI_4 * 0.5     clockwise:YES];
    greenPath.lineWidth= 23;
    greenPath.lineCapStyle = kCGLineCapButt;
    [[UIColor greenColor] setStroke];
    [greenPath stroke];
}

@end
