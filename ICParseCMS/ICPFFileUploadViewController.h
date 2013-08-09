//
//  ICPFFileUploadViewController.h
//  ICParseCMS
//
//  Created by Florent Vilmart on 2013-07-09.
//  Copyright (c) 2013 Soevolved. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface ICPFFileUploadViewController : UIImagePickerController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property UIPopoverController * popOverController;
@property PFObject * object;
@property NSMutableDictionary * editedObject;
@property NSString * editedKey;
@end
