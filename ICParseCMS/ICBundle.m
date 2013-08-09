//
//  ICBundle.m
//  ICParseCMS
//
//  Created by Florent Vilmart on 2013-07-09.
//  Copyright (c) 2013 Soevolved. All rights reserved.
//

#import "ICBundle.h"

@implementation ICBundle
static NSDictionary * _parseInfoDictionary = nil;


+(void) setParseInfoDictionary:(NSDictionary *) dictionary{
    if (dictionary) {
        _parseInfoDictionary = dictionary;
    }
}

+(NSDictionary *) parseInfoDictionary{
    //static NSDictionary * parseInfoDict = nil;
    static dispatch_once_t predicate;
    if (!_parseInfoDictionary) {
        dispatch_once(&predicate, ^{
            NSString *filePath = [[NSBundle mainBundle] pathForResource:@"parse" ofType:@"plist"];
            _parseInfoDictionary = [[NSDictionary alloc] initWithContentsOfFile:filePath];
        });
    }
    
    return _parseInfoDictionary;
}

+ (NSBundle *)frameworkBundle {
    static NSBundle* frameworkBundle = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        NSString* mainBundlePath = [[NSBundle mainBundle] resourcePath];
        NSString* frameworkBundlePath = [mainBundlePath stringByAppendingPathComponent:@"ICParseCMSResources.bundle"];
        frameworkBundle = [NSBundle bundleWithPath:frameworkBundlePath];
    });
    return frameworkBundle;
}
@end
