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
    instance->_capacity = [[parseObject objectForKey:@"capacity"] unsignedIntegerValue];
    instance->_backingParseObject = parseObject;
    instance->_createdByUser = [parseObject objectForKey:@"createdBy"];

    // TODO -- inspect pointer from joined users
    return instance;
}

- (void)saveWithCompletion:(SPTParseFetchBlock)completion
{
    PFObject *backingParseObject = [self backingParseObject];

    if (self.workoutDate)
        [backingParseObject setObject:self.workoutDate forKey:@"workoutDate"];
    if (self.name)
        [backingParseObject setObject:self.name forKey:@"name"];
    [backingParseObject setObject:@(self.capacity) forKey:@"capacity"];
    if (![backingParseObject objectForKey:@"createdBy"]) {
        [backingParseObject setObject:[PFUser currentUser] forKey:@"createdBy"];
        [[backingParseObject relationForKey:@"joinedUsers"] addObject:[PFUser currentUser]];
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
        if (![objects containsObject:[PFUser currentUser]])
            [[self.backingParseObject relationForKey:@"joinedParseUsers"] addObject:[PFUser currentUser]];
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
        if (completion) completion(nil, self.createdByUser);
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
