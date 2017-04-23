//
//  Notifications.h
//  Sample
//
//  Created by INDOBYTES on 19/04/17.
//  Copyright © 2017 indo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Notifications : UIViewController<NSURLConnectionDelegate,UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableview;

@end
