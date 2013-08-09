//
//  ICObjectTableViewController.h
//  icangowithoutcms
//
//  Created by Florent Vilmart on 2013-07-05.
//  Copyright (c) 2013 Soevolved. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ICObjectTableViewController : UITableViewController< UIGestureRecognizerDelegate, UIAlertViewDelegate, PFLogInViewControllerDelegate, UIPopoverControllerDelegate>{
    NSArray * _sortedKeys;
    NSIndexPath * _currentIndexPath;
    CGRect _originalPanFrame;
    UIPanGestureRecognizer * _panGestureRecognizer;
    NSMutableDictionary * _editedObject;
    UIPopoverController * _popOverController;
    UIButton * _deleteButton;
    NSDictionary * _customHandlers;
}
@property PFObject *object;

-(void) updateKey:(NSString *) key value:(id) value;
@end
