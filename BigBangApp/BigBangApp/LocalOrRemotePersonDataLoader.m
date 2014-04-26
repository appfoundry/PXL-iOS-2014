//
//  LocalOrRemotePersonDataLoader.m
//  BigBangApp
//
//  Created by Michael Seghers on 26/04/14.
//  Copyright (c) 2014 PXL. All rights reserved.
//

#import "LocalOrRemotePersonDataLoader.h"
#import "RemotePersonDataLoader.h"
#import "CoreDataLocalPersonService.h"

@interface LocalOrRemotePersonDataLoader () {
    id<PersonDataLoader> _remotePDL;
    id<LocalPersonService> _localPS;
}

@end

@implementation LocalOrRemotePersonDataLoader

+(instancetype)sharedLocalOrRemotePersonDataLoader {
    static LocalOrRemotePersonDataLoader *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LocalOrRemotePersonDataLoader alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _remotePDL = [RemotePersonDataLoader sharedRemotePersonDataLoader];
        _localPS = [CoreDataLocalPersonService sharedCoreDataLocalPersonService];
    }
    return self;
}

- (void)fetchPersonData:(CompletionBlock)completion {
    if ([_localPS hasPersons]) {
        completion([_localPS persons], nil);
    } else {
        [_remotePDL fetchPersonData:^(NSArray *persons, NSError *error) {
            [_localPS persistPersons:persons];
            completion([_localPS persons], nil);
        }];
    }
}

@end
