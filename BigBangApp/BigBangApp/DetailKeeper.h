//
//  DetailKeeper.h
//  BigBangApp
//
//  Created by Michael Seghers on 26/03/14.
//  Copyright (c) 2014 PXL. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Person;

@interface DetailKeeper : NSObject

@property(strong) Person* selectedPerson;

+ (instancetype) sharedDetailKeeper;

@end
