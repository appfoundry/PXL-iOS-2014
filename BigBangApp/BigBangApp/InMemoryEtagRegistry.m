//
//  InMemoryEtagRegistry.m
//  BigBangApp
//
//  Created by Michael Seghers on 26/04/14.
//  Copyright (c) 2014 PXL. All rights reserved.
//

#import "InMemoryEtagRegistry.h"

@interface InMemoryEtagRegistry () {
    NSMutableDictionary *_etagDictionary;
}

@end

@implementation InMemoryEtagRegistry

+(instancetype)sharedInMemoryEtagRegistry {
    static InMemoryEtagRegistry *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[InMemoryEtagRegistry alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _etagDictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (NSString *)etagForURL:(NSURL *)url {
    return _etagDictionary[url];
}

- (void)persistEtag:(NSString *)etag forURL:(NSURL *)url {
    _etagDictionary[url] = etag;
}

@end
