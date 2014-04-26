//
//  CoreDataLocalPersonService.h
//  BigBangApp
//
//  Created by Michael Seghers on 26/04/14.
//  Copyright (c) 2014 PXL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocalPersonService.h"

@class NSFetchRequest;

@interface CoreDataLocalPersonService : NSObject<LocalPersonService>

@property(nonatomic, readonly) NSManagedObjectContext *managedObjectContext;
@property(nonatomic, readonly) NSFetchRequest *fetchRequestForPersons;

+(instancetype)sharedCoreDataLocalPersonService;

@end
