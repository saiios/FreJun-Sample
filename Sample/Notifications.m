//
//  Notifications.m
//  Sample
//
//  Created by INDOBYTES on 19/04/17.
//  Copyright © 2017 indo. All rights reserved.
//

#import "Notifications.h"

@interface Notifications ()
{
    BOOL loading;
    UIView *loadingView;
    NSMutableData *mutableData;
    NSArray *buttons;
    NSArray *timestamps;
}
@end

@implementation Notifications

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    dataclass *obj = [dataclass getInstance];
    obj.NotificationCount = @"0";
    [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:@"notificationCount"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.navigationItem.title = @"Notifications";
    buttons = [[NSArray alloc]init];
    buttons = @[@"demo1@gmail.com accepted invite",@"demo2@gmail.com declined invite",@"demo3@gmail.com accepted invite"];
    timestamps = [[NSArray alloc] initWithObjects:@"2 hours ago",@"2 days ago",@"1 month ago", nil];
    self.view.backgroundColor = [UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:243.0/255.0 alpha:1];
   // self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self initNotifications];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initNotifications{
    dataclass *obj = [dataclass getInstance];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:directoryNotifications]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request setHTTPMethod:@"POST"];
    NSString *postString = [NSString stringWithFormat:@"email=%@&userID=%@",obj.emailTitle,[[NSUserDefaults standardUserDefaults] stringForKey:@"userID"]];
    NSData *parameterData = [postString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    [request setHTTPBody:parameterData];
    [request setHTTPMethod:@"POST"];
    [request addValue: @"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if( connection )
    {
        mutableData = [NSMutableData new];
        [loadingView setHidden:YES];
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(cell.contentView.frame.size.width - 70, 0, 60, cell.contentView.frame.size.height)];
    label.textAlignment = NSTextAlignmentRight;
    label.text = timestamps[indexPath.row];
    label.font = [UIFont systemFontOfSize:10];
    label.textColor = [UIColor lightGrayColor];
    [cell.contentView addSubview:label];
    
    UILabel *infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, cell.contentView.frame.size.width - 95, cell.contentView.frame.size.height)];
    infoLabel.text = buttons[indexPath.row];
    infoLabel.font = [UIFont systemFontOfSize:14];
    infoLabel.adjustsFontSizeToFitWidth = YES;
    [cell.contentView addSubview:infoLabel];
    cell.selectionStyle= UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark NSURLConnection delegates
-(void) connection:(NSURLConnection *) connection didReceiveResponse:(NSURLResponse *)response
{
    [mutableData setLength:0];
    NSLog(@"response %@",response);
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [mutableData appendData:data];
    NSLog(@"dara got");
}

-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    //serverResponse.text = NO_CONNECTION;
    NSLog(@"45455 %@",error);
    return;
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *responseStringWithEncoded = [[NSString alloc] initWithData: mutableData encoding:NSUTF8StringEncoding];
    NSError* error;
    NSDictionary *json = [NSJSONSerialization
                          JSONObjectWithData:mutableData
                          options:kNilOptions
                          error:&error];
    
    NSLog(@"Response from Server : %@", responseStringWithEncoded);
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
