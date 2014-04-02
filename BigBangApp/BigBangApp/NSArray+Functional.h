//
//  NSArray+Functional.h
//  BigBangApp
//
//  Created by Michael Seghers on 02/04/14.
//  Copyright (c) 2014 PXL. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef id(^Transformer)(id);

@interface NSArray (Functional)

- (NSArray *) fun_arrayByUsingTransformer:(Transformer) tranformer;

@end
