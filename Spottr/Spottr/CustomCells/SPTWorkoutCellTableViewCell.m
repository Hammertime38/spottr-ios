//
//  SPTWorkoutCellTableViewCell.m
//  Spottr
//
//  Created by John Hammerlund on 8/8/14.
//  Copyright (c) 2014 Spottr. All rights reserved.
//

#import "SPTWorkoutCellTableViewCell.h"
#import "SPTWorkout.h"
#import <Parse/Parse.h>

@interface SPTWorkoutCellTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *activityImageView;
@property (weak, nonatomic) IBOutlet UILabel *activityNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityDateLabel;
@property (nonatomic, weak) SPTWorkout *workout;
@property (nonatomic) UIView *greenDotView;

@end

@implementation SPTWorkoutCellTableViewCell

- (void)awakeFromNib
{
    [self.activityImageView.layer setCornerRadius:self.activityImageView.frame.size.height/2];
    [self.activityImageView.layer setMasksToBounds:YES];
    UIView *greenDotView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [greenDotView setBackgroundColor:[UIColor colorWithRed:0 green:0.8 blue:0 alpha:1]];
    [greenDotView.layer setCornerRadius:5];
    [greenDotView.layer setMasksToBounds:YES];
    [self setGreenDotView:greenDotView];
}

- (void)configureWithWorkout:(SPTWorkout *)workout
{
    [self setWorkout:workout];
    [self.activityNameLabel setText:workout.name];
    [self.activityDescriptionLabel setText:workout.workoutDescription];

    __weak typeof(self) weakSelf = self;
    __weak typeof(workout) weakWorkout = workout;
    [workout.createdByImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (weakSelf.workout != weakWorkout)
            return;
        UIImage *image = [UIImage imageWithData:data];
        [weakSelf.activityImageView setImage:image];
    }];

    NSDateFormatter *horriblyInitializedDateFormatter = [[NSDateFormatter alloc] init];
    [horriblyInitializedDateFormatter setDateFormat:@"M/dd/yyyy' at 'H:mm a"];
    [self.activityDateLabel setText:[horriblyInitializedDateFormatter stringFromDate:workout.workoutDate]];

    if ([[[PFUser currentUser] objectForKey:@"workoutsJoined"] containsObject:workout.parseObject.objectId]) {
        [self addGreenDotNStuff];
    }
    else {
        [self removeGreenDot];
    }
}

- (void)addGreenDotNStuff
{
    // Do you believe in magic?
    [self.greenDotView setFrame:CGRectMake(self.frame.size.width - 25, 15, self.greenDotView.frame.size.width, self.greenDotView.frame.size.height)];
    [self addSubview:self.greenDotView];
}

- (void)removeGreenDot
{
    [self.greenDotView removeFromSuperview];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
