//
//  ICQueryTableViewController.m
//  icangowithoutcms
//
//  Created by Florent Vilmart on 2013-07-05.
//  Copyright (c) 2013 Soevolved. All rights reserved.
//

#import "ICQueryTableViewController.h"
#import "ICObjectTableViewController.h"
#import "ICObjectKeysCache.h"
#import "PFObjectHelper.h"
#import <Parse/Parse.h>
#import "ICBundle.h"
@interface ICQueryTableViewController ()

@end

@implementation ICQueryTableViewController

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
    self.title = self.parseClassName;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(createObject:)];
    self.queryForTable.limit = 1000;
	// Do any additional setup after loading the view.
}

- (void)objectsWillLoad{
    [super objectsWillLoad];
    self.title = self.parseClassName;
    if ([ICBundle parseInfoDictionary][@"ParsePreferedDisplayKey"]) {
        _preferedKey = [ICBundle parseInfoDictionary][@"ParsePreferedDisplayKey"][self.parseClassName];
    }
    
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void) objectsDidLoad:(NSError *)error{
    [super objectsDidLoad:error];
    [[ICObjectKeysCache cache] registerAll:self.objects];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell =  [super tableView:tableView cellForRowAtIndexPath:indexPath];
    /*if (_preferedKey) {
        id property = [self objectAtIndexPath:indexPath][_preferedKey];
        if (property && [property isKindOfClass:[NSDictionary class]]) {
            NSString * localized = property[@"en"];
            if (localized) {
                cell.textLabel.text = localized;
            }
        }
    }*/
    if(indexPath.row < [self.objects count]){
        cell.textLabel.text = [PFObjectHelper preferedText:[self objectAtIndexPath:indexPath]];
    }
    

    
    return cell;
}

-(void) createObject:(id) sender{
    PFObject * object = [[ICObjectKeysCache cache] objectWithClassName:self.parseClassName];
    [self displayObject:object];
    
    
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row < [self.objects count]){
         [self displayObject:[self objectAtIndexPath:indexPath]];
    }else{
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
   
    /*if (!self.selectionMode) {
        
    }else{
        //tableView
        
    }*/

}

-(void) displayObject:(PFObject *) object{
    ICObjectTableViewController * tvc = [[ICObjectTableViewController alloc] initWithStyle:UITableViewStylePlain];
    tvc.object = object;
    [self.navigationController pushViewController:tvc animated:YES];
}

@end
