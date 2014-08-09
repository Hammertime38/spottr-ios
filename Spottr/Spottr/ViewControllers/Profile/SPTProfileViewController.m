//
//  SPTProfileViewController.m
//  Spottr
//
//  Created by John Hammerlund on 8/8/14.
//  Copyright (c) 2014 Spottr. All rights reserved.
//

#import "SPTProfileViewController.h"
#import <Parse/Parse.h>

@interface SPTProfileViewController ()
@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userImageIcon;

@end

@implementation SPTProfileViewController

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
    [self.userImageIcon.layer setCornerRadius:self.userImageIcon.frame.size.height/2];
    [self.userImageIcon.layer setMasksToBounds:YES];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:nil action:nil]];

    [[[PFUser currentUser] objectForKey:@"userPhoto"] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (data) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.userImageIcon setImage:[UIImage imageWithData:data]];
            });
        }
    }];
    [self.firstNameLabel setText:[[PFUser currentUser] objectForKey:@"firstName"]];
    [self.lastNameLabel setText:[[PFUser currentUser] objectForKey:@"lastName"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
