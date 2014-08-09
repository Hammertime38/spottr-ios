//
//  SPTMapViewController.m
//  Spottr
//
//  Created by John Hammerlund on 8/8/14.
//  Copyright (c) 2014 Spottr. All rights reserved.
//

#import "SPTMapViewController.h"
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>
#import "SPTCreateWorkoutTableViewController.h"
#import "SPTWorkout.h"

@interface SPTMapViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation SPTMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIBarButtonItem *addBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewWorkoutTapped:)];
    [self.navigationItem setRightBarButtonItem:addBarButtonItem];

    PFQuery *query = [PFQuery queryWithClassName:@"Workout"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for (PFObject *object in objects) {
            SPTWorkout *workout = [SPTWorkout workoutWithParseObject:object];
            NSLog(@"created workout");
        }
        NSLog(@"Derp");

    }];
}

- (void)addNewWorkoutTapped:(id)sender
{
    UIViewController *createWorkoutViewController = [SPTCreateWorkoutTableViewController new];
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", nil) style:UIBarButtonItemStylePlain target:self action:@selector(closePresentedViewController)];
    [createWorkoutViewController.navigationItem setLeftBarButtonItem:backBarButtonItem];
    // Embed in navigation controller for simple close behavior
    UINavigationController *destinationViewController = [[UINavigationController alloc] initWithRootViewController:createWorkoutViewController];
    [self presentViewController:destinationViewController animated:YES completion:nil];
}

- (void)closePresentedViewController
{
    // Hacky McHackenstein
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
