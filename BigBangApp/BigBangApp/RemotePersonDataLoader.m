//
//  RemotePersonDataLoader.m
//  BigBangApp
//
//  Created by Michael Seghers on 23/04/14.
//  Copyright (c) 2014 PXL. All rights reserved.
//

#import "RemotePersonDataLoader.h"
#import "PersonListConnectionDelegate.h"

@implementation RemotePersonDataLoader

- (void)fetchPersonData:(CompletionBlock)completion {
    NSURL *url = [NSURL URLWithString:@"http://idamf-restdemo.herokuapp.com/app/persons.json"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:@"0acada557a06f4c298518aefadb83b8e9" forHTTPHeaderField:@"If-None-Match"];
    PersonListConnectionDelegate *delegate = [[PersonListConnectionDelegate alloc] initWithCompletion:^(id result, NSError *error) {
        completion(result, error);
    }];
    
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:delegate];
    [connection start];
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
