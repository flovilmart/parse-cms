//
//  PFACLCell.m
//  icangowithoutcms
//
//  Created by Florent Vilmart on 2013-07-07.
//  Copyright (c) 2013 Soevolved. All rights reserved.
//

#import "PFACLCell.h"

@implementation PFACLCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
    _displayView.hidden = NO;
    _editingView.hidden = NO;
}

-(void) layoutSubviews{
    while ([[_displayView subviews] count] >0) {
       [ [_displayView subviews][0] removeFromSuperview];
    }
    PFACL * acl = self.object[self.editedKey];
    if (self.editedObject[self.editedKey]) {
        acl = self.editedObject[self.editedKey];
    }
    UIScrollView * scroll = [[UIScrollView alloc] initWithFrame:_displayView.bounds];
    [_displayView addSubview:scroll];
    NSDictionary * aclDef = [acl valueForKey:@"permissionsById"];
    CGFloat x = 5.f;
    for (NSString * aclDefKey in [aclDef allKeys]) {
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(x, 0.f, 0.f, _displayView.frame.size.height)];
        label.text = aclDefKey;
        
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
