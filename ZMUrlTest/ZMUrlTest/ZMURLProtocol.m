//
//  ZMURLProtocol.m
//  ZMUrlTest
//
//  Created by M Z on 2023/4/5.
//  Copyright © 2023 M Z. All rights reserved.
//

#import "ZMURLProtocol.h"
#import "ZMHTTPManager.h"

static NSString * const ZMURLProtocolKey = @"ZMURLProtocolKey";

@interface ZMURLProtocol () <NSURLSessionDelegate>

@property (nonatomic, strong) NSURLSessionDataTask *task;

@property (nonatomic) NSTimeInterval startTime;

@end

@implementation ZMURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    if (!request) {
        return NO;
    }
    
    NSURL *url = [request URL];
    if (!url) {
        return NO;
    }
    
    if ([NSURLProtocol propertyForKey:ZMURLProtocolKey inRequest:request]) {
        return NO;
    }
    
    NSString *scheme = [[[request URL] scheme] lowercaseString];
    if ([scheme caseInsensitiveCompare:@"http"] == NSOrderedSame ||
        [scheme caseInsensitiveCompare:@"https"] == NSOrderedSame) {
        return YES;
    }
    
    return NO;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
    NSMutableURLRequest *mutableReqeust = [request mutableCopy];
    [NSURLProtocol setProperty:@YES forKey:ZMURLProtocolKey inRequest:mutableReqeust];
    return [mutableReqeust copy];
}

- (void)startLoading
{
    NSMutableURLRequest *mutableReqeust = [[self request] mutableCopy];
    [NSURLProtocol setProperty:@YES forKey:ZMURLProtocolKey inRequest:mutableReqeust];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    self.task = [session dataTaskWithRequest:self.request];
    [self.task resume];
    self.startTime = CFAbsoluteTimeGetCurrent();
}

- (void)stopLoading
{
    if (self.task != nil) {
        [self.task cancel];
        self.task = nil;
    }
}

#pragma mark SessionDelegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    NSTimeInterval urlDuration = (CFAbsoluteTimeGetCurrent() - self.startTime)*1000.0;
//    NSLog(@"响应时间：%f 毫秒（MS）", urlDuration);
    [ZMHTTPManager sharedInstance].duration = urlDuration;
    if (urlDuration < [ZMHTTPManager sharedInstance].minDuration) {
        [ZMHTTPManager sharedInstance].minDuration = urlDuration;
        [ZMHTTPManager sharedInstance].minUrl = [ZMHTTPManager sharedInstance].preMinUrl;
        
    }
    
    dispatch_semaphore_signal([ZMHTTPManager sharedInstance].semaphore);
    
//    NSLog(@"== didReceiveResponse:%@", response);
    [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
//    NSLog(@"== didReceiveData:%@", data);
    [[self client] URLProtocol:self didLoadData:data];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error {
//    NSLog(@"== didCompleteWithError:%@", error);
    [self.client URLProtocolDidFinishLoading:self];
}

+ (BOOL)registerURLProtocol
{
    return [NSURLProtocol registerClass:[ZMURLProtocol class]];
}

@end
