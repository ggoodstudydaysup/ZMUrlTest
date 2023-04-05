//
//  ZMHTTPManager.h
//  ZMUrlTest
//
//  Created by M Z on 2023/4/5.
//  Copyright © 2023 M Z. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^LoadUrlResponseBlock)(NSTimeInterval duration);


@interface ZMHTTPManager : NSObject

@property (nonatomic, strong) dispatch_semaphore_t semaphore;

@property (nonatomic) NSTimeInterval duration;

@property (nonatomic) NSTimeInterval minDuration;

@property (nonatomic, strong) NSString *preMinUrl;

@property (nonatomic, strong) NSString *minUrl;


+ (instancetype)sharedInstance;

- (void)startLoadingURL:(NSString *)url response:(LoadUrlResponseBlock)responseBlock;

@end
