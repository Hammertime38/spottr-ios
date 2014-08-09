//
//  SPTLabelAndTextFieldTableViewCell.h
//  Spottr
//
//  Created by John Hammerlund on 8/9/14.
//  Copyright (c) 2014 Spottr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPTLabelAndTextFieldTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *customTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end
