//
//  JXFeeRingView.h
//  RoadRescue
//
//  Created by mac on 16/5/20.
//  Copyright © 2016年 mac. All rights reserved.
//  费用百分比圆环

#import <UIKit/UIKit.h>

@protocol JXFeeRingViewDelegate <NSObject>

@optional
- (void)feeRingViewDidClickedReloadButton;

@end

@interface JXFeeRingView : UIView

//+ (instancetype)feeRingViewWithTotalPrice:(CGFloat)totalPrice redBagFee:(CGFloat)redBagFee allowanceFee:(CGFloat)allowanceFee fareFee:(CGFloat)fareFee actuallyPay:(CGFloat)actuallyPay;

+ (instancetype)feeRingViewWithAllowanceFareOilPrice:(CGFloat)allowanceFareOilPrice allowanceFee:(CGFloat)allowanceFee fareFee:(CGFloat)fareFee oilPending:(CGFloat)oilPending;

///** 红包返利 */
//@property (nonatomic, assign) CGFloat redBagFee;

/** 小计 */
@property (nonatomic, assign) CGFloat subtotalFee;
/** 优惠补贴 */
@property (nonatomic, assign) CGFloat allowanceFee;
/** 运费 */
@property (nonatomic, assign) CGFloat fareFee;
/** 待付油款 */
@property (nonatomic, assign) CGFloat oilPending;
/** 优惠+运费+待付油款 */
@property (nonatomic, assign) CGFloat allowanceFareOilPrice;
/** 实际应付 */
@property (nonatomic, assign) CGFloat totalPending;

- (void)redraw;

/** 是否免运费 */
//@property (nonatomic, assign, getter=isFreeFare) BOOL freeFare;

///** 红包占总额比 */
//@property (nonatomic, assign) CGFloat redBagPercentage;
/** 优惠占总额比 */
@property (nonatomic, assign) CGFloat allowancePercentage;
/** 运费占总额比 */
@property (nonatomic, assign) CGFloat farePercentage;
/** 待付油款占总额比 */
@property (nonatomic, assign) CGFloat oilPendingPercentage;
/** 提示 */
@property (nonatomic, copy) NSString *tipStr;
/** 设置加载油价数据是否成功，以显示不同的提示 */
- (void)setLoadSuccess:(BOOL)loadSuccess message:(NSString *)message;

@property (nonatomic, weak) id<JXFeeRingViewDelegate> delegate;

@end
