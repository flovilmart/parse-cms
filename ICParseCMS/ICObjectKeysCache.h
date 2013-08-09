//
//  ICObjectKeysCache.h
//  icangowithoutcms
//
//  Created by Florent Vilmart on 2013-07-05.
//  Copyright (c) 2013 Soevolved. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
@interface ICObjectKeysCache : NSObject{
    NSMutableDictionary * _cache;
}
+(ICObjectKeysCache *) cache;

-(NSArray *) keysForClassName:(NSString *) className;

-(void) setKeys:(NSArray *) keys forClassName:(NSString *) className;
-(void) setClassName:(NSString *) class forKey:(NSString *) key inClassName:(NSString *) className;
-(NSString *) classNameForKey:(NSString *) key inClassWithName:(NSString *) className;

-(void) registerAll:(NSArray *) objects;
-(void) registerObject:(PFObject *) object;
-(PFObject *) objectWithClassName:(NSString *) className;
-(id) objectForKey:(NSString *) key inClassName:(NSString *) className value:(NSString *) value;
@end
