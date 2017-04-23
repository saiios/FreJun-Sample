//
//  mainViewController.m
//  Sample
//
//  Created by INDOBYTES on 18/04/17.
//  Copyright © 2017 indo. All rights reserved.

#import "mainViewController.h"
#import "SACalendar.h"
#import "dataclass.h"
#import "DateUtil.h"
#import "SearchResultsViewController.h"

@interface mainViewController ()
{
    SACalendar *frejunCalendar;
    float navBarHeight;
    int deleteStatus;
    NSArray *json;
    BOOL loading;
    UIView *loadingView;
    NSMutableArray *finalData;
    BOOL scrolledToCurrentDate;
}

@property (strong, nonatomic) NSMutableArray *data;
@property (strong, nonatomic) UISearchController *controller;
@property (strong, nonatomic) NSArray *results;
@end

@implementation mainViewController
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationItem setHidesBackButton:YES];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    scrolledToCurrentDate = NO;
    [[NSUserDefaults standardUserDefaults] setObject:@"All Accounts" forKey:@"navTitle"];

    // Do any additional setup after loading the view from its nib.
    // navBarHeight = self.navigationController.navigationBar.frame.size.height+[UIApplication sharedApplication].statusBarFrame.size.height;
    navBarHeight=66;

    self.tableView = [[UITableView alloc]init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);

    frejunCalendar = [[SACalendar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 0, (self.view.frame.size.height)/2)
                                      scrollDirection:ScrollDirectionVertical
                                        pagingEnabled:YES];
    frejunCalendar.delegate = self;
    
    //search
    SearchResultsViewController *searchResults = (SearchResultsViewController *)self.controller.searchResultsController;
    [self addObserver:searchResults forKeyPath:@"results" options:NSKeyValueObservingOptionNew context:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searched) name:@"searched" object:nil];
    [self refreshData];
     [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(refreshData) userInfo:nil repeats:YES];
    
    //notification tap
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(notif_click:)];
    [_notif_view addGestureRecognizer:singleFingerTap];
    _notif_count.layer.cornerRadius = 5;
    _notif_count.layer.masksToBounds = YES;
}

//The event handling method
- (void)notif_click:(UITapGestureRecognizer *)recognizer
{
    CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    
    //Do stuff here...
}
-(void)searched//search item click
{
    dataclass *obj = [dataclass getInstance];
    [self dismissViewControllerAnimated:NO completion:nil];
//    if ( [[obj.selectedEvent objectForKey:@"invitee_check"] isEqual: @"needsAction"])
//    {
        obj.responseSection = 0;
        obj.responseIndex = 0;
        Event_Invites *define = [[Event_Invites alloc]initWithNibName:@"Event_Invites" bundle:nil];
        [self.navigationController pushViewController:define animated:YES];
//    }
//    else
//    {
//        Event_Details *define = [[Event_Details alloc]initWithNibName:@"Event_Details" bundle:nil];
//        [self.navigationController pushViewController:define animated:YES];
//    }
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.calendarBackGroundView.frame = CGRectMake(0, 66, self.view.frame.size.width, (self.view.frame.size.height-navBarHeight)/2);
    [self.calendarBackGroundView addSubview:frejunCalendar];
    self.calendarBackGroundView.clipsToBounds = YES;
    self.tableViewBackground.frame = CGRectMake(0, (self.view.frame.size.height-navBarHeight)/2+70, self.view.frame.size.width, (self.view.frame.size.height)/2);
    self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, (self.view.frame.size.height-navBarHeight)/2);
    [self.tableViewBackground addSubview:self.tableView];
    
    self.dragButton.center = CGPointMake(self.view.center.x, ((self.view.frame.size.height-navBarHeight)/2 + navBarHeight));
    self.line_view.center = CGPointMake(self.view.center.x, ((self.view.frame.size.height-navBarHeight)/2 + navBarHeight));

    CAGradientLayer *gradient3 = [CAGradientLayer layer];
    gradient3.frame = self.calendarBackGroundView.bounds;
    gradient3.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:32.0/255.0 green:81.0/255.0 blue:183.0/255.0 alpha:1.0] CGColor], (id)[[UIColor colorWithRed:51.0/255.0 green:179.0/255.0 blue:105.0/255.0 alpha:1.0] CGColor], nil];
    [self.calendarBackGroundView.layer insertSublayer:gradient3 atIndex:0];
    UISwipeGestureRecognizer * swipeleft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeleft:)];
    swipeleft.direction=UISwipeGestureRecognizerDirectionRight ;
    [_calendarBackGroundView addGestureRecognizer:swipeleft];
    
    UISwipeGestureRecognizer * swiperight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swiperight:)];
    swiperight.direction=UISwipeGestureRecognizerDirectionLeft ;
    [_calendarBackGroundView addGestureRecognizer:swiperight];
    
    [self blackBar];
}

