//
//  PersonCD.m
//  BigBangApp
//
//  Created by Michael Seghers on 26/04/14.
//  Copyright (c) 2014 PXL. All rights reserved.
//

#import "PersonCD.h"


@implementation PersonCD

@dynamic identifier;
@dynamic firstName;
@dynamic lastName;
@dynamic profession;
@dynamic bio;
@dynamic websiteUrl;
@dynamic imageName;
@dynamic realName;

- (NSString *) fullName {
    return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}

@end
