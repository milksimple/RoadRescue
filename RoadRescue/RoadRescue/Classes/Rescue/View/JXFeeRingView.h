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

+ (instancetype)feeRingViewWithTotalPrice:(CGFloat)totalPrice redBagFee:(CGFloat)redBagFee allowanceFee:(CGFloat)allowanceFee fareFee:(CGFloat)fareFee actuallyPay:(CGFloat)actuallyPay;

/** 红包返利 */
@property (nonatomic, assign) CGFloat redBagFee;
/** 优惠补贴 */
@property (nonatomic, assign) CGFloat allowanceFee;
/** 运费 */
@property (nonatomic, assign) CGFloat fareFee;
/** 待付油款 */
@property (nonatomic, assign) CGFloat actuallyPay;
/** 总价 */
@property (nonatomic, assign) CGFloat totalPrice;

- (void)redraw;

/** 是否免运费 */
@property (nonatomic, assign, getter=isFreeFare) BOOL freeFare;

/** 红包占总额比 */
@property (nonatomic, assign) CGFloat redBagPercentage;
/** 优惠占总额比 */
@property (nonatomic, assign) CGFloat allowancePercentage;
/** 运费占总额比 */
@property (nonatomic, assign) CGFloat farePercentage;
/** 实付占总额比 */
@property (nonatomic, assign) CGFloat actuallyPaidPercentage;
/** 提示 */
@property (nonatomic, copy) NSString *tipStr;
/** 加载油价数据是否成功 */
@property (nonatomic, assign, getter=isLoadSuccess) BOOL loadSuccess;

@property (nonatomic, weak) id<JXFeeRingViewDelegate> delegate;

@end
