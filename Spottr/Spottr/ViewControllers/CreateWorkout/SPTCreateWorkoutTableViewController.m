//
//  SPTCreateWorkoutTableViewController.m
//  Spottr
//
//  Created by John Hammerlund on 8/9/14.
//  Copyright (c) 2014 Spottr. All rights reserved.
//

#import "SPTCreateWorkoutTableViewController.h"
#import "SPTTextFieldTableViewCell.h"
#import "SPTLabelAndTextFieldTableViewCell.h"
#import "SPTLabelAndTextViewTableViewCell.h"
#import "SPTDatePickerTableViewCell.h"
#import <CoreLocation/CoreLocation.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "SPTWorkout.h"

static NSString * const kTextFieldCell = @"kTextFieldCell";
static NSString * const kLabelAndTextFieldCell = @"kLabelAndTextFieldCell";
static NSString * const kLabelAndTextViewCell = @"kLabelAndTextViewCell";
static NSString * const kDatePickerCell = @"kDatePickerCell";

@interface SPTCreateWorkoutTableViewController ()

@property (nonatomic, weak) UITextField *activityNameTextField;
@property (nonatomic, weak) UITextView *activityDescriptionTextField;
@property (nonatomic, weak) UITextField *groupSizeTextField;
@property (nonatomic, weak) UITextField *addressTextField;
@property (nonatomic, weak) UIDatePicker *datePicker;

@end

@implementation SPTCreateWorkoutTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"Schedule Workout"];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SPTTextFieldTableViewCell class]) bundle:nil] forCellReuseIdentifier:kTextFieldCell];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SPTLabelAndTextFieldTableViewCell class]) bundle:nil] forCellReuseIdentifier:kLabelAndTextFieldCell];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SPTLabelAndTextViewTableViewCell class]) bundle:nil] forCellReuseIdentifier:kLabelAndTextViewCell];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SPTDatePickerTableViewCell class]) bundle:nil] forCellReuseIdentifier:kDatePickerCell];

    UIBarButtonItem *spotBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"SPOT" style:UIBarButtonItemStylePlain target:self action:@selector(spotTapped)];
    [self.navigationItem setRightBarButtonItem:spotBarButtonItem];
}

- (void)spotTapped
{
    [SVProgressHUD showWithStatus:@"Scheduling Workout..."];
    [[CLGeocoder new] geocodeAddressString:self.addressTextField.text completionHandler:^(NSArray *placemarks, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                [SVProgressHUD showErrorWithStatus:@"Couldn't find address :("];
                return;
            }

            CLPlacemark *placemark = [placemarks firstObject];
            double latitude = placemark.location.coordinate.latitude;
            double longitude = placemark.location.coordinate.longitude;

            SPTWorkout *newWorkout = [SPTWorkout new];
            [newWorkout setLatitude:latitude];
            [newWorkout setLongitude:longitude];
            [newWorkout setName:self.activityNameTextField.text];
            [newWorkout setWorkoutDescription:self.activityDescriptionTextField.text];
            [newWorkout setWorkoutDate:self.datePicker.date];
            [newWorkout setCapacity:self.groupSizeTextField.text.integerValue];

            [newWorkout saveWithCompletion:^(NSError *error, id result) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (!error) {
                        [SVProgressHUD showSuccessWithStatus:@"Workout Scheduled"];
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }
                    else {
                        [SVProgressHUD showErrorWithStatus:@"Failed to schedule workout"];
                    }
                });
            }];
        });
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 2;
        case 1:
            return 1;
        case 2:
            return 2;

        default:
            return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell = [self.tableView dequeueReusableCellWithIdentifier:kTextFieldCell];
            if (!cell) cell = [[SPTTextFieldTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kTextFieldCell];
            [[(id)cell textField] setPlaceholder:@"Activity"];
            [self setActivityNameTextField:[(id)cell textField]];
        }
        else {
            cell = [self.tableView dequeueReusableCellWithIdentifier:kLabelAndTextViewCell];
            if (!cell) cell = [[SPTLabelAndTextViewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kLabelAndTextViewCell];
            [self setActivityDescriptionTextField:[(id)cell customTextView]];
        }
    }
    else if (indexPath.section == 1) {
        cell = [self.tableView dequeueReusableCellWithIdentifier:kDatePickerCell];
        if (!cell) cell = [[SPTDatePickerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kDatePickerCell];
        [self setDatePicker:[(id)cell datePicker]];
    }
    else {
        if (indexPath.row == 0) {
            cell = [self.tableView dequeueReusableCellWithIdentifier:kLabelAndTextFieldCell];
            if (!cell) cell = [[SPTLabelAndTextFieldTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kLabelAndTextFieldCell];
            [self setGroupSizeTextField:[(id)cell textField]];
        }
        else {
            cell = [self.tableView dequeueReusableCellWithIdentifier:kTextFieldCell];
            if (!cell) cell = [[SPTTextFieldTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kTextFieldCell];
            [[(id)cell textField] setPlaceholder:@"Address"];
            [self setAddressTextField:[(id)cell textField]];
        }
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0)
            return 44;
        return 120;
    }
    else if (indexPath.section == 1) {
        return 200;
    }
    return 44;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return @"Date and Time";
    }
    return nil;
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
