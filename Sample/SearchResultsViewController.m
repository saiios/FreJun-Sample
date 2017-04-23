//
//  SearchResultsViewController.m
//  Table Search
//
//  Created by Jay Versluis on 03/11/2015.
//  Copyright © 2015 Pinkstone Pictures LLC. All rights reserved.
//

#import "SearchResultsViewController.h"
#import "mainTableViewCell.h"
//#import "eventInvitaionViewController.h"
//#import "eventDetailsViewController.h"
@interface SearchResultsViewController ()
@property (nonatomic, strong) NSArray *searchResults;
@end

@implementation SearchResultsViewController
-(void)viewWillAppear:(BOOL)animated
{
//    [self.navigationItem setHidesBackButton:YES];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid=@"mainTableViewCell";
    mainTableViewCell *cell = (mainTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell==nil) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"mainTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    dataclass *obj = [dataclass getInstance];
    //title = [json[indexPath.row] objectForKey:@"eventName"];
    NSString *title = [self.searchResults[indexPath.row] objectForKey:@"summary"];
    //NSString *title  = @"jhjkhkjhkjjkhkj";
    if (title.length == 0) {
        title = @"No title";
    }
    cell.title.text = title;
    cell.title.frame = CGRectMake(cell.title.frame.origin.x, 0, [title sizeWithFont:cell.textLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, cell.frame.size.height)].width, cell.frame.size.height);
    
    int priorityLevel = [[[self.searchResults[indexPath.section] objectForKey:@"events"][indexPath.row] objectForKey:@"priority"] intValue];
    //int priorityLevel = 2;
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
    //cell.priorityLabel.text = [events[indexPath.row] objectForKey:@"Priority"];
    cell.priorityLabel.frame = CGRectMake(cell.title.frame.origin.x + cell.title.frame.size.width+20, 0, 35, cell.frame.size.height);
    
    //cell.accessoryType = [[[self.searchResults[indexPath.section] objectForKey:@"events"][indexPath.row] objectForKey:@"status"] boolValue] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    
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
    //cell.rightUtilityButtons = leftUtilityButtons;
    //cell.delegate = self;

    
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return 3;
    return self.searchResults.count;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
   // return 2;
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.0001;
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
//    [sectionHeaderView addSubview:headerLabel];
//    headerLabel.text = [self.searchResults[section] objectForKey:@"date"];
//    NSDate *dateFromString = [[NSDate alloc] init];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//    dateFromString = [dateFormatter dateFromString:[self.searchResults[section] objectForKey:@"date" ]];
//    [dateFormatter setDateFormat:@"EEEE,MMMM d,yyyy"];
//    NSLog(@"%@",[dateFormatter stringFromDate:dateFromString]);
//    headerLabel.text = [dateFormatter stringFromDate:dateFromString];
    
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

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    //self.searchResults[indexPath.row]
    NSLog(@"hi there 2");
    dataclass *obj = [dataclass getInstance];
    obj.selectedEvent = self.searchResults[indexPath.row];
    [self dismissViewControllerAnimated:NO completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"searched" object:self];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    // extract array from observer
    self.searchResults = [(NSArray *)object valueForKey:@"results"];
    [self.tableView reloadData];
}

@end
