//
//  NSArray+Functional.m
//  BigBangApp
//
//  Created by Michael Seghers on 02/04/14.
//  Copyright (c) 2014 PXL. All rights reserved.
//

#import "NSArray+Functional.h"

@implementation NSArray (Functional)

- (NSArray *)fun_arrayByUsingTransformer:(Transformer)tranformer {
    NSMutableArray *mutable = [NSMutableArray arrayWithCapacity:self.count];
    for (id element in self) {
        id result = tranformer(element);
        [mutable addObject:result];
    }
    return [mutable copy];
}

@end
