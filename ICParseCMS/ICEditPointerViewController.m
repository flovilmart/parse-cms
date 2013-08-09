//
//  ICChangePointerViewController.m
//  icangowithoutcms
//
//  Created by Florent Vilmart on 2013-07-05.
//  Copyright (c) 2013 Soevolved. All rights reserved.
//

#import "ICEditPointerViewController.h"

@interface ICEditPointerViewController ()

@end

@implementation ICEditPointerViewController

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
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _originalPointer = self.object[self.editedKey];
    if ([_originalPointer isKindOfClass:[NSNull class]]) {
        _originalPointer = nil;
    }
    _newPointer = self.editedObject[self.editedKey];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row >= [self.objects count]) {
        return cell;
    }
    if ([[[self objectAtIndexPath:indexPath] objectId] isEqualToString:[_originalPointer objectId]]) {
        cell.textLabel.textColor = [UIColor grayColor];
    }else{
        cell.textLabel.textColor = [UIColor blackColor];
    }
    if ([[self objectAtIndexPath:indexPath].objectId isEqualToString: _newPointer.objectId]) {
        if (_newPointerIndexPath == nil) {
            _newPointerIndexPath = indexPath;
        }
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }else{
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row >= [self.objects count]) {
        return [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
     _newPointer = [self objectAtIndexPath:indexPath];
    if (_newPointerIndexPath) {
        [self.tableView reloadRowsAtIndexPaths:@[_newPointerIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
    if (_newPointer) {
        self.editedObject[self.editedKey] = _newPointer;
    }
   
    _newPointerIndexPath = indexPath;
    [self.tableView reloadRowsAtIndexPaths:@[_newPointerIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    /*if (!self.selectionMode) {
     
     }else{
     //tableView
     
     }*/
    
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"Index %d", buttonIndex);
    if(buttonIndex == 1 && _newPointer){
        
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
