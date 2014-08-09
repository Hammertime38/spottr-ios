//
//  SPTWorkoutDetailsViewController.m
//  Spottr
//
//  Created by John Hammerlund on 8/8/14.
//  Copyright (c) 2014 Spottr. All rights reserved.
//

#import "SPTWorkoutDetailsViewController.h"
#import "SPTWorkout.h"
#import <Parse/Parse.h>

@interface SPTWorkoutDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *activityNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *capacityLabel;
@property (weak, nonatomic) IBOutlet UIImageView *hostImage;
@property (weak, nonatomic) IBOutlet UILabel *createdByLabel;

@property (nonatomic) SPTWorkout *workout;
@end

@implementation SPTWorkoutDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Join" style:UIBarButtonItemStylePlain target:self action:@selector(didTapJoinButton)]];
    [self.activityNameLabel setText:self.workout.name];
    [self.descriptionTextLabel setText:self.workout.workoutDescription];
    
    NSString *remaining = [@(self.workout.capacity - self.workout.numUsersJoined) stringValue];
    NSString *max = [@(self.workout.capacity) stringValue];
    [self.capacityLabel setText:[NSString stringWithFormat:@"%@/%@", remaining, max]];

    [self.createdByLabel setText:[NSString stringWithFormat:@"Created by %@ %@", self.workout.createdByFirstName, self.workout.createdByLastName]];

    [self.workout.createdByImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        [self.hostImage setImage:[UIImage imageWithData:data]];
    }];

    [self.hostImage.layer setCornerRadius:self.hostImage.frame.size.height/2];
    [self.hostImage.layer setMasksToBounds:YES];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd' at 'H:mm a"];
    [self.dateTimeLabel setText:[dateFormatter stringFromDate:self.workout.workoutDate]];
}

+(SPTWorkoutDetailsViewController *)workoutViewControllerWithWorkout:(SPTWorkout *)workout
{
    SPTWorkoutDetailsViewController *instance = [self new];
    instance->_workout = workout;
    return instance;
}

- (void)didTapJoinButton
{
    [self.workout joinWithCompletion:^(NSError *error, id result) {
        // screw error checking
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
