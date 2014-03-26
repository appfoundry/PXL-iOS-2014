//
//  DetailKeeper.m
//  BigBangApp
//
//  Created by Michael Seghers on 26/03/14.
//  Copyright (c) 2014 PXL. All rights reserved.
//

#import "DetailKeeper.h"
#import "Person.h"

@implementation DetailKeeper

+ (instancetype)sharedDetailKeeper {
    static dispatch_once_t onceToken;
    static DetailKeeper *instance;
    dispatch_once(&onceToken, ^{
        instance = [[DetailKeeper alloc] init];
    });
    return instance;
}

@end
