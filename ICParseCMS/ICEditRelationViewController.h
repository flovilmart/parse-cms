//
//  ICEditRelationViewController.h
//  ICParseCMS
//
//  Created by Florent Vilmart on 2013-07-08.
//  Copyright (c) 2013 Soevolved. All rights reserved.
//

#import "ICEditPointerViewController.h"

@interface ICEditRelationViewController : ICQueryTableViewController{
    PFRelation * _relation;
    NSArray * _originalRelations;
    NSMutableArray * _editedRelations;
    NSMutableArray * _editedRelationsIndexPath;
}
@property PFObject * object;
@property NSMutableDictionary * editedObject;
@property NSString * editedKey;
@end
