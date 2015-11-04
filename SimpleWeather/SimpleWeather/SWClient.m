//
//  SWClient.m
//  SimpleWeather
//
//  Created by hanxu on 15/11/3.
//  Copyright © 2015年 __zimu. All rights reserved.
//

#import "SWClient.h"
#import "MTLJSONAdapter.h"

@interface SWClient()

@property (nonatomic, strong) NSURLSession *session;

@end


@implementation SWClient

- (instancetype)init {
    if (self = [super init]) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config];
    }
    return self;
}


- (RACSignal *)fetchCurrentConditionsForLocation:(CLLocationCoordinate2D)coordinate {
    
    NSString *urlString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f&units=imperial", coordinate.latitude, coordinate.longitude];
    NSURL *url = [NSURL URLWithString:urlString];

    return [[self fetchJSONFromURL:url] map:^id(NSDictionary *json) {
        
        return [MTLJSONAdapter modelOfClass:[SWCondition class] fromJSONDictionary:json error:nil];
    }];
}

- (RACSignal *)fetchHourlyForecastForLocation:(CLLocationCoordinate2D)coordinate {
    
    NSString *urlString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast?lat=%f&lon=%f&units=imperial&cnt=12",coordinate.latitude, coordinate.longitude];
    NSURL *url = [NSURL URLWithString:urlString];
    
    return [[self fetchJSONFromURL:url] map:^id(NSDictionary *json) {
        RACSequence *list = [json[@"list"] rac_sequence];
        
        return [[list map:^id(NSDictionary *item) {
            return [MTLJSONAdapter modelOfClass:[SWCondition class] fromJSONDictionary:item error:nil];
        }] array];
    }];
}

- (RACSignal *)fetchDailyForecastForLocation:(CLLocationCoordinate2D)coordinate {
    
    NSString *urlString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast/daily?lat=%f&lon=%f&units=imperial&cnt=7",coordinate.latitude, coordinate.longitude];
    NSURL *url = [NSURL URLWithString:urlString];
    
    return [[self fetchJSONFromURL:url] map:^id(NSDictionary *json) {
        RACSequence *list = [json[@"list"] rac_sequence];
        
        return [[list map:^id(NSDictionary *item) {
            return [MTLJSONAdapter modelOfClass:[SWDailyForecast class] fromJSONDictionary:item error:nil];
        }] array];
    }];
}

///请求的基本方法  -> request in afn
- (RACSignal *)fetchJSONFromURL:(NSURL *)url {
    
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            if (!error) {
                NSError *jsonError = nil;
                id json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
                if (!jsonError) {
                    [subscriber sendNext:json];
                } else {
                    [subscriber sendError:jsonError];
                }
            }
            else {
                [subscriber sendError:error];
            }
            [subscriber sendCompleted];
        }];
        [dataTask resume];
        
        /// RACDisposable 处理 信号被摧毁时的 清理工作
        return [RACDisposable disposableWithBlock:^{
            [dataTask cancel];
        }];
        //side effect -> 副作用  记录错误
    }] doError:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

@end
