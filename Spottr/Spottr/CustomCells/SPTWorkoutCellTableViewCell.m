//
//  SPTWorkoutCellTableViewCell.m
//  Spottr
//
//  Created by John Hammerlund on 8/8/14.
//  Copyright (c) 2014 Spottr. All rights reserved.
//

#import "SPTWorkoutCellTableViewCell.h"
#import "SPTWorkout.h"

@interface SPTWorkoutCellTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *activityImageView;
@property (weak, nonatomic) IBOutlet UILabel *activityNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityDateLabel;

@end

@implementation SPTWorkoutCellTableViewCell

- (void)awakeFromNib {
    [self.activityImageView.layer setCornerRadius:self.activityImageView.frame.size.height/2];
    [self.activityImageView.layer setMasksToBounds:YES];
}

- (void)configureWithWorkout:(SPTWorkout *)workout
{
    [self.activityNameLabel setText:workout.name];
    [self.activityDescriptionLabel setText:workout.workoutDescription];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
