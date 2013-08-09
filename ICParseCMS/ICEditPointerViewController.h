//
//  ICChangePointerViewController.h
//  icangowithoutcms
//
//  Created by Florent Vilmart on 2013-07-05.
//  Copyright (c) 2013 Soevolved. All rights reserved.
//

#import "ICQueryTableViewController.h"

@interface ICEditPointerViewController : ICQueryTableViewController{
    PFObject * _newPointer;
    NSIndexPath * _newPointerIndexPath;
    PFObject * _originalPointer;
}

@property PFObject * object;
@property NSMutableDictionary * editedObject;
@property NSString * editedKey;
@end
