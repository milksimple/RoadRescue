//
//  JXSkinTool.m
//  RoadRescue
//
//  Created by mac on 16/5/24.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "JXSkinTool.h"

@implementation JXSkinTool
/** 皮肤类型：原版origin，砖块brick，木纹wood */
static NSString *_type;
static NSString * const JXSkinKey = @"skinType";

+ (void)initialize {
    _type = [JXUserDefaults objectForKey:JXSkinKey];
    if (_type == nil) {
        _type = @"origin";
    }
}

+ (void)setSkinType:(NSString *)type {
    _type = type;
    
    [JXUserDefaults setObject:type forKey:JXSkinKey];
    [JXUserDefaults synchronize];
}

+ (UIImage *)skinToolImageWithImageName:(NSString *)name {
    NSString *imageName = [NSString stringWithFormat:@"skin/%@/%@", _type, name];
    UIImage *image = [UIImage imageNamed:imageName];
    return image;
}

/**
 *  通过控件的关键字获取该控件的颜色
 *
 *  @param key 控件关键字(如：order_button_bg, order_button_text, rescue_label_bg)
 *
 *  @return 该控件的颜色(背景色，字体颜色)
 */
+ (UIColor *)skinToolColorWithKey:(NSString *)key {
    // 存储颜色的plist文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"skin/%@/color.plist", _type] ofType:nil];
    NSDictionary *colorDict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSString *colorStr = colorDict[key];
    NSArray *rgbArray = [colorStr componentsSeparatedByString:@","];
    NSInteger r = [rgbArray[0] integerValue];
    NSInteger g = [rgbArray[1] integerValue];
    NSInteger b = [rgbArray[2] integerValue];
    
    return JXColor(r, g, b);
}

@end
