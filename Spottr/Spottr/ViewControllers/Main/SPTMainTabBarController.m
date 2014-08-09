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

static UIView *annoyingBackgroundView_;
- (void)viewDidLoad
{
    [super viewDidLoad];

    SPTMapViewController *mapViewController = [SPTMapViewController new];
    UINavigationController *mapNavigationController = [[UINavigationController alloc] initWithRootViewController:mapViewController];
    SPTWorkoutListTableViewController *workoutListViewController = [SPTWorkoutListTableViewController new];
    UINavigationController *workoutListNavigationController = [[UINavigationController alloc] initWithRootViewController:workoutListViewController];
    SPTProfileViewController *profileViewController = [SPTProfileViewController new];

    [mapNavigationController.navigationBar setTranslucent:YES];
    [workoutListNavigationController.navigationBar setTranslucent:YES];

    [mapNavigationController.tabBarItem setImage:[UIImage imageNamed:@"SPTMapTabIcon"]];
    [workoutListNavigationController.tabBarItem setImage:[UIImage imageNamed:@"SPTListTabIcon"]];
    [profileViewController.tabBarItem setImage:[UIImage imageNamed:@"SPTProfileTabIcon"]];

    [self setViewControllers:@[mapNavigationController, workoutListNavigationController, profileViewController]];

    annoyingBackgroundView_ = [[UIView alloc] initWithFrame:self.view.bounds];
    [annoyingBackgroundView_ setBackgroundColor:SPT_COLOR_KEY];
    [self.view addSubview:annoyingBackgroundView_];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self checkLogin];
}

- (void)checkLogin
{
    if (![PFUser currentUser]) {
        [self presentViewController:[SPTLoginViewController new] animated:NO completion:^{
            [annoyingBackgroundView_ removeFromSuperview];
        }];
    }
    else {
        [annoyingBackgroundView_ removeFromSuperview];
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
