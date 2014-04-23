//
//  PersonListConnectionDelegate.h
//  BigBangApp
//
//  Created by Michael Seghers on 23/04/14.
//  Copyright (c) 2014 PXL. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^PersonListCompletionBlock)(id result, NSError *error);

@interface PersonListConnectionDelegate : NSObject<NSURLConnectionDataDelegate, NSURLConnectionDelegate>

- (instancetype) initWithCompletion:(PersonListCompletionBlock) completion;

@end
