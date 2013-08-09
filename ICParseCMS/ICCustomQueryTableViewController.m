//
//  ICCustomQueryTableViewController.m
//  ICParseCMS
//
//  Created by Florent Vilmart on 2013-07-08.
//  Copyright (c) 2013 Soevolved. All rights reserved.
//

#import "ICCustomQueryTableViewController.h"

@interface ICCustomQueryTableViewController ()

@end

@implementation ICCustomQueryTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(PFQuery *) queryForTable{
    return self.query;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
