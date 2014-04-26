//
//  PersonCD.h
//  BigBangApp
//
//  Created by Michael Seghers on 26/04/14.
//  Copyright (c) 2014 PXL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PersonCD : NSManagedObject

@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * profession;
@property (nonatomic, retain) NSString * bio;
@property (nonatomic, retain) NSString * websiteUrl;
@property (nonatomic, retain) NSString * imageName;
@property (nonatomic, retain) NSString * realName;
@property (nonatomic, retain, readonly) NSString * fullName;

@end