- (void)wasDragged:(UIButton *)button withEvent:(UIEvent *)event// gesture
{
    // get the touch
    UITouch *touch = [[event touchesForView:button] anyObject];
    
    // get delta
    CGPoint previousLocation = [touch previousLocationInView:button];
    CGPoint location = [touch locationInView:button];
    CGFloat delta_x = location.x - previousLocation.x;
    CGFloat delta_y = location.y - previousLocation.y;
    
    if (button.center.y+delta_y < (self.view.frame.size.height-navBarHeight)/2 + navBarHeight)
    {
        // move button
        button.center = CGPointMake(button.center.x,
                                    button.center.y + delta_y);
        self.calendarBackGroundView.frame = CGRectMake(0, navBarHeight, self.view.frame.size.width, self.calendarBackGroundView.frame.size.height + delta_y);
        self.tableViewBackground.frame = CGRectMake(0, self.tableViewBackground.frame.origin.y + delta_y, self.view.frame.size.width, self.tableViewBackground.frame.size.height);
        self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-navBarHeight);
    }
}

- (void)finishedDragging:(UIButton *)button withEvent:(UIEvent *)event// drag gesture
{
    //doesn't get called
    NSLog(@"finished dragging");
    
    if (button.center.y < (self.view.frame.size.height-navBarHeight)/3)
    {
        button.center = CGPointMake(button.center.x, navBarHeight+2.8);
        self.calendarBackGroundView.frame = CGRectMake(0, navBarHeight, self.view.frame.size.width, 0);
        self.tableViewBackground.frame = CGRectMake(0, navBarHeight+3, self.view.frame.size.width, self.view.frame.size.height-70);
        self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-navBarHeight);
    }
    else if (button.center.y > (self.view.frame.size.height-navBarHeight)/2 + navBarHeight*2)
    {
        button.center = CGPointMake(button.center.x, self.view.frame.size.height);
        self.calendarBackGroundView.frame = CGRectMake(0, navBarHeight, self.view.frame.size.width, self.view.frame.size.height-navBarHeight);
        self.tableViewBackground.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 0);
        self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-navBarHeight);
        // frejunCalendar.frame = CGRectMake(0, 0, self.view.frame.size.width-20, 500);
    }
    else{
        button.center = CGPointMake(button.center.x, (self.view.frame.size.height-navBarHeight)/2 + navBarHeight);
        self.calendarBackGroundView.frame = CGRectMake(0, navBarHeight, self.view.frame.size.width, (self.view.frame.size.height-navBarHeight)/2);
        self.tableViewBackground.frame = CGRectMake(0, (self.view.frame.size.height-navBarHeight)/2 + navBarHeight+3, self.view.frame.size.width, (self.view.frame.size.height-navBarHeight)/2);
        self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, (self.view.frame.size.height-navBarHeight)/2);
        //frejunCalendar.frame = CGRectMake(0, 0, self.view.frame.size.width-20, 250);
    }
}

- (void)pan:(UIPanGestureRecognizer *)aPan;//pan gesture
{
    CGPoint currentPoint = [aPan locationInView:self.calendarBackGroundView];
    NSLog(@"hj");
    [UIView animateWithDuration:0.01f
                     animations:
     ^{
         CGRect oldFrame = _calendarBackGroundView.frame;
         _calendarBackGroundView.frame = CGRectMake(oldFrame.origin.x, currentPoint.y, oldFrame.size.width, ([UIScreen mainScreen].bounds.size.height - currentPoint.y));
     }];
}

-(void)blackBar // round drag parlalax effect
{
    [self.dragButton addTarget:self action:@selector(wasDragged:withEvent:)
              forControlEvents:UIControlEventTouchDragInside];
    
    [self.dragButton addTarget:self action:@selector(finishedDragging:withEvent:)
              forControlEvents:UIControlEventTouchDragExit|UIControlEventTouchUpInside];
}

-(void)refreshData
{
    [self loadData];
}

