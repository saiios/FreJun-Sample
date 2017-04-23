//
//  mainTableViewCell.h
//  FreJun
//
//  Created by GOTESO on 27/08/16.
//  Copyright © 2016 GOTESO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@interface mainTableViewCell : SWTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *priorityLabel;
@end
