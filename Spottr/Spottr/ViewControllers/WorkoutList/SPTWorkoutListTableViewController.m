//
//  SPTWorkoutListTableViewController.m
//  Spottr
//
//  Created by John Hammerlund on 8/8/14.
//  Copyright (c) 2014 Spottr. All rights reserved.
//

#import "SPTWorkoutListTableViewController.h"
#import "SPTCreateWorkoutController.h"
#import "SPTWorkoutCellTableViewCell.h"
#import "SPTWorkout.h"
#import "SPTWorkoutDetailsViewController.h"
#import <Parse/Parse.h>

@interface SPTWorkoutListTableViewController ()
@property (nonatomic) NSArray *workouts;
@end

@implementation SPTWorkoutListTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"Upcoming Spots"];

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SPTWorkoutCellTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"workoutCell"];
    UIRefreshControl *refreshControl = [UIRefreshControl new];
    [refreshControl addTarget:self action:@selector(reloadWorkouts) forControlEvents:UIControlEventValueChanged];
    [self setRefreshControl:refreshControl];

    //Literally copy and pasted the following 20 lines of code <3
    UIBarButtonItem *addBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewWorkoutTapped:)];
    [self.navigationItem setRightBarButtonItem:addBarButtonItem];

    [self reloadWorkouts];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)reloadWorkouts
{
    __weak typeof(self) weakSelf = self;
    [[PFQuery queryWithClassName:@"Workout"] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSMutableArray *workouts = [NSMutableArray arrayWithCapacity:objects.count];
        for (PFObject *object in objects) {
            [workouts addObject:[SPTWorkout workoutWithParseObject:object]];
        }
        NSArray *orderedWorkouts = [workouts sortedArrayUsingComparator:^NSComparisonResult(SPTWorkout *obj1, SPTWorkout *obj2) {
            return [obj1.workoutDate compare:obj2.workoutDate];
        }];

        [weakSelf setWorkouts:orderedWorkouts];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.refreshControl endRefreshing];
            [weakSelf.tableView reloadData];
        });
    }];
}

- (void)addNewWorkoutTapped:(id)sender
{
    UIViewController *createWorkoutViewController = [SPTCreateWorkoutController new];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.workouts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SPTWorkoutCellTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"workoutCell"];

    if (!cell) {
        cell = [[SPTWorkoutCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"workoutCell"];
    }

    [cell configureWithWorkout:self.workouts[indexPath.row]];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Magic :)
    return 102;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // So much magic :)
    return 102;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SPTWorkout *workout = self.workouts[indexPath.row];

    [self.navigationController pushViewController:[SPTWorkoutDetailsViewController workoutViewControllerWithWorkout:workout] animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

@end
