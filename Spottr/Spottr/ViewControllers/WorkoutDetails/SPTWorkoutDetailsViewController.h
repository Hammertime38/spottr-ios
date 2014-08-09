//
//  SPTWorkoutDetailsViewController.h
//  Spottr
//
//  Created by John Hammerlund on 8/8/14.
//  Copyright (c) 2014 Spottr. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SPTWorkout;

@interface SPTWorkoutDetailsViewController : UIViewController

+(SPTWorkoutDetailsViewController *)workoutViewControllerWithWorkout:(SPTWorkout *)workout;

@end
