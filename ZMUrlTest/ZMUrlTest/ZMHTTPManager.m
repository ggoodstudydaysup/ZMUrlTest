//
//  ZMHTTPManager.m
//  ZMUrlTest
//
//  Created by M Z on 2023/4/5.
//  Copyright © 2023 M Z. All rights reserved.
//

#import "ZMHTTPManager.h"

@interface ZMHTTPManager ()



@end

@implementation ZMHTTPManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static ZMHTTPManager *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ZMHTTPManager alloc] init];
        sharedInstance.semaphore = dispatch_semaphore_create(0);
        sharedInstance.minDuration = 1000000.f;
    });
    return sharedInstance;
}

- (void)startLoadingURL:(NSString *)url response:(LoadUrlResponseBlock)responseBlock
{
    if (![self isStringValid:url]) {
        return;
    }
    NSString *baseURL = url;
    self.preMinUrl = url;
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.protocolClasses = @[NSClassFromString(@"ZMURLProtocol")];
    
    NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *dataTask = [urlSession dataTaskWithURL:[NSURL URLWithString:baseURL] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error)
        {
            NSDictionary *jsondict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if (jsondict)
            {
                
            }
//            NSLog(@"response:%@ - jsondict:%@", response, jsondict);
        }
        else
        {
//            NSLog(@"error:%@", error);
        }
    }];
    
    [dataTask resume];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
        if (responseBlock) {
            responseBlock(self.duration);
        }
    });
    
    
}

- (BOOL)isStringValid:(NSString *)str
{
    if (!str || [str isKindOfClass:[NSString class]] == NO || str.length == 0)
    {
        return NO;
    }
    
    return YES;
}

@end
