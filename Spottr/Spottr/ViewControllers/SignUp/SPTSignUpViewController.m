//
//  SPTSignUpViewController.m
//  Spottr
//
//  Created by John Hammerlund on 8/8/14.
//  Copyright (c) 2014 Spottr. All rights reserved.
//

#import "SPTSignUpViewController.h"
#import <Parse/Parse.h>

@interface SPTSignUpViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UITextField *userFirstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *userLastNameTextField;
@end

@implementation SPTSignUpViewController
- (IBAction)startSpottingButtonTapped:(id)sender
{
    // TODO: Check validation
    PFUser *newUser = [PFUser new];
    [newUser setUsername:self.usernameTextField.text];
    [newUser setPassword:self.passwordTextField.text];
    [newUser setObject:self.userFirstNameTextField.text forKey:@"firstName"];
    [newUser setObject:self.userLastNameTextField.text forKey:@"lastName"];
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(succeeded) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else {
            NSLog(@"Failed to sign up new user: %@", error);
        }
    }];
}

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
    [self.userImageView.layer setCornerRadius:self.userImageView.frame.size.height/2];
    [self.userImageView.layer setMasksToBounds:YES];
    // TODO: Add image picker
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
