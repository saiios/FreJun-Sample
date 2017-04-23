//
//  Event_Details.m
//  Sample
//
//  Created by INDOBYTES on 19/04/17.
//  Copyright © 2017 indo. All rights reserved.
//
#define leftMargin 15
#define multiplier 0.8
#import "Event_Details.h"

@interface Event_Details ()

@end

@implementation Event_Details
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationItem setHidesBackButton:YES];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // [[Amplitude instance] logEvent:@"Event Details"];
    dataclass *obj = [dataclass getInstance];
    NSLog(@"hyee %@",obj.selectedEvent);
    NSDictionary *selectedEvent = obj.selectedEvent;
    
    self.navigationItem.title = @"Event Details";
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]init];
    [editButton setTitle:@"Edit"];
    [editButton setAction:@selector(edit)];
    [editButton setTarget:self];
    self.navigationItem.rightBarButtonItem = editButton;
    CGFloat fullWidth = self.view.frame.size.width - leftMargin*2;
    NSArray *invitees = [[NSArray alloc]initWithObjects:
                         @{@"email":@"saikrishna@indobytes.com",
                           @"status":@"2"},
                         @{@"email":@"saikrishna4477@gmail.com",
                           @"status":@"1"},
                         @{@"email":@"sai@gmail.com",
                           @"status":@"0"},
                         nil];
    //invitees = [selectedEvent objectForKey:@"invitees"];
    
//    NSError *error;
//    NSString *string = [[selectedEvent objectForKey:@"attendees"] stringByReplacingOccurrencesOfString:@"\\" withString:@""];
//    string = [string stringByReplacingOccurrencesOfString:@"]" withString:@"}"];
//    string = [string stringByReplacingOccurrencesOfString:@"[" withString:@"{"];
//    string = [NSString stringWithFormat:@"[%@]",string];
//    NSLog(@"%@",string);
//    NSData* data = [string dataUsingEncoding:NSUTF8StringEncoding];
//    NSArray *json = [NSJSONSerialization
//                     JSONObjectWithData:data
//                     options:kNilOptions
//                     error:&error];
    
