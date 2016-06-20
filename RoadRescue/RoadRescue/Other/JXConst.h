//
//  JXConst.h
//
//  Created by apple on 14-10-25.
//  Copyright (c) 2014年. All rights reserved.
//

#import <UIKit/UIKit.h>


// 通知
// 用户下完订单时发出的通知
UIKIT_EXTERN NSString * const JXPlaceAnOrderNotification;
// 上面的通知用来传递新订单对象的key
UIKIT_EXTERN NSString * const JXNewOrderDetailKey;


// 修改皮肤时发送的通知
UIKIT_EXTERN NSString * const JXChangedSkinNotification;
// 普通皮肤类型的字符串
UIKIT_EXTERN NSString * const JXSkinTypeOriginStr;
// 碳纤维皮肤类型的字符串
UIKIT_EXTERN NSString * const JXSkinTypeBrickStr;
// 木纹皮肤类型的字符串
UIKIT_EXTERN NSString * const JXSkinTypeWoodStr;
