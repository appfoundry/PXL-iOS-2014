//
//  BundlePersonDataLoader.m
//  BigBangApp
//
//  Created by Michael Seghers on 15/03/14.
//  Copyright (c) 2014 PXL. All rights reserved.
//

#import "BundlePersonDataLoader.h"
#import "Person.h"

@implementation BundlePersonDataLoader

- (void)fetchPersonData:(void (^)(NSArray *, NSError *))completion {
    NSOperation *longRunningOperation = [NSBlockOperation blockOperationWithBlock:^{
        NSMutableArray *temp = [NSMutableArray array];
        NSBundle *mainBundle = [NSBundle mainBundle];
        NSArray *personNames = @[@"howard", @"leonard", @"penny", @"rajesh", @"sheldon"];
        for (NSString *name in personNames) {
            NSString *path = [mainBundle pathForResource:name ofType:@"plist"];
            Person *p = [Person personWithContentsOfFile:path];
            [temp addObject:p];
        }
        
        NSOperation *backToMain = [NSBlockOperation blockOperationWithBlock:^{
            completion([temp copy], nil);
        }];
        [[NSOperationQueue mainQueue] addOperation:backToMain];
    }];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:longRunningOperation];
}

@end
