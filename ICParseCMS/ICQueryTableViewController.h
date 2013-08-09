//
//  ICQueryTableViewController.h
//  icangowithoutcms
//
//  Created by Florent Vilmart on 2013-07-05.
//  Copyright (c) 2013 Soevolved. All rights reserved.
//

#import <Parse/Parse.h>

@interface ICQueryTableViewController : PFQueryTableViewController<UIAlertViewDelegate>{
    NSString * _preferedKey;
}

@property PFQuery * query;
@end
