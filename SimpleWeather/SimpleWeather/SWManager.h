//
//  SWManager.h
//  SimpleWeather
//
//  Created by hanxu on 15/11/2.
//  Copyright © 2015年 __zimu. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;
#import "SWCondition.h"

@interface SWManager : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong, readonly) CLLocation *currentLocation;
@property (nonatomic, strong, readonly) SWCondition *currentCondition;
@property (nonatomic, strong, readonly) NSArray *hourlyForecast;
@property (nonatomic, strong, readonly) NSArray *dailyForecast;

+ (instancetype)sharedManager;

- (void)findCurrentLocation;
@end
