//
//  SPTWorkoutAnnotation.m
//  Spottr
//
//  Created by John Hammerlund on 8/9/14.
//  Copyright (c) 2014 Spottr. All rights reserved.
//

#import "SPTWorkoutAnnotation.h"
#import "SPTWorkout.h"

@interface SPTWorkoutAnnotation()

@property (nonatomic) SPTWorkout *workout;

@end

@implementation SPTWorkoutAnnotation

+ (SPTWorkoutAnnotation *)annotationWithWorkout:(SPTWorkout *)workout
{
    SPTWorkoutAnnotation *instance = [self new];
    instance->_workout = workout;
    return instance;
}

- (CLLocationCoordinate2D)coordinate
{
    return CLLocationCoordinate2DMake(self.workout.latitude, self.workout.longitude);
}

- (NSString *)title
{
    return self.workout.name;
}

- (NSString *)subtitle
{
    return self.workout.workoutDescription;
}

@end
