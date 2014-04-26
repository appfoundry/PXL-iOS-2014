//
//  EtagRegistry.h
//  BigBangApp
//
//  Created by Michael Seghers on 26/04/14.
//  Copyright (c) 2014 PXL. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EtagRegistry <NSObject>

-(NSString *)etagForURL:(NSURL *) url;
-(void)persistEtag:(NSString *) etag forURL:(NSURL *) url;

@end
