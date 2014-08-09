//
//  SPTMainTabBarController.m
//  Spottr
//
//  Created by John Hammerlund on 8/8/14.
//  Copyright (c) 2014 Spottr. All rights reserved.
//

#import "SPTMainTabBarController.h"
#import "SPTMapViewController.h"
#import "SPTWorkoutListTableViewController.h"
#import "SPTProfileViewController.h"
#import "SPTLoginViewController.h"
#import <Parse/Parse.h>

@interface SPTMainTabBarController ()

@end

@implementation SPTMainTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];

    SPTMapViewController *mapViewController = [SPTMapViewController new];
    SPTWorkoutListTableViewController *workoutListViewController = [SPTWorkoutListTableViewController new];
    SPTProfileViewController *profileViewController = [SPTProfileViewController new];

    [mapViewController.tabBarItem setImage:[UIImage imageNamed:@"SPTMapTabIcon"]];
    [workoutListViewController.tabBarItem setImage:[UIImage imageNamed:@"SPTListTabIcon"]];
    [profileViewController.tabBarItem setImage:[UIImage imageNamed:@"SPTProfileTabIcon"]];

    [self setViewControllers:@[mapViewController, workoutListViewController, profileViewController]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self checkLogin];
}

- (void)checkLogin
{
    if (![PFUser currentUser]) {
        [self presentViewController:[SPTLoginViewController new] animated:NO completion:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
