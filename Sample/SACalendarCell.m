//
//  SACalendarCell.m
//  SACalendarExample
//
//  Created by Nop Shusang on 7/12/14.
//  Copyright (c) 2014 SyncoApp. All rights reserved.
//
//  Distributed under MIT License

#import "SACalendarCell.h"
#import "SACalendarConstants.h"

@implementation SACalendarCell

/**
 *  Draw the basic components of the cell, including the top grey line, the red current date circle,
 *  the black selected circle and the date label. Customized the cell apperance by editing this function.
 *
 *  @param frame - size of the cell
 *
 *  @return initialized cell
 */
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = cellBackgroundColor;
        
        self.topLineView = [[UIView alloc]initWithFrame:CGRectMake(-1, 0, frame.size.width + 2, 1)];
        self.topLineView.backgroundColor = cellTopLineColor;
        
        self.eventSign = [[UIView alloc]initWithFrame:CGRectMake(frame.size.width/2 - 10, frame.size.width/2 - 5, 3, 3)];
        self.eventSign.backgroundColor = [UIColor clearColor];
        _eventSign.layer.cornerRadius = _eventSign.frame.size.width/2;
        _eventSign.alpha = 1;
        
        self.eventSign2 = [[UIView alloc]initWithFrame:CGRectMake(frame.size.width/2 - 5, frame.size.width/2 - 5, 3, 3)];
        self.eventSign2.backgroundColor = [UIColor clearColor];
        _eventSign2.layer.cornerRadius = _eventSign2.frame.size.width/2;
        _eventSign2.alpha = 1;
        
        self.eventSign3 = [[UIView alloc]initWithFrame:CGRectMake(frame.size.width/2, frame.size.width/2 - 5, 3, 3)];
        self.eventSign3.backgroundColor = [UIColor clearColor];
        _eventSign3.layer.cornerRadius = _eventSign3.frame.size.width/2;
        _eventSign3.alpha = 1;
        
        self.eventSign4 = [[UIView alloc]initWithFrame:CGRectMake(frame.size.width/2  + 5, frame.size.width/2 - 5, 3, 3)];
        self.eventSign4.backgroundColor = [UIColor clearColor];
        _eventSign4.layer.cornerRadius = _eventSign4.frame.size.width/2;
        _eventSign4.alpha = 1;
        
        self.eventSign5 = [[UIView alloc]initWithFrame:CGRectMake(frame.size.width/2 + 10, frame.size.width/2 - 5, 3, 3)];
        self.eventSign5.backgroundColor = [UIColor clearColor];
        _eventSign5.layer.cornerRadius = _eventSign5.frame.size.width/2;
        _eventSign5.alpha = 1;
        
        self.dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height * labelToCellRatio)];
        self.dateLabel.textAlignment = NSTextAlignmentCenter;
        
        CGRect labelFrame = self.dateLabel.frame;
        CGSize labelSize = labelFrame.size;
        
        CGPoint origin;
        int length;
        if (labelSize.width > labelSize.height) {
            origin.x = (labelSize.width - labelSize.height * circleToCellRatio) / 2;
            origin.y = (labelSize.height * (1 - circleToCellRatio)) / 2;
            length = labelSize.height * circleToCellRatio;
        }
        else{
            origin.x = (labelSize.width * (1 - circleToCellRatio)) / 2;
            origin.y = (labelSize.height - labelSize.width * circleToCellRatio) / 2;
            length = labelSize.width * circleToCellRatio;
        }
        
        self.circleView = [[UIView alloc] initWithFrame:CGRectMake(origin.x, origin.y, length, length)];
        
        self.circleView.layer.cornerRadius = length / 2;
        self.circleView.backgroundColor = currentDateCircleColor;
        
        self.selectedView = [[UIView alloc] initWithFrame:CGRectMake(origin.x, origin.y, length, length)];
        
        self.selectedView.layer.cornerRadius = length / 2;
        self.selectedView.backgroundColor = selectedDateCircleColor;
        
        [self.viewForBaselineLayout addSubview:self.topLineView];
        [self.viewForBaselineLayout addSubview:self.circleView];
        [self.viewForBaselineLayout addSubview:self.selectedView];
        [self.viewForBaselineLayout addSubview:self.dateLabel];
        [self.viewForBaselineLayout addSubview:self.eventSign];
        [self.viewForBaselineLayout addSubview:self.eventSign2];
        [self.viewForBaselineLayout addSubview:self.eventSign3];
        [self.viewForBaselineLayout addSubview:self.eventSign4];
        [self.viewForBaselineLayout addSubview:self.eventSign5];
        
    }
    return self;
}



@end