-(void)loadData
{
    deleteStatus = 0;
    json = [[NSArray alloc]init];
    dataclass *obj = [dataclass getInstance];
    NSString *url;
    NSArray *accounts = [[NSArray alloc]init];
    accounts = [[NSUserDefaults standardUserDefaults] objectForKey:@"accounts"];
    //http://162.243.64.69/prd/list_events/?user_email=frejun.testing3@gmail.com
    url = [NSString stringWithFormat:@"%@?user_email=frejun.testing3@gmail.com",directoryEventList];
    NSLog(@"%@",url);
    url = [url stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSURL *queryUrl = [NSURL URLWithString:url];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                   ^{
                       NSData *data4 = [NSData dataWithContentsOfURL: queryUrl];
                       NSError* error;
                       NSString* newStr = [[NSString alloc] initWithData:data4 encoding:NSUTF8StringEncoding];
                       if(data4)
                       {
                           json = [NSJSONSerialization
                                   JSONObjectWithData:data4
                                   options:kNilOptions
                                   error:&error];
                           NSLog(@"my value is%@",json);
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              if (json)
                                              {
                                                  [self createDataToDisplayInApp2];
                                              }
                                              else
                                              {
                                                  //NSLog(@"choolaaaaa 2");
                                                  [loadingView setHidden:YES];
                                                  obj.sortedEvents = [[NSUserDefaults standardUserDefaults] objectForKey:@"offlineData"];
                                                  obj.events = [[NSUserDefaults standardUserDefaults] objectForKey:@"offlineEvents"];
                                                  obj.eventsforCalendar = [[NSUserDefaults standardUserDefaults] objectForKey:@"offlineEvents"];
                                                  finalData = [[NSMutableArray alloc]initWithArray: obj.sortedEvents];
                                                  json = obj.events;
                                                  [self.tableView reloadData];
                                                  
                                                  // loading = NO;
                                                  // [self alertStatus:@"Please try again after some time." :@"Connection Failed!"];
                                              }
                                          });
                       }
                       else{
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              [loadingView setHidden:YES];
                                              obj.sortedEvents = [[NSUserDefaults standardUserDefaults] objectForKey:@"offlineData"];
                                              obj.events = [[NSUserDefaults standardUserDefaults] objectForKey:@"offlineEvents"];
                                              obj.eventsforCalendar = [[NSUserDefaults standardUserDefaults] objectForKey:@"offlineEvents"];
                                              finalData = [[NSMutableArray alloc]initWithArray: obj.sortedEvents];
                                              json = obj.events;
                                              [self.tableView reloadData];
                                              
                                              // loading = NO;
                                              //  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Connection Failed!" message:@"Please check your Internet Connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                              //  [alertView show];
                                              
                                              
                                              
                                              //NSLog(@"poopo");
                                          });}
                   });
}

-(NSArray *)returnFilteredEvents:(NSArray *)JSONevents//filter the events based on the selected a/c
{
    NSArray *filteredEvents = [[NSArray alloc]init];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"navTitle"]  isEqual: @"All Accounts"])
    {
        filteredEvents = JSONevents;
    }
    else
    {
        NSMutableArray *tempArray = [[NSMutableArray alloc]init];
        for (int i =0; i<JSONevents.count; i++)
        {
            if ([[[JSONevents objectAtIndex:i] objectForKey:@"email"] isEqualToString:[[NSUserDefaults standardUserDefaults] stringForKey:@"email1"]] || [[[JSONevents objectAtIndex:i] objectForKey:@"relatedEmail"] isEqualToString:[[NSUserDefaults standardUserDefaults] stringForKey:@"email1"]] )
            {
                [tempArray addObject:[JSONevents objectAtIndex:i]];
            }
        }
        filteredEvents = tempArray;
    }
    return filteredEvents;
}

- (int)daysBetween:(NSDate *)dt1 and:(NSDate *)dt2//days difference
{
    NSUInteger unitFlags = NSDayCalendarUnit;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:unitFlags fromDate:dt1 toDate:dt2 options:0];
    return [components day]+1;
}

-(void)fetchPref //get preferences
{
    dataclass *obj = [dataclass getInstance];
    NSString *url = [NSString stringWithFormat:@"%@?email=%@&userID=%@",directoryFetchPref,obj.emailTitle,[[NSUserDefaults standardUserDefaults] stringForKey:@"userID"]];
    NSLog(@"%@",url);
    url = [url stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSURL *queryUrl = [NSURL URLWithString:url];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data2 = [NSData dataWithContentsOfURL: queryUrl];
        NSError* error;
        //NSLog(@"bholi %@",data2);
        NSString* newStr = [[NSString alloc] initWithData:data2 encoding:NSUTF8StringEncoding];
        NSString *newStr1 = [newStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        //NSLog(@"string is : %@",newStr);
        
        if(data2)
        {
            NSArray *pref = [NSJSONSerialization
                             JSONObjectWithData:data2
                             options:kNilOptions
                             error:&error];
            //NSLog(@"%@",pref);
            dispatch_async(dispatch_get_main_queue(),
                           ^{
                               [loadingView setHidden:YES];
                               if ([newStr1 isEqualToString:@"no data"]) {
                                   obj.pref = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@0,@"sound",@15,@"defaultEtdAlert",@0,@"timezone",@15,@"defaultEtaAlert",@30,@"defaultMeetDuration", nil];
                               }
                               else{
                                   
                                   obj.pref = [[NSMutableDictionary alloc]initWithDictionary:[pref objectAtIndex:0]];
                                   
                               }
                           });
        }
    });
}

