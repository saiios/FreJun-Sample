//
//  mainTableViewCell.m
//  FreJun
//
//  Created by GOTESO on 27/08/16.
//  Copyright © 2016 GOTESO. All rights reserved.
//

#import "mainTableViewCell.h"

@implementation mainTableViewCell
@synthesize title = _title;
@synthesize priorityLabel = _priorityLabel;

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
