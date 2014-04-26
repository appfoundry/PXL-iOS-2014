//
//  SQLiteEtagRegistry.m
//  BigBangApp
//
//  Created by Michael Seghers on 26/04/14.
//  Copyright (c) 2014 PXL. All rights reserved.
//

#import "SQLiteEtagRegistry.h"
#import <sqlite3.h>

@interface SQLiteEtagRegistry () {
    sqlite3 *_db;
}

@end

@implementation SQLiteEtagRegistry

+(instancetype)sharedSQLiteEtagRegistry {
    static dispatch_once_t onceToken;
    static SQLiteEtagRegistry *instance;
    dispatch_once(&onceToken, ^{
        instance = [[SQLiteEtagRegistry alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDir = paths.firstObject;
        NSString *dbFilePath = [documentDir stringByAppendingPathComponent:@"etag.sqlite"];
        
        int result = sqlite3_open([dbFilePath UTF8String], &_db);
        if (result == SQLITE_OK) {
            [self _createEtagsTableInDB];
        } else {
            self = nil;
        }
    }
    return self;
}

- (void)_createEtagsTableInDB {
    sqlite3_stmt *statement;
    const char *query = "CREATE TABLE IF NOT EXISTS ETAGS (url TEXT PRIMARY KEY, etag TEXT NOT NULL)";
    int result = sqlite3_prepare_v2(_db, query, -1, &statement, nil);
    if (result == SQLITE_OK) {
        if (sqlite3_step(statement) != SQLITE_DONE) {
            NSLog(@"TABLE creation failed: %@",
                  [NSString stringWithUTF8String:sqlite3_errmsg(_db)]);
        };
        sqlite3_finalize(statement);
    } else {
        NSLog(@"Creating statement for TABLE creation failed: %@", [NSString stringWithUTF8String:sqlite3_errmsg(_db)]);
    }
    
}

-(NSString *)etagForURL:(NSURL *)url {
    NSString *result = nil;
    sqlite3_stmt *statement;
    int sqlResult = sqlite3_prepare_v2(_db, "SELECT etag FROM ETAGS WHERE url = ?", -1, &statement, nil);
    if (sqlResult == SQLITE_OK) {
        sqlite3_bind_text(statement, 1, [[url description] UTF8String], -1, SQLITE_STATIC);
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            result = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            NSLog(@"Found etag: %@", result);
            break;
        };
        sqlite3_finalize(statement);
    } else {
        NSLog(@"Creating statement for TABLE creation failed: %@", [NSString stringWithUTF8String:sqlite3_errmsg(_db)]);
    }
    
    return result;
}

-(void)persistEtag:(NSString *)etag forURL:(NSURL *)url {
    NSString *existingEtag = [self etagForURL:url];
    const char *query;
    if (existingEtag) {
        query = "UPDATE ETAGS SET etag = ? WHERE url = ?";
    } else {
        query = "INSERT INTO ETAGS (etag, url) VALUES (?, ?)";
    }
    
    sqlite3_stmt *statement;
    int sqlResult = sqlite3_prepare_v2(_db, query, -1, &statement, nil);
    if (sqlResult == SQLITE_OK) {
        sqlite3_bind_text(statement, 1, [etag UTF8String], -1, SQLITE_STATIC);
        sqlite3_bind_text(statement, 2, [[url description] UTF8String], -1, SQLITE_STATIC);
        
        if (sqlite3_step(statement) != SQLITE_DONE) {
            NSLog(@"insert or update failed: %@",
                  [NSString stringWithUTF8String:sqlite3_errmsg(_db)]);
        } else {
            NSLog(@"etag inserted or updated");
        };
        sqlite3_finalize(statement);

    } else {
        NSLog(@"Creating statement for UPDATE or INSERT failed: %@", [NSString stringWithUTF8String:sqlite3_errmsg(_db)]);
    }
}

-(void)dealloc {
    sqlite3_close(_db);
}

@end