-(void)createDataToDisplayInApp2
{
    dataclass *obj = [dataclass getInstance];
    finalData = [[NSMutableArray alloc]init];
    NSMutableArray *dates = [[NSMutableArray alloc]init];
    NSMutableArray *calendarEvents = [[NSMutableArray alloc]init];
    
    NSArray *modifiedJSON = [self returnFilteredEvents:[json valueForKey:@"items"]];
    for (int i = 0; i < modifiedJSON.count ; i++)
    {
        if ([[[[modifiedJSON objectAtIndex:i] objectForKey:@"start"]objectForKey:@"date"] length] > 7)
        {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"YYYY-MM-dd"];
            
            NSDate *startDate = [dateFormatter dateFromString:[[[[json valueForKey:@"items"] objectAtIndex:i] objectForKey:@"start"]objectForKey:@"date"] ];
            NSDate *endDate = [dateFormatter dateFromString:[[[[json valueForKey:@"items"] objectAtIndex:i] objectForKey:@"end"]objectForKey:@"date"] ];
            
            for (int j = 1; j <= [self daysBetween:startDate and:endDate] ; j++)
            {
                NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                NSDateComponents *comps = [[NSDateComponents alloc]init];
                [comps setDay:j];
                NSString *datetoAdd = [[NSString stringWithFormat:@"%@",[calendar dateByAddingComponents:comps toDate:startDate options:0]] substringToIndex:10];
                if (![self checkifDateAlreadyExists:datetoAdd])
                {
                    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
                    [tempDict setObject:datetoAdd forKey:@"date"];
                    NSMutableArray *tempArr = [[NSMutableArray alloc]init];
                    [tempArr addObject:[modifiedJSON objectAtIndex:i]];
                    [tempDict setObject:tempArr forKey:@"events"];
                    [finalData addObject:tempDict];
                    
                    [dates addObject:datetoAdd];
                    NSMutableDictionary *eventDict =  [[NSMutableDictionary alloc]initWithDictionary:[modifiedJSON objectAtIndex:i]];
                    [eventDict setValue:datetoAdd forKey:@"startTime_real"];
                    [calendarEvents addObject:eventDict];
                }
                else
                {
                    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
                    [tempDict setObject:datetoAdd forKey:@"date"];
                    int dateIndex = [self getIndexforDate:datetoAdd];
                    NSMutableArray *tempArr = [[NSMutableArray alloc]initWithArray:finalData[dateIndex][@"events"]];
                    [tempArr addObject:[modifiedJSON objectAtIndex:i]];
                    NSSortDescriptor *dateDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"startTime_real"
                                                                                     ascending:YES];
                    NSArray *sortDescriptors = [NSArray arrayWithObject:dateDescriptor];
                    NSArray *sortedEventArray = [tempArr sortedArrayUsingDescriptors:sortDescriptors];
                    tempArr = [[NSMutableArray alloc] initWithArray:sortedEventArray];
                    [tempDict setObject:tempArr forKey:@"events"];
                    [finalData replaceObjectAtIndex:dateIndex withObject:tempDict];
                    
                    NSMutableDictionary *eventDict = [[NSMutableDictionary alloc]initWithDictionary:[modifiedJSON objectAtIndex:i]];
                    [eventDict setValue:datetoAdd forKey:@"startTime_real"];
                    [calendarEvents addObject:eventDict];
                }
            }
        }
    }
    
    NSSortDescriptor *dateDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:dateDescriptor];
    NSArray *sortedEventArray = [finalData sortedArrayUsingDescriptors:sortDescriptors];
    finalData = [[NSMutableArray alloc] initWithArray:sortedEventArray];
    obj.dates = dates;
    obj.events = modifiedJSON;
    obj.eventsforCalendar = calendarEvents;
    obj.sortedEvents = finalData;
    
    [[NSUserDefaults standardUserDefaults] setObject:finalData forKey:@"offlineData"];
    [[NSUserDefaults standardUserDefaults] setObject:modifiedJSON forKey:@"offlineEvents"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.tableView reloadData];
    
    if (!scrolledToCurrentDate)
    {
        if ([finalData count] > 0)
        {
           // [self nearestDate:finalData];
        }
    }
}
-(void)nearestDate:(NSArray *)dates//table scroll to near to current date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *today = [dateFormatter dateFromString:[[NSString stringWithFormat:@"%@",[NSDate date]] substringToIndex:10]];
    int finalDate = 0;
    int index = 0;
    
    if ([dates count] > 0)
    {
        finalDate = [self daysBetween:today and:[dateFormatter dateFromString:[[dates lastObject] objectForKey:@"date"]]];
        
        if (finalDate < 0)
        {
            finalDate = 0;
        }
    }
    
    //NSLog(@"Date 1: %@ and Date 2: %@", today, [dateFormatter dateFromString:[[dates objectAtIndex:0] objectForKey:@"date"]]);
    for (int i=0; i<dates.count; i++)
    {
        int diff = [self daysBetween:today and:[dateFormatter dateFromString:[[dates objectAtIndex:i] objectForKey:@"date"]]];
        NSLog(@"Diff is : %d", diff);
        if (diff>0 && diff<finalDate)
        {
            finalDate = diff;
            index = i;
        }
    }
    
    if (index == 0)
    {
        index = (int)dates.count - 1;
    }
    NSLog(@"Index is : %d", index);
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]
                          atScrollPosition:UITableViewScrollPositionTop
                                  animated:YES];
    scrolledToCurrentDate = YES;
    NSLog(@"hayee oye");
}

