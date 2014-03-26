//
//  main.m
//  CLI
//
//  Created by Michael Seghers on 26/03/14.
//  Copyright (c) 2014 iDA MediaFoundry. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef id(^Transformer)(id);

@interface NSArray(Blocks)

- (NSArray *) transFormWithBlock:(Transformer) tranformer;

@end

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        // insert code here...
        NSLog(@"Hello, World!");
        
        NSString *prefix = @"Hello ";
        NSArray *strings = @[@"Roel", @"Nico", @"Toon", @"Walter", @"Bernd", @"Kristof", @"Joris", @"Tom", @"Marco", @"Ninja", @"Sander", @"Kenny"];
        
        
        Transformer toLowerBlock = ^(id elem){
            return [elem lowercaseString];
        };
        Transformer prefixBlock = ^id(id elem) {
            return [prefix stringByAppendingString:elem];
        };
        
        
        NSArray *result = [[strings transFormWithBlock:toLowerBlock] transFormWithBlock:prefixBlock];
        
        NSLog(@"Result: %@", result);
        
    }
    return 0;
}

@implementation NSArray(Blocks)

- (NSArray *)transFormWithBlock:(Transformer)transformer {
    NSMutableArray *transformed = [[NSMutableArray alloc] initWithCapacity:self.count];
    for (id elem in self) {
        [transformed addObject:transformer(elem)];
    }
    return [transformed copy];
}

@end

