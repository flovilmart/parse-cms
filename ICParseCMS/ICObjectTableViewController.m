//
//  ICObjectTableViewController.m
//  icangowithoutcms
//
//  Created by Florent Vilmart on 2013-07-05.
//  Copyright (c) 2013 Soevolved. All rights reserved.
//
#import "ICParseCMS.h"
#import "ICObjectTableViewController.h"
#import "ICParseCMSViewController.h"
#import "ICQueryTableViewController.h"
#import "ICEditableCell.h"
#import "ICCustomQueryTableViewController.h"
#import "ICEditPointerViewController.h"
#import "ICEditRelationViewController.h"
#import "ICPFFileUploadViewController.h"
#import "NSDictionaryCell.h"
#import "PFObjectHelper.h"
#import "ICObjectKeysCache.h"
#import "NSBooleanCell.h"
#import "NSDateCell.h"
#import "ICObjectKeysCache.h"
#import "PFObjectCell.h"
#import "PFRelationCell.h"
#import "PFFileCell.h"
#import <Parse/Parse.h>
#import "ICBundle.h"


@interface ICObjectTableViewController ()

@end

@implementation ICObjectTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        NSArray * nibs = @[@"ICEditableCell", @"NSDictionaryCell", @"NSBooleanCell", @"NSDateCell", @"PFObjectCell",@"PFRelationCell", @"PFFileCell"];
        for (NSString * key in nibs) {
            UINib * nib = [UINib nibWithNibName:key bundle:[ICBundle frameworkBundle]];
            [self.tableView registerNib:nib forCellReuseIdentifier:key];
        }
        
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    _editedObject = [NSMutableDictionary dictionaryWithCapacity:0];
    self.tableView.allowsSelectionDuringEditing = YES;
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIView * deleteView = [[UIView alloc] initWithFrame:CGRectMake(0.f, -50.f, self.view.frame.size.width, 50.f)];
    deleteView.backgroundColor = [UIColor whiteColor];
    UIButton * deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f, 100.f, 50.f)];
    [deleteButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [deleteButton setTitle:@"Delete" forState:UIControlStateNormal];
    deleteButton.center = CGPointMake(deleteView.frame.size.width/2, deleteView.frame.size.height/2);
    [deleteView addSubview:deleteButton];
    [deleteButton addTarget:self action:@selector(deleteObject:) forControlEvents:UIControlEventTouchUpInside];
    //[self.tableView addSubview:deleteView];
    _deleteButton = deleteButton;
    _deleteButton.hidden = !self.editing;
    self.tableView.tableHeaderView = deleteView;
    
    //self.tableView.contentInset = UIEdgeInsetsMake(50.f, 0.f, 0.f, 0.f);

    /*UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
    pan.delegate = self;
    _panGestureRecognizer = pan;
    [self.tableView addGestureRecognizer:pan];*/
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    _sortedKeys = [[ICObjectKeysCache cache] keysForClassName:self.object.parseClassName];
    if (!_sortedKeys) {
        _sortedKeys = [self.object allKeys];
    }
    
    _sortedKeys = [_sortedKeys sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES]]];
    if (![self.object isDataAvailable]) {
        [self.object fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            if([_sortedKeys count] == 0){
                _sortedKeys = [self.object allKeys];
            }
            _sortedKeys = [_sortedKeys sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES]]];
            self.object = object;
            [self.tableView reloadData];

            [self refreshTitle];
        }];
    }else{
        [self.tableView reloadData];
        [self refreshTitle];
    }
    

    if (self.tableView.contentOffset.y == 0.f) {
        self.tableView.contentOffset = CGPointMake(0.f, 50.f);
    }
    
    
       
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteDictKey:) name:@"kDeleteDictionaryKey" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(previewURLHandler:) name:@"kPreviewURL" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"kDeleteDictionaryKey" object:nil];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:@"kPreviewURL" object:nil];
}

-(void) refreshTitle{
    if (self.object.objectId) {
        self.title = [NSString stringWithFormat:@"%@ - %@",self.object.parseClassName, self.object.objectId];
    }else{
        self.title = [NSString stringWithFormat:@"New %@", self.object.parseClassName];
    }
}