-(BOOL)checkifDateAlreadyExists:(NSString *)date//date exist or not
{
    BOOL result;
    result = NO;
    for (int i=0; i<finalData.count; i++)
    {
        if ([finalData[i][@"date"] isEqualToString:date])
        { result = YES; }
    }
    return result;
}

-(int)getIndexforDate:(NSString *)date//if date exist return index
{
    for (int i=0; i<finalData.count; i++)
    { if ([finalData[i][@"date"] isEqualToString:date]) { return i; }
    }
    return 0;
}

#pragma mark Tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[finalData[section] objectForKey:@"events"] count];
   // return finalData.count;
    //return 0;

    NSLog(@"count row : %ld %lu",(long)section,[[finalData[section] objectForKey:@"events"] count]);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid=@"mainTableViewCell";
    mainTableViewCell *cell = (mainTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell==nil)
    {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"mainTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    //title = [json[indexPath.row] objectForKey:@"eventName"];
    NSString *title = [[finalData[indexPath.section] objectForKey:@"events"][indexPath.row] objectForKey:@"summary"];
    if (title.length == 0)
    {
        title = @"No title";
    }
    cell.title.text = title;
    cell.title.frame = CGRectMake(cell.title.frame.origin.x, 0, [title sizeWithFont:cell.textLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, cell.frame.size.height)].width, cell.frame.size.height);
    
    int priorityLevel = [[[finalData[indexPath.section] objectForKey:@"events"][indexPath.row] objectForKey:@"priority"] intValue];
    switch(priorityLevel)
    {
        case 0 :
            cell.priorityLabel.text = @"";
            break;
        case 1 :
            cell.priorityLabel.text = @"!";
            break;
        case 2 :
            cell.priorityLabel.text = @"!!";
            break;
        case 3 :
            cell.priorityLabel.text = @"!!!";
            break;
        default :
            cell.priorityLabel.text = @"";
    }
    
    cell.priorityLabel.frame = CGRectMake(cell.title.frame.origin.x + cell.title.frame.size.width+20, 0, 35, cell.frame.size.height);
    
    if([[[finalData[indexPath.section] objectForKey:@"events"][indexPath.row] objectForKey:@"invitee_check"]  isEqual: @"needsAction"])
    {
        
        cell.priorityLabel.text = @"Unaccepted invite";
        cell.priorityLabel.frame = CGRectMake(cell.title.frame.origin.x + cell.title.frame.size.width+20, 0, 90, cell.frame.size.height);
        cell.priorityLabel.adjustsFontSizeToFitWidth = YES;
        //cell.priorityLabel.textColor = [UIColor yellowColor];
        
    }
    //cell.priorityLabel.text = [events[indexPath.row] objectForKey:@"Priority"];
    
    cell.accessoryType = [[[finalData[indexPath.section] objectForKey:@"events"][indexPath.row] objectForKey:@"state"] boolValue] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    // Add utility buttons
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:25.0/255.0 green:181.0/255.0 blue:90.0/255.0 alpha:1]
                                                icon:[UIImage imageNamed:@"shar.png"]];
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:248.0/255.0 green:159.0/255.0 blue:52.0/255.0 alpha:1]
                                                icon:[UIImage imageNamed:@"penc.png"]];
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:232.0/255.0 green:83.0/255.0 blue:73.0/255.0 alpha:1]
                                                icon:[UIImage imageNamed:@"dust.png"]];
    
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
                                                title:@"More"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"Delete"];
    
    //cell.leftUtilityButtons = leftUtilityButtons;
    cell.rightUtilityButtons = leftUtilityButtons;
    cell.delegate = self;
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    dataclass *obj = [dataclass getInstance];
    obj.selectedEvent = [finalData[indexPath.section] objectForKey:@"events"][indexPath.row];
    
