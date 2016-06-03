//
//  JXAnnotation.h
//  RoadRescueTeam
//
//  Created by mac on 16/6/1.
//  Copyright © 2016年 mac. All rights reserved.
//  大头针

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface JXAnnotation : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@property (nonatomic, copy, nullable) NSString *title;
@property (nonatomic, copy, nullable) NSString *subtitle;

@end