-(void) deleteDictKey:(NSNotification *) notification{
    NSString * dictKey = notification.userInfo[@"dictionaryKey"];
    NSString * editedKey = notification.userInfo[@"editedKey"];
    if (!_editedObject[editedKey]) {
        _editedObject[editedKey] = [self.object[editedKey] mutableCopy];
    }
    [_editedObject[editedKey] removeObjectForKey:dictKey];
    [self.tableView reloadData];
}

-(void) previewURLHandler:(NSNotification *) notification{
    double delayInSeconds = 0.f;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        NSURL * url = notification.userInfo[@"URL"];
        UIWebView * webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        UIViewController *vc = [[UIViewController alloc] init];
        vc.view = webView;
        [webView loadRequest:[NSURLRequest requestWithURL:url]];
        [self.navigationController pushViewController:vc animated:YES];
    });
    
}

-(void) deleteObject:(id) sender{
    if (self.editing) {
        [self.object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            NSInteger index = [[self.navigationController viewControllers] indexOfObject:self];
            if (index>0) {
                UIViewController * previousController = [self.navigationController viewControllers][index-1];
                if ([previousController respondsToSelector:@selector(loadObjects)]) {
                    [previousController performSelector:@selector(loadObjects)];
                }
            }
            
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }else{
        
    }

}

-(void) keyboardWillShow:(NSNotification *) notification{
    self.tableView.scrollEnabled  = NO;
}

-(void) keyboardWillHide:(NSNotification *) notification{
    self.tableView.scrollEnabled = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_sortedKeys count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key = _sortedKeys[section];
    id prop = self.object[key];
    if ([prop isKindOfClass:[NSDictionary class]]) {
        int count = [[prop allKeys] count];
        if(_editedObject[key]){
            count = [[_editedObject[key] allKeys] count];
        }
       
        return  (count==0?1:count);
    }
    return 1;
}

-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return _sortedKeys[section];
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    __block ICEditableCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"ICEditableCell"];
    NSString * currentKey = _sortedKeys[indexPath.section];
    id prop = self.object[currentKey];
    
    NSString * propClassName = [self classNameOfObjectAtIndexPath:indexPath];
    
    Class propClass = NSClassFromString(propClassName);
    
    BOOL showAccessoryView = NO;
    
    if ([propClass isSubclassOfClass:[NSDictionary class]]) {

        NSDictionaryCell *aCell = [tableView dequeueReusableCellWithIdentifier:@"NSDictionaryCell"];
        NSDictionary * usedDict = prop;
        if (_editedObject[currentKey]) {
            usedDict = _editedObject[currentKey];
        }
        aCell.dictionaryKey = @"";
        if ([[usedDict allKeys] count]>indexPath.row) {
             aCell.dictionaryKey = [usedDict allKeys][indexPath.row];
        }

        cell = aCell;
    }
    if ([propClass isSubclassOfClass:[NSDate class]]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"NSDateCell"];
    }

    if ([propClass isSubclassOfClass:[NSString class]]) {
        NSURL * url = [NSURL URLWithString:prop];
        if (url) {
            showAccessoryView = YES;
        }
    }
    
    if ([propClassName rangeOfString:@"Boolean"].location != NSNotFound) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"NSBooleanCell"];
    }
    
    if ([self aClassName:propClassName isClass:[PFObject class]]) {
        PFObjectCell * aCell = [tableView dequeueReusableCellWithIdentifier:@"PFObjectCell"];
        aCell.parseClassName = [propClassName componentsSeparatedByString:@":"][1];
        if(!prop || [prop isKindOfClass:[NSNull class]]){
            
            showAccessoryView = NO;
        }else {
            showAccessoryView = YES;
        }
        cell = aCell;
        
        [cell setEditing:NO];
    }
    
    if ([self aClassName:propClassName isClass:[PFFile class]]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"PFFileCell"];
        [cell setEditing:NO];
    }
    
        
    if ([self aClassName:propClassName isClass:[PFACL class]]) {
        
    }
            
    if ([self aClassName:propClassName isClass:[PFRelation class]]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"PFRelationCell"];
        NSString * className = [propClassName componentsSeparatedByString:@":"][1];
        [cell setValue:className forKey:@"parseClassName"];
        [cell setEditing:NO];
        showAccessoryView = YES;
    }

    if ([self hasCustomHandler:currentKey]) {
        showAccessoryView = YES;
        [cell setEditing:NO];
    }
    cell.object = self.object;
    cell.editedKey = currentKey;
    cell.editedObject = _editedObject;
    if (showAccessoryView) {
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }else{
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    /*if ([prop isKindOfClass:[PFObject class]]) {
        
        
    }*/

    // Configure the cell...
    
    return cell;
}

