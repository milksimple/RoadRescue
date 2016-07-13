//
//  JXLoadTipView.h
//  Fellow
//
//  Created by mac on 16/3/28.
//  Copyright © 2016年 mac. All rights reserved.
//  重新加载提示页面

typedef enum {
    JXLoadTipViewTypeHasReloadButton = 0, // 有重新加载按钮
    JXLoadTipViewTypeNoReloadButton // 没有重新加载按钮

} JXLoadTipViewType;

#import <UIKit/UIKit.h>

@protocol JXLoadTipViewDelegate <NSObject>

@optional
- (void)loadTipViewDidClickedReloadButton;

@end

@interface JXLoadTipView : UIView

+ (instancetype)loadTipView;

+ (instancetype)loadTipViewWithType:(JXLoadTipViewType)type;

@property (nonatomic, weak) id<JXLoadTipViewDelegate> delegate;
/** 提示view的标题 */
@property (nonatomic, copy) NSString *tipTitle;
/** tipView类型 */
@property (nonatomic, assign) JXLoadTipViewType type;

/**
 *  显示重新加载提示页面到toView
 */
- (void)showTipViewToView:(UIView *)toView;

/**
 *  显示重新加载提示页面
 *
 *  @param toView 要显示的页面
 *  @param bottom 希望tipview距离底部的距离
 */
- (void)showTipViewToView:(UIView *)toView bottom:(CGFloat)bottom;

- (void)dismiss;
@end
