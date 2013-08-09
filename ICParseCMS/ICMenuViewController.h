//
//  ICMenuViewController.h
//  icangowithoutcms
//
//  Created by Florent Vilmart on 2013-07-05.
//  Copyright (c) 2013 Soevolved. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ICParseCMSViewController;
@interface ICMenuViewController : UITableViewController{

    __weak IBOutlet ICParseCMSViewController *_mainViewController;
}

@property NSArray * classNames;
@end
