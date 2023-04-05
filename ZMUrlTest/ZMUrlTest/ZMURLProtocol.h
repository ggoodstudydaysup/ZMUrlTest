//
//  ZMURLProtocol.h
//  ZMUrlTest
//
//  Created by M Z on 2023/4/5.
//  Copyright © 2023 M Z. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZMURLProtocol : NSURLProtocol

+ (BOOL)registerURLProtocol;

@end

NS_ASSUME_NONNULL_END
