//
//  JXSkinTool.h
//  RoadRescue
//
//  Created by mac on 16/5/24.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JXSkinTool : NSObject

/**
 *  设置皮肤类型
 */
+ (void)setSkinType:(NSString *)type;

/**
 *  通过图片名获得当前皮肤下的image
 *
 *  @param name 要用的图片名
 */
+ (UIImage *)skinToolImageWithImageName:(NSString *)name;

/**
 *  通过控件的关键字获取该控件的颜色
 *
 *  @param key 控件关键字(如：order_button_bg, order_button_text, rescue_label_bg)
 *
 *  @return 该控件的颜色(背景色，字体颜色)
 */
+ (UIColor *)skinToolColorWithKey:(NSString *)key;

@end
