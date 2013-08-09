//
//  ICEditRelationViewController.m
//  ICParseCMS
//
//  Created by Florent Vilmart on 2013-07-08.
//  Copyright (c) 2013 Soevolved. All rights reserved.
//

#import "ICEditRelationViewController.h"

@interface NSIndexPath (additions)

@end

@implementation NSIndexPath (additions)

/*-(BOOL) isEqual:(id)object{
    return [[object class] isSubclassOfClass:[NSIndexPath class]] && (self.row == [object row] && self.section == [object section]);
}*/

@end


@interface ICEditRelationViewController ()

@end

@implementation ICEditRelationViewController

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

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
   // _newPointer = self.editedObject[self.editedKey];
}

-(void) objectsDidLoad:(NSError *)error{
    [super objectsDidLoad:error];
    _relation = [self.object relationforKey:self.editedKey];
    [[_relation query] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        _originalRelations = objects;
        _editedRelations = [objects mutableCopy];
        for (PFObject * object in [self objects]) {
            if ([_originalRelations containsObject:object]) {
                [_editedRelationsIndexPath addObject:[NSIndexPath indexPathForRow:[self.objects indexOfObject:object] inSection:0]];
            }
        }
        [self.tableView reloadData];
    }];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row >= [self.objects count]) {
        return cell;
    }
    PFObject *obj = [self objectAtIndexPath:indexPath];
    if ([_originalRelations containsObject:obj]) {
        cell.textLabel.textColor = [UIColor grayColor];
    }else{
        cell.textLabel.textColor = [UIColor blackColor];
    }
    if (!_editedRelationsIndexPath) {
        _editedRelationsIndexPath = [NSMutableArray arrayWithCapacity:0];
    }
    if ([_editedRelationsIndexPath containsObject:indexPath]) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }else{
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    return cell;
}

-(void) setRelationEdited{
    self.editedObject[[NSString stringWithFormat:@"_%@", self.editedKey]] = @YES;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row >= [self.objects count]) {
        return [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
    PFObject * object = [self objectAtIndexPath:indexPath];
    if (!_editedRelationsIndexPath) {
        _editedRelationsIndexPath = [NSMutableArray arrayWithCapacity:0];
    }
    if ([_editedRelationsIndexPath containsObject:indexPath]) {
        [self setRelationEdited];
        [_relation removeObject:object];
        //[_editedRelations removeObject:object];
        [_editedRelationsIndexPath removeObject:indexPath];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }else{
        [self setRelationEdited];
        [_relation addObject:object];
        //[_editedRelations addObject:object];
        [_editedRelationsIndexPath addObject:indexPath];
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    
    
    /*_newPointer = [self objectAtIndexPath:indexPath];
    if (_newPointerIndexPath) {
        [self.tableView reloadRowsAtIndexPaths:@[_newPointerIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
    if (_newPointer) {
        self.editedObject[self.editedKey] = _newPointer;
    }
    
    _newPointerIndexPath = indexPath;
    [self.tableView reloadRowsAtIndexPaths:@[_newPointerIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];*/
    
    /*if (!self.selectionMode) {
     
     }else{
     //tableView
     
     }*/
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
