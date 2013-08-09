//
//  PFObject+additions.m
//  icangowithoutcms
//
//  Created by Florent Vilmart on 2013-07-05.
//  Copyright (c) 2013 Soevolved. All rights reserved.
//

#import "PFObjectHelper.h"
#import <Parse/Parse.h>
#import "ICBundle.h"
@implementation PFObjectHelper

+(NSString *) preferedText:(PFObject *) object{
    NSString * preferedKey;
    if ([ICBundle parseInfoDictionary][@"ParsePreferedDisplayKey"]) {
        preferedKey = [ICBundle  parseInfoDictionary][@"ParsePreferedDisplayKey"][object.parseClassName];
    }
    if ([object isDataAvailable]) {
        id property = object[preferedKey];
        if (property && [property isKindOfClass:[NSDictionary class]]) {
            NSString * localized = property[@"en"];
            if (localized) {
                return localized;
            }
        }else if (property) {
            return property;
        }
    }
    
    return [NSString stringWithFormat:@"%@ : %@", object.parseClassName, object.objectId];
}


/*-(NSString *) description{
    return [self preferedText];
}*/
@end
