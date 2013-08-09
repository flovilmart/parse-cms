//
//  iOSParseCMS.m
//  iOSParseCMS
//
//  Created by Florent Vilmart on 2013-07-08.
//  Copyright (c) 2013 Soevolved. All rights reserved.
//

#import "ICParseCMS.h"
#import "ICBundle.h"
#import <Parse/Parse.h>
@implementation ICParseCMS
+(NSString *) encoded:(NSString *) str{
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                 NULL,
                                                                                 (CFStringRef)str,
                                                                                 NULL,
                                                                                 CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                                 kCFStringEncodingUTF8));
}

+(NSString *) decoded:(NSString *) str{
    return [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
+(void) initializeWithInfoDictionary:(NSDictionary *) dictionary{
    [ICBundle setParseInfoDictionary:dictionary];
    NSDictionary * info = [ICBundle parseInfoDictionary];
    if (!info) {
        @throw [NSException exceptionWithName:@"Missing Parse Info Dictionary" reason:@"Pass options here or use parse.plist file" userInfo:nil];
    }
    [Parse setApplicationId:info[@"ParseApplicationId"] clientKey:info[@"ParseClientKey"]];
    
    [Parse offlineMessagesEnabled:YES];
    [Parse errorMessagesEnabled:YES];
    NSDictionary * defaultACLDef = info[@"ParseDefaultACL"];
    if (defaultACLDef) {
        PFACL * acl = [[PFACL alloc] init];
        NSDictionary * public = defaultACLDef[@"public"];
        
        if (public) {
            [acl setPublicReadAccess:[public[@"read"] boolValue]];
            [acl setPublicWriteAccess:[public[@"write"] boolValue]];
        }
        
        for (NSString * roleName in defaultACLDef[@"adminRoles"]) {
            [acl setReadAccess:YES forRoleWithName:roleName];
            [acl setWriteAccess:YES forRoleWithName:roleName];
        }
        NSLog(@"Default ACL %@", [acl valueForKey:@"permissionsById"]);
        [PFACL setDefaultACL:acl withAccessForCurrentUser:NO];
    }
    
}

+(BOOL) handleOpenURL:(NSURL *) url{
    return [[ICParseCMSViewController viewController] handleOpenURL:url];
}

+(ICParseCMSViewController *) CMSViewController{
    return [ICParseCMSViewController viewController];
}

+(BOOL) openExternalEditorWithKey:(NSString *) key className:(NSString *) className{
    NSDictionary * info = [ICBundle parseInfoDictionary];
    NSDictionary * handlers = info[@"ParseCustomHandler"][className];
    if (handlers[key]) {
        NSURL * url = [NSURL URLWithString:[NSString stringWithFormat: @"%@?key=%@&callback=%@", handlers[key], key, [ICParseCMS encoded:[NSString stringWithFormat:@"parse%@://update/", info[@"ParseApplicationId"]]]]];
        [[UIApplication sharedApplication] openURL:url];
        return YES;
    }
    return NO;
}
@end
