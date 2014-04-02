//
//  BundlePersonDataLoader.m
//  BigBangApp
//
//  Created by Michael Seghers on 15/03/14.
//  Copyright (c) 2014 PXL. All rights reserved.
//

#import "BundlePersonDataLoader.h"
#import "Person.h"
#import "NSArray+Functional.h"

@implementation BundlePersonDataLoader

- (void)fetchPersonData:(void (^)(NSArray *, NSError *))completion {
    NSOperation *longRunningOperation = [NSBlockOperation blockOperationWithBlock:^{
        NSBundle *mainBundle = [NSBundle mainBundle];
        NSArray *persons = [@[@"howard", @"leonard", @"penny", @"rajesh", @"sheldon"] fun_arrayByUsingTransformer:^Person *(NSString *personName) {
            NSString *path = [mainBundle pathForResource:personName ofType:@"plist"];
            return [Person personWithContentsOfFile:path];
        }];
        
        
        NSOperation *backToMain = [NSBlockOperation blockOperationWithBlock:^{
            completion(persons, nil);
        }];
        [[NSOperationQueue mainQueue] addOperation:backToMain];
    }];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:longRunningOperation];
}

@end
