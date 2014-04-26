//
//  LocalPersonService.h
//  BigBangApp
//
//  Created by Michael Seghers on 26/04/14.
//  Copyright (c) 2014 PXL. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LocalPersonService <NSObject>

- (BOOL) hasPersons;
- (NSArray *) persons;
- (void) persistPersons:(NSArray *)persons;

@end
