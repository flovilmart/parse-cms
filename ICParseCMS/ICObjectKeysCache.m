//
//  ICObjectKeysCache.m
//  icangowithoutcms
//
//  Created by Florent Vilmart on 2013-07-05.
//  Copyright (c) 2013 Soevolved. All rights reserved.
//


#import "ICObjectKeysCache.h"

@implementation ICObjectKeysCache

static ICObjectKeysCache * sharedInstance;
+(ICObjectKeysCache *) cache {
    if (nil != sharedInstance) {
        return sharedInstance;
    }
    
    static dispatch_once_t pred;        // Lock
    dispatch_once(&pred, ^{             // This code is called at most once per app
        sharedInstance = [[ICObjectKeysCache alloc] init];
    });
    
    return sharedInstance;
}

-(id) init{
    self  = [super init];
    if(self){
        _cache = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return self;
}

-(NSArray *) keysForClassName:(NSString *) className{
    if (!_cache[className]) {
        _cache[className] = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _cache[className][@"_allKeys"];
}

-(void) setKeys:(NSArray *) keys forClassName:(NSString *) className{
    if (!_cache[className]) {
        _cache[className] = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    if (!_cache[className][@"_allKeys"]) {
        _cache[className][@"_allKeys"] = [NSMutableArray arrayWithCapacity:0];
    }
    for (NSString * key in keys) {
        if (![_cache[className][@"_allKeys"] containsObject:key]) {
            [_cache[className][@"_allKeys"] addObject:key];
        }
    }
    
}

-(void) setClassName:(NSString*) class forKey:(NSString *) key inClassName:(NSString *) className{
    //NSString * theClass = NSStringFromClass(class);
    _cache[className][key] = class;
}

-(NSString *) classNameForKey:(NSString *) key inClassWithName:(NSString *) className{
    return _cache[className][key];
}

-(void) registerAll:(NSArray *) objects{
    for (PFObject * object in objects) {
        [self registerObject:object];
    }
}
-(void) registerObject:(PFObject *) object{
    [self setKeys:[object allKeys] forClassName:object.parseClassName];
    for (NSString * key in [object allKeys]) {
        Class class = [object[key] class];
        NSString * className = NSStringFromClass(class);
        if ([class isSubclassOfClass:[PFObject class]]) {
            className = [NSString stringWithFormat:@"%@:%@", className,[object[key] parseClassName] ];
        }else if([class isSubclassOfClass:[PFRelation class]]){
            className = [NSString stringWithFormat:@"%@:%@", className,[object[key] targetClass]];
        }
        [self setClassName:className forKey:key inClassName:object.parseClassName];
    }
}


-(PFObject *) objectWithClassName:(NSString *) className{
    if (_cache[className]) {
        PFObject * object = [PFObject objectWithClassName:className];
        for (NSString * key in _cache[className][@"_allKeys"]) {
            NSString * aClassName = [self classNameForKey:key inClassWithName:className];
            id targetObj;
            //NSLog(@"%@ - %@", key, aClassName);
            if ([aClassName rangeOfString:@"PFFile"].location != NSNotFound) {

            }else if ([aClassName rangeOfString:@"PFObject"].location != NSNotFound) {
                //NSArray * elts = [aClassName componentsSeparatedByString:@":"];
                //PFObject * object = [PFObject objectWithClassName:elts[1]];
                //targetObj = [NSNull null];
            }else if ([aClassName rangeOfString:@"PFRelation"].location != NSNotFound){
                NSArray * elts = [aClassName componentsSeparatedByString:@":"];
                PFRelation * relation = [[PFRelation alloc] init];
                relation.targetClass = elts[1];
                //targetObj = [NSNull null];
                targetObj = nil;
            }else{
                Class class =  NSClassFromString(aClassName);
                if ([class isSubclassOfClass:[NSNumber class]]) {
                    if ([aClassName rangeOfString:@"Boolean"].location != NSNotFound) {
                        targetObj = @NO;
                    }else{
                         targetObj = @0;
                    }
                   
                }else if([class isSubclassOfClass:[NSString class]]){
                    targetObj = @"";
                }else{
                    targetObj = [[class alloc] init];
                }
                
            }
            if (targetObj && ![object objectForKey:key]) {
                [object setObject:targetObj forKey:key];
            }
        
        }
        
        NSLog(@"ACL on creaction %@", [object.ACL valueForKey:@"permissionsById"]);
        return object;
    }
    return nil;
}

-(id) objectForKey:(NSString *) key inClassName:(NSString *) className value:(NSString *) value{
    id targetObj;
    if (_cache[className]) {
        NSString * aClassName = [self classNameForKey:key inClassWithName:className];
        if ([aClassName rangeOfString:@"PFFile"].location != NSNotFound) {
            
        }else if ([aClassName rangeOfString:@"PFObject"].location != NSNotFound) {
            NSArray * elts = [aClassName componentsSeparatedByString:@":"];
            PFObject * object = [PFObject objectWithClassName:elts[1]];
            object.objectId = value;
            targetObj = object;
            //targetObj = [NSNull null];
        }else if ([aClassName rangeOfString:@"PFRelation"].location != NSNotFound){
            NSArray * elts = [aClassName componentsSeparatedByString:@":"];
            PFRelation * relation = [[PFRelation alloc] init];
            relation.targetClass = elts[1];
            //targetObj = [NSNull null];
            targetObj = nil;
        }else{
            Class class =  NSClassFromString(aClassName);
            if ([class isSubclassOfClass:[NSNumber class]]) {
                NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
                [f setNumberStyle:NSNumberFormatterDecimalStyle];
                targetObj = [f numberFromString:value];
                if ([aClassName rangeOfString:@"Boolean"].location != NSNotFound) {
                    targetObj  = [NSNumber numberWithBool:[targetObj boolValue]];
                }
                
            }else if([class isSubclassOfClass:[NSString class]]){
                targetObj = value;
            }else{
                targetObj = [[class alloc] init];
            }
            
        }
    }
    return targetObj;
}

@end
