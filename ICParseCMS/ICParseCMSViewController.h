//
//  ICViewController.h
//  icangowithoutcms
//
//  Created by Florent Vilmart on 2013-07-05.
//  Copyright (c) 2013 Soevolved. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ICParseCMSViewController : UIViewController{

}

-(BOOL) handleOpenURL:(NSURL *) url;
+(ICParseCMSViewController *) viewController;
-(UIViewController *) currentViewController;
-(void) displayQueryControllerForClassName:(NSString *) className;
@end
