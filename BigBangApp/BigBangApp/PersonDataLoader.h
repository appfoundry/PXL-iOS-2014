//
//  PersonDataLoader.h
//  BigBangApp
//
//  Created by Michael Seghers on 15/03/14.
//  Copyright (c) 2014 PXL. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CompletionBlock)(NSArray *persons, NSError *error);

@protocol PersonDataLoader <NSObject>

- (void) fetchPersonData:(CompletionBlock) completion;

@end
