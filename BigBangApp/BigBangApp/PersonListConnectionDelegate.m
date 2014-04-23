//
//  PersonListConnectionDelegate.m
//  BigBangApp
//
//  Created by Michael Seghers on 23/04/14.
//  Copyright (c) 2014 PXL. All rights reserved.
//

#import "PersonListConnectionDelegate.h"

#import "NSArray+Functional.h"
#import "Person.h"

@interface PersonListConnectionDelegate() {
    NSMutableData *_responseBody;
    PersonListCompletionBlock _completion;
}

@end

@implementation PersonListConnectionDelegate

- (instancetype)initWithCompletion:(PersonListCompletionBlock)completion
{
    self = [super init];
    if (self) {
        _completion = completion;
    }
    return self;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    if ([response isKindOfClass:NSHTTPURLResponse.class] && ((NSHTTPURLResponse *) response).statusCode == 200) {
        _responseBody = [[NSMutableData alloc] init];
    } else {
        _completion(nil, [NSError errorWithDomain:@"x" code:-1000 userInfo:nil]);
        [connection cancel];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_responseBody appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if (_responseBody && _completion) {
        NSError *error;
        id jsonObject = [NSJSONSerialization JSONObjectWithData:_responseBody options:0 error:&error];
        if ([jsonObject isKindOfClass:NSDictionary.class]) {
            NSDictionary *personListDictionary = jsonObject;
            NSArray *list = personListDictionary[@"personList"];
            if (list) {
                NSArray *persons = [list fun_arrayByUsingTransformer:^id(NSDictionary *personDictionary) {
                    return [Person personWithJSONDictionary:personDictionary];
                }];
                _completion(persons, error);
            } else {
                NSError *error = [NSError errorWithDomain:@"APPRemotingJSON" code:-1001 userInfo:@{@"reason": @"Expected a dictionary with person list in it, but not found"}];
                _completion(nil, error);
            }
        } else {
            NSError *error = [NSError errorWithDomain:@"APPRemotingJSON" code:-1000 userInfo:@{@"reason": @"Expected a dictionary as root element, but was something else"}];
            _completion(nil, error);
        }
    }
    _responseBody = nil;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    if (_completion) {
        _completion(nil, error);
    }
}

@end
