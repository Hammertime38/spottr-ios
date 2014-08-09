//
//  SPTWorkoutAnnotation.h
//  Spottr
//
//  Created by John Hammerlund on 8/9/14.
//  Copyright (c) 2014 Spottr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class SPTWorkout;
@interface SPTWorkoutAnnotation : NSObject <MKAnnotation>
+ (SPTWorkoutAnnotation *)annotationWithWorkout:(SPTWorkout *)workout;
@property (nonatomic, readonly) SPTWorkout *workout;
@end
