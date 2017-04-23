//
//  ViewController.m
//  Sample
//
//  Created by INDOBYTES on 18/04/17.
//  Copyright © 2017 indo. All rights reserved.
//

#import "ViewController.h"
#import "mainViewController.h"

@interface ViewController ()

@end

@implementation ViewController
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationItem setHidesBackButton:YES];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //mainViewController* main_go = [self.storyboard instantiateViewControllerWithIdentifier:@"mainViewController"];
    //[self.navigationController pushViewController:main_go animated:NO];
    
    mainViewController *define = [[mainViewController alloc]initWithNibName:@"mainViewController" bundle:nil];
    [self.navigationController pushViewController:define animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