-(BOOL) hasCustomHandler:(NSString *) key{
    return ([ICBundle parseInfoDictionary][@"ParseCustomHandler"][self.object.parseClassName] ? YES : NO);
}

-(void) updateKey:(NSString *)key value:(id)value{
    NSLog(@"update Key %@ %@", key , value);
    _editedObject[key] = value;
    [self.tableView reloadData];
    //NSUInteger index= [_sortedKeys indexOfObject:key];
    //[self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(NSString *) classNameOfObjectAtIndexPath:(NSIndexPath *) indexPath{
    NSString * currentKey = _sortedKeys[indexPath.section];
    return [[ICObjectKeysCache cache] classNameForKey:currentKey inClassWithName:self.object.parseClassName];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated{
    if (editing && ![PFUser currentUser]) {
        PFLogInViewController * login = [[PFLogInViewController alloc] init];
        login.fields = PFLogInFieldsUsernameAndPassword | PFLogInFieldsLogInButton | PFLogInFieldsPasswordForgotten | PFLogInFieldsDismissButton;
        login.delegate = self;
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            _popOverController = [[UIPopoverController alloc] initWithContentViewController:login];
            _popOverController.delegate = self;
            [_popOverController presentPopoverFromBarButtonItem:self.editButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }else{
            [self.navigationController pushViewController:login animated:YES];
        }
        
        return;
    }
    
    [super setEditing:editing animated:animated];
    _deleteButton.hidden = !editing;
    self.navigationItem.backBarButtonItem.enabled = !editing;
    if (editing == YES) {
        
        //[self.tableView reloadData];
    }else{
        [self.view endEditing:YES];
        if([[_editedObject allKeys] count] >0){
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Save?" message:@"Do you want to save the changes?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save!", nil];
            [alert show];
        }else{
            [self.tableView reloadData];
        }
    }
}

-(void) logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController{
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        [_popOverController dismissPopoverAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
        /*[self.navigationController dismissViewControllerAnimated:YES completion:^{
            
        }];*/
        //[self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void) logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error{
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        [_popOverController dismissPopoverAnimated:YES];
    }else{
         //[self.navigationController popViewControllerAnimated:YES];
        //[self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void) logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user{
    [self setEditing:YES animated:YES];
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        [_popOverController dismissPopoverAnimated:YES];
    }else{
         [self.navigationController popViewControllerAnimated:YES];
        //[self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        for (NSString * key in [_editedObject allKeys]) {
            if ([key rangeOfString:@"_"].location != 0) {
                id obj = _editedObject[key];
                self.object[key] = obj;
            }
        }
        NSLog(@"ACL %@", [self.object.ACL valueForKey:@"permissionsById"]);
        [self.object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            NSLog(@"ACL AFTER %@", [self.object.ACL valueForKey:@"permissionsById"]);
            _editedObject = [NSMutableDictionary dictionaryWithCapacity:0];
            [self refreshTitle];
            [self.tableView reloadData];
        }];
    }else{
        _editedObject = [NSMutableDictionary dictionaryWithCapacity:0];
        [self.tableView reloadData];
    }
    
}

-(BOOL) tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * className = [self classNameOfObjectAtIndexPath:indexPath];
    if([NSClassFromString(className) isSubclassOfClass:[NSDictionary class]]){
        return UITableViewCellEditingStyleInsert;
    }
    return UITableViewCellEditingStyleNone;
}

