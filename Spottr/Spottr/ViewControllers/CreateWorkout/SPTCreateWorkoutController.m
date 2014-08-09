//
//  SPTCreateWorkoutController.m
//  Spottr
//
//  Created by Vignesh K on 8/9/14.
//  Copyright (c) 2014 Spottr. All rights reserved.
//

#import "SPTCreateWorkoutController.h"
#import "SPTWorkout.h"

@interface SPTCreateWorkoutController ()
@property (weak, nonatomic) IBOutlet UITextField *activityTextField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextArea;
@property (weak, nonatomic) IBOutlet UIDatePicker *dateTimePicker;
@property (weak, nonatomic) IBOutlet UITextField *groupSizeTextField;
@end

@implementation SPTCreateWorkoutController

- (IBAction)spotButtonTapped:(id)sender
{
    SPTWorkout *workout = [SPTWorkout new];
    
    [workout setWorkoutDate:self.dateTimePicker.date];
    [workout setWorkoutDescription:self.descriptionTextArea.text];
    [workout setName:self.activityTextField.text];
    [workout setCapacity:self.groupSizeTextField.text.integerValue];
    
    [workout saveWithCompletion:^(NSError *error, id result) {
        // what is error checking even
        [self dismissViewControllerAnimated:YES completion:nil];
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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
