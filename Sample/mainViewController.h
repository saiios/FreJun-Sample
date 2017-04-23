//
//  mainViewController.h
//  Sample
//
//  Created by INDOBYTES on 18/04/17.
//  Copyright © 2017 indo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mainTableViewCell.h"
#import "Event_Details.h"
#import "Event_Invites.h"
#import "Notifications.h"

@interface mainViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UIView *notif_view;
@property (weak, nonatomic) IBOutlet UILabel *notificationsCountLabel;
@property (weak, nonatomic) IBOutlet UIView *calendarBackGroundView;
@property (weak, nonatomic) IBOutlet UIButton *dragButton;
- (IBAction)search_click:(id)sender;
- (IBAction)add_event:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *accounts_view;
@property (strong, nonatomic) IBOutlet UILabel *account_lbl;
@property (strong, nonatomic) IBOutlet UIImageView *arrow_img;
@property (weak, nonatomic) IBOutlet UIView *line_view;
@property (strong, nonatomic) IBOutlet UIView *notif_count;

@property (weak, nonatomic) IBOutlet UIView *tableViewBackground;
@property UITableView *tableView;

@end
