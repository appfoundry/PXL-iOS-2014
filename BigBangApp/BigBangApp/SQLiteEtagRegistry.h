//
//  SQLiteEtagRegistry.h
//  BigBangApp
//
//  Created by Michael Seghers on 26/04/14.
//  Copyright (c) 2014 PXL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EtagRegistry.h"

@interface SQLiteEtagRegistry : NSObject<EtagRegistry>

+ (instancetype)sharedSQLiteEtagRegistry;

@end
