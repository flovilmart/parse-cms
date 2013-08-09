//
//  ICBundle.h
//  ICParseCMS
//
//  Created by Florent Vilmart on 2013-07-09.
//  Copyright (c) 2013 Soevolved. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICBundle : NSBundle

+(void) setParseInfoDictionary:(NSDictionary *) dictionary;
+(NSDictionary *) parseInfoDictionary;
+(NSBundle *) frameworkBundle;
@end
