//
//  JXSkin.m
//  RoadRescue
//
//  Created by mac on 16/6/29.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "JXSkin.h"

@implementation JXSkin

- (void)setSkinPath:(NSString *)skinPath {
    _skinPath = skinPath;
    
    self.packageName = [skinPath.lastPathComponent stringByDeletingPathExtension];
}

@end