//    if ( [[obj.selectedEvent objectForKey:@"invitee_check"] isEqual: @"needsAction"])
//    {
        obj.responseSection = (int)indexPath.section;
        obj.responseIndex = (int)indexPath.row;
        
        Event_Invites *define = [[Event_Invites alloc]initWithNibName:@"Event_Invites" bundle:nil];
        [self.navigationController pushViewController:define animated:YES];
//    }
//    else
//    {
//    Event_Details *define = [[Event_Details alloc]initWithNibName:@"Event_Details" bundle:nil];
//    [self.navigationController pushViewController:define animated:YES];
// 
//     }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return finalData.count;
   // return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionHeaderView;
    
    sectionHeaderView = [[UIView alloc] initWithFrame:
                         CGRectMake(0, 0, tableView.frame.size.width, 30)];
    
    
    sectionHeaderView.backgroundColor = [UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:243.0/255.0 alpha:1];;
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:
                            CGRectMake(10,0, sectionHeaderView.frame.size.width, sectionHeaderView.frame.size.height)];
    
    headerLabel.backgroundColor = [UIColor clearColor];
    [headerLabel setTextColor:[UIColor lightGrayColor]];
    [headerLabel setFont:[UIFont systemFontOfSize:12]];
    [sectionHeaderView addSubview:headerLabel];
    headerLabel.text = [finalData[section] objectForKey:@"date"];
    NSDate *dateFromString = [[NSDate alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    dateFromString = [dateFormatter dateFromString:[finalData[section] objectForKey:@"date" ]];
    [dateFormatter setDateFormat:@"EEEE/d/MMMM-yyyy"];
    NSLog(@"%@",[dateFormatter stringFromDate:dateFromString]);
    
    NSString *date_str= [dateFormatter stringFromDate:dateFromString];
    
    NSArray *test_ary=[date_str componentsSeparatedByString:@"/"];
    NSString *day_str=[test_ary objectAtIndex:1];
    NSString *day_with_st=[NSString stringWithFormat:@"%@%@",day_str,[self daySuffixForDate:[day_str integerValue]]];
    
    NSDate *todayDate = [NSDate date]; //Get todays date
    NSDateFormatter *df = [[NSDateFormatter alloc] init]; // here we create NSDateFormatter object for change the Format of date.
    [df setDateFormat:@"EEEE/d/MMMM-yyyy"]; //Here we can set the format which we need
    NSString *convertedDateString = [df stringFromDate:todayDate];
    NSDate *today_date=[df dateFromString:convertedDateString];
    NSDate *event_date=[df dateFromString:date_str];

    if ([today_date compare:event_date] == NSOrderedSame)
    {
        NSString *header_date=[NSString stringWithFormat:@"TODAY'S TASK %@ %@-%@",[test_ary objectAtIndex:0],day_with_st,[test_ary objectAtIndex:2]];
        headerLabel.text =header_date;
    }
    else
    {
    NSString *header_date=[NSString stringWithFormat:@"%@ %@-%@",[test_ary objectAtIndex:0],day_with_st,[test_ary objectAtIndex:2]];
        headerLabel.text =header_date;
    }
    
    /*
    NSDate *date = [NSDate date];
    NSDateFormatter *prefixDateFormatter = [[NSDateFormatter alloc] init];
    [prefixDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [prefixDateFormatter setDateFormat:@"EEEE  d MMMM-yyyy"];
    NSString *prefixDateString = [prefixDateFormatter stringFromDate:date];
    NSDateFormatter *monthDayFormatter = [[NSDateFormatter alloc] init];
    [monthDayFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [monthDayFormatter setDateFormat:@"d"];
    int date_day = [[monthDayFormatter stringFromDate:date] intValue];
    NSString *suffix_string = @"|st|nd|rd|th|th|th|th|th|th|th|th|th|th|th|th|th|th|th|th|th|st|nd|rd|th|th|th|th|th|th|th|st";
    NSArray *suffixes = [suffix_string componentsSeparatedByString: @"|"];
    NSString *suffix = [suffixes objectAtIndex:date_day];
    NSString *dateString = [prefixDateString stringByAppendingString:suffix];
    NSLog(@"%@", dateString);
    */
    //    switch (section) {
    //        case 0:
    //            headerLabel.text = @"Section 1";
    //            return sectionHeaderView;
    //            break;
    //        case 1:
    //            headerLabel.text = @"Section 2";
    //            return sectionHeaderView;
    //            break;
    //        case 2:
    //            headerLabel.text = @"Section 3";
    //            return sectionHeaderView;
    //            break;
    //        default:
    //            break;
    //    }
    
    return sectionHeaderView;
}
- (NSString *)daySuffixForDate:(NSInteger)date
{
    
    switch (date) {
        case 1:
        case 21:
        case 31: return @"st";
        case 2:
        case 22: return @"nd";
        case 3:
        case 23: return @"rd";
        default: return @"th";
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001;
}

-(void) SACalendar:(SACalendar*)calendar didSelectDate:(int)day month:(int)month year:(int)year//calender click
{
    NSLog(@"Date Selected : %02i/%02i/%04i",day,month,year);
    NSString *date = [NSString stringWithFormat:@"%04i-%02i-%02i",year,month,day];
    NSLog(@"date here %@",date);
    dataclass *obj = [dataclass getInstance];
    for (int i = 0; i < finalData.count; i++)
    {
        if ([[finalData[i] objectForKey:@"date"] isEqualToString:date])
        {
            obj.events = [finalData[i] objectForKey:@"events"];
            obj.selectedDate = date;
            NSDate *dateFromString = [[NSDate alloc] init];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            dateFromString = [dateFormatter dateFromString:date];
            [dateFormatter setDateFormat:@"EEEE,MMMM d,yyyy"];
            obj.selectedDate = [dateFormatter stringFromDate:dateFromString];
            /*
            calenderViewController* infoController = [self.storyboard instantiateViewControllerWithIdentifier:@"calender"];
            [self.navigationController pushViewController:infoController animated:YES];
             */
        }
    }
    
}

/**
 *  Delegate method : get called user has scroll to a new month
 */
-(void) SACalendar:(SACalendar *)calendar didDisplayCalendarForMonth:(int)month year:(int)year
{
    NSLog(@"Displaying : %@ %04i",[DateUtil getMonthString:month],year);
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    switch (index)
    {
        case 0:
        {
            NSString * message = @"The most sophisticated calendar app with a built-in personal assistant to manage a busy life. Check www.frejun.com now !!";
            NSArray * shareItems = @[message];
            
            UIActivityViewController * avc = [[UIActivityViewController alloc] initWithActivityItems:shareItems applicationActivities:nil];
            [self presentViewController:avc animated:YES completion:nil];
            break;
        }
        case 1:
        {
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            dataclass *obj = [dataclass getInstance];
            if ([[[finalData[indexPath.section] objectForKey:@"events"][indexPath.row] objectForKey:@"email"] isEqualToString: obj.emailTitle]) {
                
                obj.selectedEvent = [finalData[indexPath.section] objectForKey:@"events"][indexPath.row];
                /*EditEventTableViewController* infoController = [self.storyboard instantiateViewControllerWithIdentifier:@"editevent"];
                [self.navigationController pushViewController:infoController animated:YES];
                */
            }
            else{
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No Permissions" message:@"You are not authorised to edit this event." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alertView show];
            }
            break;
        }
        case 2:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [loadingView setHidden:NO];
            });
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            dataclass *obj = [dataclass getInstance];
            if (![[finalData[indexPath.section] objectForKey:@"events"][indexPath.row] objectForKey:@"relatedEmail"]) {
                NSString *url = [NSString stringWithFormat:@"%@?id=%@",directoryDeleteEvent,[[finalData[indexPath.section] objectForKey:@"events"][indexPath.row] objectForKey:@"eventID"]];
                NSLog(@"%@",url);
                url = [url stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
                NSURL *queryUrl = [NSURL URLWithString:url];
                [[finalData[indexPath.section] objectForKey:@"events"] removeObjectAtIndex:indexPath.row];
                [self.tableView reloadData];
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSData *data = [NSData dataWithContentsOfURL: queryUrl];
                    NSError* error;
                    NSLog(@"bholi %@",data);
                    NSString* newStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    NSLog(@"string is : %@",newStr);
                    if(data){
                        json = [NSJSONSerialization
                                JSONObjectWithData:data
                                options:kNilOptions
                                error:&error];
                        NSLog(@"%@",json);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (1) {
                                [loadingView setHidden:YES];
                                //[self loadData];
                            }
                        });
                        
                    }
                    else{
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [loadingView setHidden:YES];
                            // loading = NO;
                            // [self alertStatus:@"Please try again after some time." :@"Connection Failed!"];
                            
                        });}
                });
            }
            else{
                
                // UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No Permissions" message:@"You are not authorised to delete this event." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                // [alertView show];
                
                NSString *url = [NSString stringWithFormat:@"%@?email=%@&action=declined&eventid=%@",directoryaccept,[[finalData[indexPath.section] objectForKey:@"events"][indexPath.row] objectForKey:@"relatedEmail"],[[finalData[indexPath.section] objectForKey:@"events"][indexPath.row] objectForKey:@"eventID"]];
                NSLog(@"%@",url);
                url = [url stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
                NSURL *queryUrl = [NSURL URLWithString:url];
                [[finalData[indexPath.section] objectForKey:@"events"] removeObjectAtIndex:indexPath.row];
                [self.tableView reloadData];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSData *data2 = [NSData dataWithContentsOfURL: queryUrl];
                    NSError* error;
                    //NSLog(@"bholi %@",data2);
                    NSString* newStr = [[NSString alloc] initWithData:data2 encoding:NSUTF8StringEncoding];
                    //NSLog(@"string is : %@",newStr);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //[self.navigationController popViewControllerAnimated:YES];
                    });
                    if(data2){
                        NSArray *pref = [NSJSONSerialization
                                         JSONObjectWithData:data2
                                         options:kNilOptions
                                         error:&error];
                        NSLog(@"%@",pref);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //  [loadingView setHidden:YES];
                            
                            //  [self.navigationController popViewControllerAnimated:YES];
                            
                        });
                    }
                });
                
                
            }
            break;
        }
        case 3:
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Twitter Sharing" message:@"Just shared the pattern image on Twitter" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertView show];
        }
        default:
            break;
    }
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    //    [self filterContentForSearchText:searchString
    //                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
    //                                      objectAtIndex:[self.searchDisplayController.searchBar
    //                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