-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * currentKey = _sortedKeys[indexPath.section];
    NSDictionary * originalDict = [self.object objectForKey:currentKey];
    NSDictionary * editedDict = [_editedObject objectForKey:currentKey];
    NSMutableDictionary * usedDict = [originalDict mutableCopy];
    if (editedDict && [[editedDict allKeys] count]>= [[originalDict allKeys] count]) {
        usedDict = [editedDict mutableCopy];
    }
    if (![[usedDict allKeys] containsObject:@""]) {
        [usedDict setObject:@"" forKey:@""];
        [_editedObject setObject:usedDict forKey:currentKey];
        
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString * key = _sortedKeys[indexPath.section];
    id prop = self.object[key];
    id editedProp = _editedObject[key];
    if (editedProp) {
        prop = editedProp;
    }
    NSString * realClassName = [[ICObjectKeysCache cache] classNameForKey:key inClassWithName:self.object.parseClassName];
    if (self.editing) {
        NSString * className;
        if ([ICParseCMS openExternalEditorWithKey:key className:self.object.parseClassName]) {
            return;
        }
        if ([prop isKindOfClass:[PFRelation class]]) {
            className = [prop targetClass];
            [self editRelationForKey:key ofClassName:className];
            return;
        }
        if ([self aClassName:realClassName isClass:[PFObject class]]) {
            className = [(PFObjectCell *)[tableView cellForRowAtIndexPath:indexPath] parseClassName];
            if (className) {
                [self editPointerForKey:key ofClassName:className];
            }
        }
        if ([self aClassName:realClassName isClass:[PFFile class]]) {
            [self uploadNewFileForKey:key fromIndexPath:indexPath];
        }

        
    }else{
        if ([prop isKindOfClass:[PFObject class]]){
            if([prop isDataAvailable]){
                ICObjectTableViewController * tvc = [[ICObjectTableViewController alloc] initWithStyle:UITableViewStylePlain];
                tvc.object = prop;
                [self.navigationController pushViewController:tvc animated:YES];
            }else{
                [prop fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                    [[ICObjectKeysCache cache] registerObject:object];
                    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                }];
            }
        }else if([prop isKindOfClass:[PFRelation class]]){
            ICCustomQueryTableViewController * tvc = [[ICCustomQueryTableViewController alloc] initWithStyle:self.tableView.style];
            tvc.query = [(PFRelation *)prop query];
            [self.navigationController pushViewController:tvc animated:YES];
        }else if([prop isKindOfClass:[NSString class]]){
            NSURL * url = [NSURL URLWithString:prop];
            [self previewURL:url];
        }else if([prop isKindOfClass:[NSDictionary class]]){
            NSString * value = prop[[prop allKeys][indexPath.row]];
            [self previewURL:[NSURL URLWithString:value]];
        }
        
        if ([prop isKindOfClass:[PFFile class]]) {
            PFFile * file = (PFFile*)prop;
            //NSURL * url = [NSURL URLWithString:file.url];
            [self previewURL: [NSURL URLWithString:file.url]];
        }
    }
    
    
}

-(void) editPointerForKey:(NSString *) key ofClassName:(NSString *) className{
    ICEditPointerViewController * tvc = [[ICEditPointerViewController alloc] initWithStyle:UITableViewStylePlain className:className];
    tvc.object = self.object;
    tvc.editedObject = _editedObject;
    tvc.editedKey = key;
    [self.navigationController pushViewController:tvc animated:YES];
}

-(void) editRelationForKey:(NSString *) key ofClassName:(NSString *) className{
    ICEditRelationViewController * evc = [[ICEditRelationViewController alloc] initWithStyle:UITableViewStylePlain className:className];
    evc.object = self.object;
    evc.editedObject = _editedObject;
    evc.editedKey = key;
    [self.navigationController pushViewController:evc animated:YES];
}

-(void) uploadNewFileForKey:(NSString *) key fromIndexPath:(NSIndexPath *) indexPath{
    ICPFFileUploadViewController * uploadVC = [[ICPFFileUploadViewController alloc] init];
    uploadVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    uploadVC.delegate = uploadVC;
    uploadVC.editedObject = _editedObject;
    uploadVC.editedKey = key;
    uploadVC.object = self.object;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        
        UIPopoverController * popover = [[UIPopoverController alloc] initWithContentViewController:uploadVC];
        uploadVC.popOverController = popover;
        [popover presentPopoverFromRect:[self.tableView rectForRowAtIndexPath:indexPath] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }else{
        [[ICParseCMSViewController viewController] presentViewController:uploadVC animated:YES completion:^{
            
        }];
        //[[ICParseCMSViewController viewController] dismissViewControllerAnimated:YES completion:nil];
    }
}

-(BOOL) aClassName:(NSString *) aClassName isClass:(Class) aClass{
    return [aClassName rangeOfString:NSStringFromClass(aClass)].location != NSNotFound;
}

-(void) previewURL:(NSURL *) url{
    
    if (!url) {
        return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kPreviewURL" object:nil userInfo:@{@"URL": url}];
}


@end
