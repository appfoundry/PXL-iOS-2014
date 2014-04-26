//
//  CoreDataLocalPersonService.m
//  BigBangApp
//
//  Created by Michael Seghers on 26/04/14.
//  Copyright (c) 2014 PXL. All rights reserved.
//

#import "CoreDataLocalPersonService.h"
#import <CoreData/CoreData.h>
#import "NSArray+Functional.h"
#import "Person.h"
#import "PersonCD.h"

@interface CoreDataLocalPersonService ()

@end

@implementation CoreDataLocalPersonService

@synthesize managedObjectContext = _moc;

+ (instancetype)sharedCoreDataLocalPersonService {
    static CoreDataLocalPersonService *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CoreDataLocalPersonService alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"BigBangModel" withExtension:@"momd"];
        NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:url];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDir = paths.firstObject;
        NSString *dbFilePath = [documentDir stringByAppendingPathComponent:@"bigbangdata.sqlite"];
        
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
        NSError *error;
        if ([psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:dbFilePath] options:nil error:&error]) {
            _moc = [[NSManagedObjectContext alloc] init];
            _moc.persistentStoreCoordinator = psc;
        } else {
            NSLog(@"Persistence store could not be created: %@", error);
            self = nil;
        }
    }
    return self;
}

- (BOOL)hasPersons {
    NSError *error;
    NSUInteger count = [_moc countForFetchRequest:self.fetchRequestForPersons error:&error];
    if (error) {
        count = 0;
    }
    return count != 0;
}

- (NSArray *)persons {
    NSError *error;
    NSArray *persons = [_moc executeFetchRequest:self.fetchRequestForPersons error:&error];
    return persons;
}

- (id)personWithId:(NSString *) identifier {
    NSError *error;
    NSFetchRequest *fr = self.fetchRequestForPersons;
    fr.predicate = [NSPredicate predicateWithFormat:@"identifier like %@", identifier];
    NSArray *persons = [_moc executeFetchRequest:fr error:&error];
    return persons.firstObject;
}


- (NSFetchRequest *) fetchRequestForPersons {
    return [[NSFetchRequest alloc] initWithEntityName:@"PersonCD"];
}

- (void)persistPersons:(NSArray *)persons {
    NSError *error;
    [persons fun_arrayByUsingTransformer:^PersonCD *(Person *person) {
        PersonCD *pcd = [NSEntityDescription insertNewObjectForEntityForName:@"PersonCD" inManagedObjectContext:_moc];
        pcd.identifier = person.identifier;
        pcd.firstName = person.firstName;
        pcd.lastName = person.lastName;
        pcd.bio = person.bio;
        pcd.realName = person.realName;
        pcd.profession = person.profession;
        pcd.imageName = person.imageName;
        pcd.websiteUrl = person.websiteUrl;
        return pcd;
    }];
    [_moc save:&error];
}

@end
