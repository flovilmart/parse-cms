//
//  iOSParseCMS.h
//  iOSParseCMS
//
//  Created by Florent Vilmart on 2013-07-08.
//  Copyright (c) 2013 Soevolved. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ICParseCMS/ICParseCMSViewController.h>
@interface ICParseCMS : NSObject
/*
 Pass an info dictionary to initalize parse

    ParseApplicationId : NSString: Your parse ApplicationID
    ParseClientKey : NSString : Your parse client key
    ParseClassNames : NSArray: Class names you want to display
    
    // Optional
    ParseDefaultACL : NSDictionary: // Setup a default ACL for created objects
        {
            "public" : {"read": @BOOL, @"write": @BOOL},
            // List of R=YES + W=YES roles
            "adminRoles" : [@"admin", @"superadmin"...]
        }
 
    // Optional
    ParsePreferedDisplayKey : NSDictionary // List of keys you want to display in a the list of object for a class:
        {
            "AClass" :"title",
            "BClass" : "name"
        }
    ...
 
    Pass nil will load parse.plist from the main bundle
 
    Parse will initialize with appId, clientId,
    The default ACL will be set
    
 */
+(void) initializeWithInfoDictionary:(NSDictionary *) dictionary;
+(BOOL) handleOpenURL:(NSURL *) url;
// Returns a CMS View Controller
+(UIViewController *) CMSViewController;
+(BOOL) openExternalEditorWithKey:(NSString *) key className:(NSString *) className;
@end