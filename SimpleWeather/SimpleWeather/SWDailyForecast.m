//
//  SWDailyForecast.m
//  SimpleWeather
//
//  Created by hanxu on 15/11/2.
//  Copyright © 2015年 __zimu. All rights reserved.
//

#import "SWDailyForecast.h"

@implementation SWDailyForecast

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    // 1
    NSMutableDictionary *paths = [[super JSONKeyPathsByPropertyKey] mutableCopy];
    // 2
    paths[@"tempHigh"] = @"temp.max";
    paths[@"tempLow"] = @"temp.min";
    // 3
    return paths;
}
@end