//    NSLog(@"json = %@",json);
    invitees = [selectedEvent objectForKey:@"attendees"];
    //Scroll View
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 66, self.view.frame.size.width, self.view.frame.size.height-126)];
    //scrollView.backgroundColor = [UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:243.0/255.0 alpha:1];
    [self.view addSubview:scrollView];
    scrollView.backgroundColor = [UIColor whiteColor];
    
    //Empty View
    UIView* emptyView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 35*multiplier)];
    emptyView.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1];
    [scrollView addSubview:emptyView];
    
    //Event Name Label
    UILabel *eventName = [[UILabel alloc]initWithFrame:CGRectMake(leftMargin, 50*multiplier, fullWidth, 18*multiplier)];
    eventName.font = [eventName.font fontWithSize:17*multiplier];
    eventName.text = [selectedEvent objectForKey:@"summary"];
    [scrollView addSubview:eventName];
    
    //Address 1 Label
    UILabel *address1 = [[UILabel alloc]initWithFrame:CGRectMake(leftMargin, eventName.frame.origin.y+eventName.frame.size.height+9*multiplier, fullWidth, 15*multiplier)];
    address1.font = [address1.font fontWithSize:14*multiplier];
    address1.text = [selectedEvent objectForKey:@"location"];
    address1.textColor = [UIColor grayColor];
    [scrollView addSubview:address1];
    
    //Address 2 Label
    UILabel *address2 = [[UILabel alloc]initWithFrame:CGRectMake(leftMargin, address1.frame.origin.y+address1.frame.size.height+7*multiplier, fullWidth, 15*multiplier)];
    address2.font = [address2.font fontWithSize:14*multiplier];
    address2.text = [selectedEvent objectForKey:@"address2"];
    address2.textColor = [UIColor grayColor];
    //[scrollView addSubview:address2];
    
    //Day Label
    UILabel *day = [[UILabel alloc]initWithFrame:CGRectMake(leftMargin, address1.frame.origin.y+address1.frame.size.height+16*multiplier, fullWidth, 20*multiplier)];
    day.font = [day.font fontWithSize:18*multiplier];
    NSDate *dateFromString = [[NSDate alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    dateFromString = [dateFormatter dateFromString:[[selectedEvent objectForKey:@"start"] valueForKey:@"date"]];
    [dateFormatter setDateFormat:@"EEEE, MMM d, yyyy"];
    day.text = [dateFormatter stringFromDate:dateFromString];
    day.textColor = [UIColor grayColor];
    //[scrollView addSubview:day];
    
    
    UIButton *viewDirections = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 100, 0*multiplier, 100, 25)];
    [viewDirections setTitle:@"View Directions" forState:UIControlStateNormal];
    //[viewDirections setBackgroundColor:[UIColor blueColor]];
    [viewDirections setTitleColor:[UIColor colorWithRed:28.0/255.0 green:87.0/255.0 blue:255.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    viewDirections.titleLabel.font = [UIFont systemFontOfSize:12];
    [viewDirections addTarget:self action:@selector(openGoogleMaps) forControlEvents:UIControlEventTouchUpInside];
    if (![[selectedEvent objectForKey:@"longitude"] isEqualToString:@""]) {
        [scrollView addSubview:viewDirections];
    }
    
    //Time 1 Label
    UILabel *time1 = [[UILabel alloc]initWithFrame:CGRectMake(leftMargin, address1.frame.origin.y+address1.frame.size.height+16*multiplier, fullWidth, 20*multiplier)];
    time1.font = [time1.font fontWithSize:20*multiplier];
    time1.adjustsFontSizeToFitWidth = YES;
    time1.text = [selectedEvent objectForKey:@"startTime_real"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    dateFromString = [dateFormatter dateFromString:[[selectedEvent objectForKey:@"start"] valueForKey:@"date"]];
    NSLog(@"dd%@", dateFromString);
    [dateFormatter setDateFormat:@"MMM d, yyyy, HH:mm (EEEE)"];
    time1.text = [NSString stringWithFormat:@"From %@",[dateFormatter stringFromDate:dateFromString]];
    
    time1.textColor = [UIColor grayColor];
    [scrollView addSubview:time1];
    
    //Time 2 Label
    UILabel *time2 = [[UILabel alloc]initWithFrame:CGRectMake(leftMargin, time1.frame.origin.y+time1.frame.size.height+4*multiplier, fullWidth, 20*multiplier)];
    time2.font = [time2.font fontWithSize:20*multiplier];
    //time2.adjustsFontSizeToFitWidth = YES;
    time2.text = [selectedEvent objectForKey:@"endTime_real"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    dateFromString = [dateFormatter dateFromString:[[selectedEvent objectForKey:@"end"] valueForKey:@"date"]];
    NSLog(@"dd%@", dateFromString);
    [dateFormatter setDateFormat:@"MMM d, yyyy, HH:mm (EEEE)"];
    time2.text = [NSString stringWithFormat:@"To %@",[dateFormatter stringFromDate:dateFromString]];
    time2.textColor = [UIColor grayColor];
    [scrollView addSubview:time2];
    
    //line separator
    UIView* separatorLineView = [[UIView alloc]initWithFrame:CGRectMake(leftMargin, time2.frame.origin.y+time2.frame.size.height+18*multiplier, fullWidth+leftMargin, 1)];
    separatorLineView.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1];
    [scrollView addSubview:separatorLineView];
    
    //Calender Label
    UILabel *calender = [[UILabel alloc]initWithFrame:CGRectMake(leftMargin, separatorLineView.frame.origin.y+separatorLineView.frame.size.height+12*multiplier, 80*multiplier, 18*multiplier)];
    calender.font = [calender.font fontWithSize:17*multiplier];
    calender.text = @"Calendar";
    [scrollView addSubview:calender];
    
    //Calender Text Label
    UILabel *calenderText = [[UILabel alloc]initWithFrame:CGRectMake(leftMargin + calender.frame.size.width + 40*multiplier, separatorLineView.frame.origin.y+separatorLineView.frame.size.height+12*multiplier, fullWidth - calender.frame.size.width - 40*multiplier, 18*multiplier)];
    calenderText.font = [calenderText.font fontWithSize:17*multiplier];
    calenderText.textAlignment = NSTextAlignmentRight;
    calenderText.text = [selectedEvent objectForKey:@"email"];
    if ([selectedEvent objectForKey:@"relatedEmail"]) {
        calenderText.text = [selectedEvent objectForKey:@"relatedEmail"];
    }
    CGSize constraintSize = CGSizeMake(MAXFLOAT, calenderText.frame.size.height);
    CGSize labelSize = [calenderText.text sizeWithFont:calenderText.font constrainedToSize:constraintSize];
    if (labelSize.width > calenderText.frame.size.width) {
        calenderText.adjustsFontSizeToFitWidth= YES;
    }
    else{
        calenderText.frame = CGRectMake(fullWidth-labelSize.width+13, calenderText.frame.origin.y, labelSize.width, calenderText.frame.size.height);
    }
    calenderText.textColor = [UIColor grayColor];
    [scrollView addSubview:calenderText];
    
    //dot View
    UIView* dotView = [[UIView alloc]initWithFrame:CGRectMake(calenderText.frame.origin.x - 20, calenderText.center.y-4, 10, 10)];
    dotView.layer.cornerRadius = dotView.frame.size.height/2;
    dotView.backgroundColor = [UIColor colorWithRed:100.0/255.0 green:218.0/255.0 blue:54.0/255.0 alpha:1];
    NSArray * temp = [[NSUserDefaults standardUserDefaults] objectForKey:@"accounts"];
    int index = 0;
    for (int i = 0; i < temp.count; i++) {
        if ([[selectedEvent objectForKey:@"email"] isEqualToString:temp[i]]) {
            index = i;
        }
    }
    NSArray *colors = [[NSArray alloc]init];
    colors = @[color1,color2,color3,color4,color5];
    dotView.backgroundColor = colors[index];
    [scrollView addSubview:dotView];
    
    //line separator 2
    UIView* separatorLineView2 = [[UIView alloc]initWithFrame:CGRectMake(leftMargin, calenderText.frame.origin.y+calenderText.frame.size.height+18*multiplier, fullWidth+leftMargin, 1)];
    separatorLineView2.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1];
    [scrollView addSubview:separatorLineView2];
    
    //ETDReminder Label
    UILabel *ETDReminder = [[UILabel alloc]initWithFrame:CGRectMake(leftMargin, separatorLineView2.frame.origin.y+separatorLineView2.frame.size.height+12*multiplier, 195*multiplier, 18*multiplier)];
    ETDReminder.font = [ETDReminder.font fontWithSize:17*multiplier];
    ETDReminder.text = @"Reminder based on ETD";
    [scrollView addSubview:ETDReminder];
    
    //ETDReminder Text Label
    UILabel *ETDReminderText = [[UILabel alloc]initWithFrame:CGRectMake(leftMargin+ ETDReminder.frame.size.width + 10*multiplier, separatorLineView2.frame.origin.y+separatorLineView2.frame.size.height+12*multiplier, fullWidth- ETDReminder.frame.size.width - 10*multiplier, 18*multiplier)];
    ETDReminderText.font = [ETDReminderText.font fontWithSize:17*multiplier];
    ETDReminderText.textAlignment = NSTextAlignmentRight;
    ETDReminderText.adjustsFontSizeToFitWidth= YES;
    int etd = [[selectedEvent valueForKey:@"ETDRemind"] intValue];
    switch(etd)
    {
        case 0 :
            ETDReminderText.text = @"On Time";
            break;
        case 10 :
            ETDReminderText.text = @"10 min before";
            break;
        case 30 :
            ETDReminderText.text = @"30 min before";
            break;
        case 60 :
            ETDReminderText.text = @"1 hour before";
            break;
        case 120 :
            ETDReminderText.text = @"2 hours before";
            break;
        default :
            ETDReminderText.text = @"";
    }
    
    //ETDReminderText.text = @"45 min before";
    ETDReminderText.textColor = [UIColor grayColor];
    [scrollView addSubview:ETDReminderText];
    
    //line separator 3
    UIView* separatorLineView3 = [[UIView alloc]initWithFrame:CGRectMake(leftMargin, ETDReminderText.frame.origin.y+ETDReminderText.frame.size.height+18*multiplier, fullWidth+leftMargin, 1)];
    separatorLineView3.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1];
    [scrollView addSubview:separatorLineView3];
    
    //eventReminder Label
    UILabel *eventReminder = [[UILabel alloc]initWithFrame:CGRectMake(leftMargin, separatorLineView3.frame.origin.y+separatorLineView3.frame.size.height+12*multiplier, 210*multiplier, 18*multiplier)];
    eventReminder.font = [eventReminder.font fontWithSize:17*multiplier];
    eventReminder.text = @"Reminder before the event";
    [scrollView addSubview:eventReminder];
    
    //eventReminder Text Label
    UILabel *eventReminderText = [[UILabel alloc]initWithFrame:CGRectMake(leftMargin+ eventReminder.frame.size.width + 10*multiplier, separatorLineView3.frame.origin.y+separatorLineView3.frame.size.height+12*multiplier, fullWidth- eventReminder.frame.size.width - 10*multiplier, 18*multiplier)];
    eventReminderText.font = [eventReminder.font fontWithSize:17*multiplier];
    eventReminderText.textAlignment = NSTextAlignmentRight;
    eventReminderText.adjustsFontSizeToFitWidth= YES;
    int event = [[selectedEvent valueForKey:@"eventRemind"] intValue];
    switch(event)
    {
        case 0 :
            eventReminderText.text = @"On Time";
            break;
        case 10 :
            eventReminderText.text = @"10 min before";
            break;
        case 30 :
            eventReminderText.text = @"30 min before";
            break;
        case 60 :
            eventReminderText.text = @"1 hour before";
            break;
        default :
            eventReminderText.text = @"";
    }
    //eventReminderText.text = @"30 min before";
    eventReminderText.textColor = [UIColor grayColor];
    [scrollView addSubview:eventReminderText];
    
    //line separator 4
    UIView* separatorLineView4 = [[UIView alloc]initWithFrame:CGRectMake(leftMargin, eventReminderText.frame.origin.y+eventReminderText.frame.size.height+18*multiplier, fullWidth+leftMargin, 1)];
    separatorLineView4.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1];
    [scrollView addSubview:separatorLineView4];
    
    //invitees Label
    UILabel *inviteesLabel = [[UILabel alloc]initWithFrame:CGRectMake(leftMargin, separatorLineView4.frame.origin.y+separatorLineView4.frame.size.height+12*multiplier, 80*multiplier, 18*multiplier)];
    inviteesLabel.font = [inviteesLabel.font fontWithSize:17*multiplier];
    inviteesLabel.text = @"Invitees";
    [scrollView addSubview:inviteesLabel];
    
    /*
     <__NSArrayI 0x176069080>(
     {
     email = "praveen.reddi123@gmail.com";
     name = "Praveen Reddy";
     responseStatus = needsAction;
     },
     {
     email = "dharani0242@gmail.com";
     name = "Dharani Teja";
     responseStatus = accepted;
     },
     {
     email = "saikrishna4477@gmail.com";
     name = "Saikrishna jonnala";
     organizer = 1;
     responseStatus = accepted;
     self = 1;
     },
     {
     email = "srkram575@gmail.com";
     name = "SRK Dudipalli";
     responseStatus = needsAction;
     },
     {
     email = "vinodkumar.tirumani@gmail.com";
     name = "Vinod Kumar";
     responseStatus = accepted;
     }
     )
     
     */
    //Invitess Email Labels
    if (invitees != NULL) {
        
        for (int i=0; i<invitees.count; i++)
        {
            UILabel *emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftMargin+inviteesLabel.frame.size.width + 10*multiplier, separatorLineView4.frame.origin.y+separatorLineView4.frame.size.height+12*multiplier+i*(18*multiplier + 6*multiplier), fullWidth-inviteesLabel.frame.size.width - 10*multiplier, 23*multiplier)];
            if ([[[invitees objectAtIndex:i] objectForKey:@"responseStatus"]  isEqual: @"accepted"])
            {
                emailLabel.textColor = [UIColor greenColor];
            }
            else if ([[[invitees objectAtIndex:i] objectForKey:@"responseStatus"]  isEqual: @"needsAction"])
            {
                emailLabel.textColor = [UIColor blackColor];
            }
            else if ([[[invitees objectAtIndex:i] objectForKey:@"responseStatus"]  isEqual: @"rejected"])
            {
                emailLabel.textColor = [UIColor redColor];
            }
            else if ([[[invitees objectAtIndex:i] objectForKey:@"responseStatus"]  isEqual: @"mayBe"])
            {
                emailLabel.textColor = [UIColor yellowColor];
            }
            emailLabel.text = [[invitees objectAtIndex:i] objectForKey:@"email"];
            if ([emailLabel.text  isEqual: @""])
            {
              //  emailLabel.text = [[invitees objectAtIndex:i] objectForKey:@"name"];
            }
            emailLabel.textAlignment = NSTextAlignmentRight;
            emailLabel.font = [emailLabel.font fontWithSize:17*multiplier];
            [scrollView addSubview:emailLabel];
        }//for end
    }
    else{
        
        //        UILabel *emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftMargin+inviteesLabel.frame.size.width + 10*multiplier, separatorLineView4.frame.origin.y+separatorLineView4.frame.size.height+12*multiplier+i*(18*multiplier + 6*multiplier), fullWidth-inviteesLabel.frame.size.width - 10*multiplier, 23*multiplier)];
        //
        //        [scrollView addSubview:emailLabel];
    }
    
    //line separator 5
    UIView* separatorLineView5 = [[UIView alloc]initWithFrame:CGRectMake(leftMargin, inviteesLabel.frame.origin.y+inviteesLabel.frame.size.height+24*multiplier+(invitees.count-1)*(18*multiplier + 6*multiplier), fullWidth+leftMargin, 1)];
    if (invitees.count == 0) {
        separatorLineView5 = [[UIView alloc]initWithFrame:CGRectMake(leftMargin, inviteesLabel.frame.origin.y+inviteesLabel.frame.size.height+24*multiplier, fullWidth+leftMargin, 1)];
    }
    separatorLineView5.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1];
    [scrollView addSubview:separatorLineView5];
    
    //Notes Label
    UILabel *notes = [[UILabel alloc]initWithFrame:CGRectMake(leftMargin, separatorLineView5.frame.origin.y+separatorLineView5.frame.size.height+12*multiplier, 160*multiplier, 22*multiplier)];
    notes.font = [notes.font fontWithSize:17*multiplier];
    notes.text = @"Meeting agenda";
    [scrollView addSubview:notes];
    
    //Notes Text Label
    UILabel *notesText = [[UILabel alloc]initWithFrame:CGRectMake(leftMargin+ notes.frame.size.width + 65*multiplier, separatorLineView5.frame.origin.y+separatorLineView5.frame.size.height+12*multiplier, fullWidth- notes.frame.size.width - 65*multiplier, 18*multiplier)];
    notesText.font = [notesText.font fontWithSize:17*multiplier];
    notesText.textAlignment = NSTextAlignmentRight;
    notesText.numberOfLines = 0;
    notesText.text = [selectedEvent objectForKey:@"description"];
    notesText.textColor = [UIColor grayColor];
    CGSize constraintSize2 = CGSizeMake(notesText.frame.size.width, MAXFLOAT);
    CGSize labelSize2 = [notesText.text sizeWithFont:notesText.font constrainedToSize:constraintSize2];
    notesText.frame = CGRectMake(notesText.frame.origin.x, notesText.frame.origin.y, notesText.frame.size.width, labelSize2.height);
    [scrollView addSubview:notesText];
    
    //line separator 6
    UIView* separatorLineView6 = [[UIView alloc]initWithFrame:CGRectMake(leftMargin, notesText.frame.origin.y+notesText.frame.size.height+24*multiplier, fullWidth+leftMargin, 1)];
    separatorLineView6.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1];
    [scrollView addSubview:separatorLineView6];
    
    //Edited by Label
    UILabel *editedBy = [[UILabel alloc]initWithFrame:CGRectMake(leftMargin, separatorLineView6.frame.origin.y+separatorLineView6.frame.size.height+12*multiplier, 80*multiplier, 22*multiplier)];
    editedBy.font = [editedBy.font fontWithSize:17*multiplier];
    editedBy.text = @"Edited by";
    [scrollView addSubview:editedBy];
    
    //name Label
    UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(leftMargin, editedBy.frame.origin.y+editedBy.frame.size.height+11*multiplier-5, fullWidth, 20*multiplier)];
    name.font = [name.font fontWithSize:15*multiplier];
    name.text = [selectedEvent objectForKey:@"name"];
    name.textColor = [UIColor lightGrayColor];
    [scrollView addSubview:name];
    
    //Time 3 Label
    UILabel *time3 = [[UILabel alloc]initWithFrame:CGRectMake(leftMargin, name.frame.origin.y+name.frame.size.height+3*multiplier, fullWidth, 12*multiplier)];
    time3.font = [time3.font fontWithSize:12*multiplier];
    time3.text = @"Another One Event";
    time3.text = [selectedEvent objectForKey:@"updated"];
    time3.textColor = [UIColor lightGrayColor];
    [scrollView addSubview:time3];
    
    //Adjusting the size of Scroll View
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, time3.frame.origin.y + time3.frame.size.height + 20);
    if (scrollView.contentSize.height < scrollView.frame.size.height-self.navigationController.navigationBar.frame.size.height) {
        scrollView.frame = CGRectMake(0, 66, self.view.frame.size.width, time3.frame.origin.y + time3.frame.size.height + 40 + self.navigationController.navigationBar.frame.size.height);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)edit
{
    
    //EditEventTableViewController* infoController = [self.storyboard instantiateViewControllerWithIdentifier:@"editevent"];
    //   [self.navigationController pushViewController:infoController animated:YES];
}

-(void)openGoogleMaps
{
    dataclass *obj = [dataclass getInstance];
    NSDictionary *selectedEvent = obj.selectedEvent;
    NSURL *testURL = [NSURL URLWithString:@"comgooglemaps-x-callback://"];
    if ([[UIApplication sharedApplication] canOpenURL:testURL]) {
        NSString *directionsRequest = [NSString stringWithFormat:@"comgooglemaps-x-callback://?daddr=%@,%@&x-success=sourceapp://?resume=true&x-source=Frejun",[selectedEvent objectForKey:@"latitude"],[selectedEvent objectForKey:@"longitude"]];
        NSURL *directionsURL = [NSURL URLWithString:directionsRequest];
        [[UIApplication sharedApplication] openURL:directionsURL];
    } else {
        NSLog(@"Can't use comgooglemaps-x-callback:// on this device.");
    }
}
- (IBAction)back_click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
