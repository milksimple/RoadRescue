//
//  JXConst.m
//
//  Created by apple on 14-10-25.
//  Copyright (c) 2014年 All rights reserved.
//

#import <UIKit/UIKit.h>

// 通知
// 企业印象的点赞按钮被点击时发出的通知
NSString * const JXPlaceAnOrderNotification = @"JXPlaceAnOrderNotification";
NSString * const JXOrderDetailKey = @"JXOrderDetailKey";

// 用户成功取消订单时发出的通知
NSString * const JXCancelAnOrderNotification = @"JXCancelAnOrderNotification";
NSString * const JXCancelOrderDetailKey = @"JXCancelOrderDetailKey";

// 修改皮肤时发送的通知
NSString * const JXChangedSkinNotification = @"JXChangedSkinNotification";
// 普通皮肤类型的字符串
NSString * const JXSkinTypeOriginStr = @"origin_ios";
//// 碳纤维皮肤类型的字符串
//NSString * const JXSkinTypeBrickStr = @"brick_ios";;
//// 木纹皮肤类型的字符串
//NSString * const JXSkinTypeWoodStr = @"wood_ios";
// 存储正在使用的皮肤的名称Key
NSString * const JXUsingSkinKey = @"skinType";

// 存储皮肤数组的json数据
NSString * const JXSkinsJsonKey = @"JXSkinsJsonKey";

// 订单成功完成时发出的通知
NSString * const JXOrderSuccessFinishedNotification = @"JXOrderSuccessFinishedNotification";

// 登录成功的通知
NSString * const JXSuccessLoginNotification = @"JXSuccessLoginNotification";
// 注销成功的通知
NSString * const JXSuccessLogoutNotification = @"JXSuccessLogoutNotification";