# pragma mark - Search Results Updater
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController//search results
{
    // filter the search results
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains [cd] %@", self.controller.searchBar.text];
    // NSPredicate *predicate = [NSPredicate predicateWithFormat:@"eventName contains [c] %@", self.controller.searchBar.text];
    //self.results = [json filteredArrayUsingPredicate:predicate];
    
    
    
    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"summary contains [c] %@", self.controller.searchBar.text];
    
    NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"creator.email contains [c] %@", self.controller.searchBar.text];
    
    NSPredicate *predicate3 = [NSPredicate predicateWithFormat:@"organizer.email contains [c] %@", self.controller.searchBar.text];
    
    NSPredicate *predicate4 = [NSPredicate predicateWithFormat:@"status contains [c] %@", self.controller.searchBar.text];
    
//    NSPredicate *predicate5 = [NSPredicate predicateWithFormat:@"name contains [c] %@", self.controller.searchBar.text];
//    
//    NSPredicate *predicate6 = [NSPredicate predicateWithFormat:@"notes contains [c] %@", self.controller.searchBar.text];
//    
//    NSPredicate *predicate7 = [NSPredicate predicateWithFormat:@"relatedEmail contains [c] %@", self.controller.searchBar.text];
    
    NSPredicate *predicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[predicate1, predicate2,predicate3, predicate4]];
    
    self.results = [[json valueForKey:@"items"] filteredArrayUsingPredicate:predicate];
    NSLog(@"Search text are: %@", self.controller.searchBar.text);
    
    NSLog(@"Search Results are: %@", [self.results description]);
}

- (UISearchController *)controller {
    
    if (!_controller) {
        
        // instantiate search results table view
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SearchResultsViewController *resultsController = [storyboard instantiateViewControllerWithIdentifier:@"SearchResults"];
        
        // create search controller
        _controller = [[UISearchController alloc]initWithSearchResultsController:resultsController];
        _controller.searchResultsUpdater = self;
        
        // optional: set the search controller delegate
        _controller.delegate = self;
        
    }
    return _controller;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)search_click:(id)sender
{
    [self presentViewController:self.controller animated:YES completion:nil];
//    Notifications *define = [[Notifications alloc]initWithNibName:@"Notifications" bundle:nil];
//    [self.navigationController pushViewController:define animated:YES];
}

- (IBAction)add_event:(id)sender {
}
@end
