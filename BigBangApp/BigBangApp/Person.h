//
//  Person.h
//  BigBangApp
//
//  Created by Michael Seghers on 15/03/14.
//  Copyright (c) 2014 PXL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

@property(nonatomic, strong) NSString *identifier;
@property(nonatomic, strong) NSString *firstName;
@property(nonatomic, strong) NSString *lastName;
@property(nonatomic, strong) NSString *realName;
@property(nonatomic, strong) NSString *bio;
@property(nonatomic, strong) NSString *profession;
@property(nonatomic, strong) NSString *websiteUrl;
@property(nonatomic, readonly, strong) NSString *fullName;

+(instancetype)personWithFirstName:(NSString *)firstName andLastName:(NSString *)lastName;
+(instancetype)personWithContentsOfFile:(NSString *) path;

- (instancetype)initWithFirstName:(NSString *)firstName andLastName:(NSString *)lastName;
- (instancetype)initWithContentsOfFile:(NSString *) path;

@end











