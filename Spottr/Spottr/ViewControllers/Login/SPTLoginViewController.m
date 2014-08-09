//
//  SPTLoginViewController.m
//  Spottr
//
//  Created by John Hammerlund on 8/8/14.
//  Copyright (c) 2014 Spottr. All rights reserved.
//

#import "SPTLoginViewController.h"
#import <Parse/Parse.h>


@interface SPTLoginViewController ()

@end

@implementation SPTLoginViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)faebookLoginButtonTapped:(id)sender  {
    // The permissions requested from the user
    NSArray *permissionsArray = @[ @"user_about_me", @"user_relationships", @"user_birthday", @"user_location"];

    // Login PFUser using Facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {

        if (!user) {
            if (!error) {
                NSLog(@"User canceled FB login");
            } else {
                NSLog(@"Error occured when trying to login with FB: %@", error);
            }
        } else if (user.isNew) {
            NSLog(@"FB Sign up successful");
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            NSLog(@"FB Returning login successful");
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

- (IBAction)signUpWithEmailTapped:(id)sender {
//    PFUser *newUser = [PFUser user];

//
//    [newUser setUsername:@"Derpy"];
//    [newUser setPassword:@"test1234"];
//    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        if (succeeded) {
//            NSLog(@"Sign up successful!");
//        }
//        else {
//            NSLog(@":(");
//        }
//    }];
    NSLog(@"Not yet implemented");
}


@end
