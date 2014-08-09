//
//  SPTWorkout.h
//  Spottr
//
//  Created by John Hammerlund on 8/9/14.
//  Copyright (c) 2014 Spottr. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 THIS INTERFACE IS PRONE TO CHANGE
 */

@class PFObject;
@class PFFile;
@interface SPTWorkout : NSObject

- (PFObject *)parseObject;
+ (SPTWorkout *)workoutWithParseObject:(PFObject *)parseObject;
- (void)saveWithCompletion:(SPTParseFetchBlock)completion;
- (void)joinWithCompletion:(SPTParseFetchBlock)completion;

@property (nonatomic, copy) NSDate *workoutDate;
@property (nonatomic, copy) NSString *workoutDescription;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSUInteger capacity;
@property (nonatomic, assign, readonly) NSUInteger numUsersJoined;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;
@property (nonatomic, copy) NSString *createdByFirstName;
@property (nonatomic, copy) NSString *createdByLastName;
@property (nonatomic) PFFile *createdByImage;

- (void)fetchCreatedByWithCompletion:(SPTParseFetchBlock)completion;
- (void)fetchJoinedUsersWithCompletion:(SPTParseFetchBlock)completion;

@end
