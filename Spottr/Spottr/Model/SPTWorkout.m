//
//  SPTWorkout.m
//  Spottr
//
//  Created by John Hammerlund on 8/9/14.
//  Copyright (c) 2014 Spottr. All rights reserved.
//

#import "SPTWorkout.h"
#import <Parse/Parse.h>

@interface SPTWorkout()
@property (nonatomic) NSArray *fetchedUsers;
@property (nonatomic) PFObject *backingParseObject;
@property (nonatomic) PFObject *createdByUser;
@property (nonatomic) NSString *objectId;
@property (nonatomic, assign, readwrite) NSUInteger numUsersJoined;
@end

@implementation SPTWorkout

- (PFObject *)parseObject
{
    if (self.backingParseObject)
        return self.backingParseObject;

    PFObject *parseObject = [[PFObject alloc] initWithClassName:@"Workout"];

    [self setBackingParseObject:parseObject];
    return self.backingParseObject;
}

+ (SPTWorkout *)workoutWithParseObject:(PFObject *)parseObject
{
    SPTWorkout *instance = [self new];
    instance->_objectId = parseObject.objectId;
    instance->_workoutDate = [parseObject objectForKey:@"workoutDate"];
    instance->_name = [parseObject objectForKey:@"name"];
    instance->_workoutDescription = [parseObject objectForKey:@"description"];
    instance->_capacity = [[parseObject objectForKey:@"capacity"] unsignedIntegerValue];
    instance->_latitude = [[parseObject objectForKey:@"latitude"] doubleValue];
    instance->_longitude = [[parseObject objectForKey:@"longitude"] doubleValue];
    instance->_backingParseObject = parseObject;
    instance->_createdByUser = [parseObject objectForKey:@"createdBy"];
    instance->_numUsersJoined = [[parseObject objectForKey:@"numUsersJoined"] unsignedIntegerValue];

    // What I'm about to do...is...just...yeah.
    PFFile *file = [parseObject objectForKey:@"createdByImage"];
    instance->_createdByImage = file;

    instance->_createdByFirstName = [parseObject objectForKey:@"createdByFirstName"];
    instance->_createdByLastName = [parseObject objectForKey:@"createdByLastName"];

    return instance;
}

- (void)saveWithCompletion:(SPTParseFetchBlock)completion
{
    PFObject *backingParseObject = [self backingParseObject];

    if (self.workoutDate)
        [backingParseObject setObject:self.workoutDate forKey:@"workoutDate"];
    if (self.name)
        [backingParseObject setObject:self.name forKey:@"name"];
    if (self.workoutDescription)
        [backingParseObject setObject:self.workoutDescription forKey:@"description"];
    [backingParseObject setObject:@(self.capacity) forKey:@"capacity"];
    [backingParseObject setObject:@(self.latitude) forKey:@"latitude"];
    [backingParseObject setObject:@(self.longitude) forKey:@"longitude"];
    if (![backingParseObject objectForKey:@"createdBy"]) {
        [backingParseObject setObject:[PFUser currentUser] forKey:@"createdBy"];
        [[backingParseObject relationForKey:@"joinedUsers"] addObject:[PFUser currentUser]];
        [backingParseObject setObject:@1 forKey:@"numJoinedUsers"];
    }
    [backingParseObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) completion(error, @(succeeded));
        });
    }];
}

- (void)joinWithCompletion:(SPTParseFetchBlock)completion
{
    if (!self.objectId) {
        if (completion) completion([NSError new], nil);
        return;
    }

    [[[self.backingParseObject relationForKey:@"joinedParseUsers"] query] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (![objects containsObject:[PFUser currentUser]]) {
            [[self.backingParseObject relationForKey:@"joinedParseUsers"] addObject:[PFUser currentUser]];
            [[self.backingParseObject relationForKey:@"joinedUsers"] addObject:[PFUser currentUser]];
            NSNumber *numJoinedUsers = [self.backingParseObject objectForKey:@"numJoinedUsers"];
            [self.backingParseObject setObject:@(numJoinedUsers.unsignedIntegerValue+1) forKey:@"numJoinedUsers"];
            NSArray *workoutsJoined = [[PFUser currentUser] objectForKey:@"workoutsJoined"];
            workoutsJoined = [workoutsJoined arrayByAddingObject:self.backingParseObject.objectId];
            [[PFUser currentUser] setObject:workoutsJoined forKey:@"workoutsJoined"];
            [[PFUser currentUser] save];
        }
        [self.backingParseObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) completion(nil, nil);
            });
        }];
    }];
}

- (void)fetchCreatedByWithCompletion:(SPTParseFetchBlock)completion
{
    if (!self.objectId) {
        if (completion) completion(nil, [PFUser currentUser]);
    }
    else {
        [[self.backingParseObject objectForKey:@"createdBy"] fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            [self setCreatedByFirstName:[object objectForKey:@"firstName"]];
            [self setCreatedByLastName:[object objectForKey:@"lastName"]];
            if (completion) completion(nil, object);
        }];
    }
}

- (void)fetchJoinedUsersWithCompletion:(SPTParseFetchBlock)completion;
{
    if (!self.objectId) {
        if (completion) completion(nil, [PFUser currentUser]);
    }
    else {
        [[[self.backingParseObject relationForKey:@"joinedUsers"] query] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) completion(error, objects);
            });
        }];
    }
}

@end
