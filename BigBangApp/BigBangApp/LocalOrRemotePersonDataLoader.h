//
//  LocalOrRemotePersonDataLoader.h
//  BigBangApp
//
//  Created by Michael Seghers on 26/04/14.
//  Copyright (c) 2014 PXL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PersonDataLoader.h"

@interface LocalOrRemotePersonDataLoader : NSObject<PersonDataLoader>

+(instancetype)sharedLocalOrRemotePersonDataLoader;

@end
