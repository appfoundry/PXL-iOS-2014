//
//  RemotePersonDataLoader.m
//  BigBangApp
//
//  Created by Michael Seghers on 23/04/14.
//  Copyright (c) 2014 PXL. All rights reserved.
//

#import "RemotePersonDataLoader.h"
#import "PersonListConnectionDelegate.h"
#import "EtagRegistry.h"
#import "SQLiteEtagRegistry.h"
#import "Person.h"
#import "NSArray+Functional.h"

@interface RemotePersonDataLoader () {
    id<EtagRegistry> _etagRegistry;
    NSOperationQueue *_queue;
}

@end

@implementation RemotePersonDataLoader

+ (instancetype)sharedRemotePersonDataLoader {
    static RemotePersonDataLoader *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[RemotePersonDataLoader alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _etagRegistry = [SQLiteEtagRegistry sharedSQLiteEtagRegistry];
        _queue = [[NSOperationQueue alloc] init];
    }
    return self;
}



/*
With delegate:
 - (void)fetchPersonData:(CompletionBlock)completion {
    NSURL *url = [NSURL URLWithString:@"http://idamf-restdemo.herokuapp.com/app/persons.json"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString *etag = [_etagRegistry etagForURL:url];
    if (etag) {
        [request setValue:etag forHTTPHeaderField:@"If-None-Match"];
    }
    PersonListConnectionDelegate *delegate = [[PersonListConnectionDelegate alloc] initWithCompletion:^(id result, NSError *error) {
        completion(result, error);
    }];
    
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:delegate];
    [connection start];
}*/

- (void)fetchPersonData:(CompletionBlock)completion {
    NSURL *url = [NSURL URLWithString:@"http://idamf-restdemo.herokuapp.com/app/persons.json"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString *etag = [_etagRegistry etagForURL:url];
    if (etag) {
        [request setValue:etag forHTTPHeaderField:@"If-None-Match"];
    }
    [NSURLConnection sendAsynchronousRequest:request queue:_queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!connectionError) {
            if ([response isKindOfClass:NSHTTPURLResponse.class]) {
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                if (httpResponse.statusCode == 200) {
                    NSString *etag = [httpResponse allHeaderFields][@"Etag"];
                    [_etagRegistry persistEtag:etag forURL:response.URL];
                    
                    [self _completeWithData:data withCompletion:completion];
                } else if (httpResponse.statusCode == 304) {
                    NSLog(@"We have been etagged");
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(nil, nil);
                    });
                } else {
                    [self _sendErrorToCompletion:completion];
                }
            } else {
                [self _sendErrorToCompletion:completion];
            }
        }
    }];
}

-(void) _completeWithData:(NSData *) data withCompletion:(CompletionBlock) completion {
    if (data && completion) {
        NSError *error;
        id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if ([jsonObject isKindOfClass:NSDictionary.class]) {
            NSDictionary *personListDictionary = jsonObject;
            NSArray *list = personListDictionary[@"personList"];
            if (list) {
                NSArray *persons = [list fun_arrayByUsingTransformer:^id(NSDictionary *personDictionary) {
                    return [Person personWithJSONDictionary:personDictionary];
                }];
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(persons, error);
                });
            } else {
                NSError *error = [NSError errorWithDomain:@"APPRemotingJSON" code:-1001 userInfo:@{@"reason": @"Expected a dictionary with person list in it, but not found"}];
                dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil, error);
                });
            }
        } else {
            NSError *error = [NSError errorWithDomain:@"APPRemotingJSON" code:-1000 userInfo:@{@"reason": @"Expected a dictionary as root element, but was something else"}];
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil, error);
            });
        }
    }
}

- (void) _sendErrorToCompletion:(CompletionBlock) completion {
    dispatch_async(dispatch_get_main_queue(), ^{
        completion(nil, [NSError errorWithDomain:@"x" code:-1000 userInfo:nil]);
    });
}

//Sync example
/*NSError *error;
 NSURLResponse *response;
 NSData *body = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
 
 NSLog(@"Error was: %@", error);
 NSLog(@"Response was: %@", response);
 NSLog(@"Body was: %@", [NSString stringWithUTF8String:body.bytes]);
 if (!error && ((NSHTTPURLResponse *) response).statusCode == 200) {
 id jsonObject = [NSJSONSerialization JSONObjectWithData:body options:0 error:&error];
 NSLog(@"JSON was: %@", jsonObject);
 NSLog(@"Error was: %@", error);
 }*/


@end
