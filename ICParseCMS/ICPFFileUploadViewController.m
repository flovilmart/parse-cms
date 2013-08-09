//
//  ICPFFileUploadViewController.m
//  ICParseCMS
//
//  Created by Florent Vilmart on 2013-07-09.
//  Copyright (c) 2013 Soevolved. All rights reserved.
//

#import "ICPFFileUploadViewController.h"
#import "ICParseCMSViewController.h"
@interface ICPFFileUploadViewController ()

@end

@implementation ICPFFileUploadViewController

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

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSLog(@"Media info %@", info);
    UIImage * original =info[UIImagePickerControllerOriginalImage];
    //NSURL * mediaURL = info[UIImagePickerControllerReferenceURL];
    NSData * data = UIImagePNGRepresentation(original);
    //NSData * data = [NSData da]
    PFFile * file = [PFFile fileWithData:data];
    self.editedObject[self.editedKey] = file;
    
   [self dismiss];
}

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismiss];
}

-(void) dismiss{
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad){
        [self.popOverController dismissPopoverAnimated:YES];
    }else{
        [[ICParseCMSViewController viewController] dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
