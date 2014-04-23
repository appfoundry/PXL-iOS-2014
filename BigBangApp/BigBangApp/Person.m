//
//  Person.m
//  BigBangApp
//
//  Created by Michael Seghers on 15/03/14.
//  Copyright (c) 2014 PXL. All rights reserved.
//

#import "Person.h"


@implementation Person

@synthesize lastName = _lastName;

+ (instancetype)personWithFirstName:(NSString *)firstName andLastName:(NSString *)lastName {
    return [[Person alloc] initWithFirstName:firstName andLastName:lastName];
}

+ (instancetype)personWithContentsOfFile:(NSString *)path {
    return [[Person alloc] initWithContentsOfFile:path];
}

+ (instancetype)personWithJSONDictionary:(NSDictionary *)jsonDictionary {
    return [[Person alloc] initWithJSONDictionary:jsonDictionary];
}

- (instancetype)initWithFirstName:(NSString *)firstName andLastName:(NSString *)lastName
{
    self = [super init];
    if (self) {
        self.firstName = firstName;
        self.lastName = lastName;
    }
    return self;
}

- (instancetype)initWithContentsOfFile:(NSString *)path {
    NSDictionary *personDict = [NSDictionary dictionaryWithContentsOfFile:path];
    if (personDict) {
        self = [self initWithFirstName:personDict[@"name"] andLastName:personDict[@"lastName"]];
        if (self) {
            self.bio = personDict[@"bio"];
            self.profession = personDict[@"profession"];
            self.websiteUrl = personDict[@"website"];
            self.realName = personDict[@"realName"];
            self.identifier = personDict[@"id"];
            self.imageName = personDict[@"imageName"];
        }
    } else {
        self = nil;
    }
    return self;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *) jsonDictionary {
    if (jsonDictionary) {
        self = [self initWithFirstName:jsonDictionary[@"name"] andLastName:jsonDictionary[@"lastName"]];
        if (self) {
            self.bio = jsonDictionary[@"bio"];
            self.profession = jsonDictionary[@"profession"];
            self.websiteUrl = jsonDictionary[@"url"];
            self.realName = jsonDictionary[@"realName"];
            self.identifier = jsonDictionary[@"id"];
            self.imageName = jsonDictionary[@"imageUri"];
        }
    } else {
        self = nil;
    }
    return self;
}

- (void)setFirstName:(NSString *)firstName {
    if (![_firstName isEqualToString:firstName]) {
        _firstName = firstName;
        _fullName = [NSString stringWithFormat:@"%@ %@", _firstName, self.lastName];
    }
}

- (void)setLastName:(NSString *)lastName {
    if (![_lastName isEqualToString:lastName]) {
        _lastName = lastName;
        _fullName = [NSString stringWithFormat:@"%@ %@", self.firstName, _lastName];
    }
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@: %@", [super description], self.fullName];
}

@end
