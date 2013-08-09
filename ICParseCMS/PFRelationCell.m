//
//  PFObjectCell.m
//  icangowithoutcms
//
//  Created by Florent Vilmart on 2013-07-07.
//  Copyright (c) 2013 Soevolved. All rights reserved.
//

#import "PFRelationCell.h"
#import "PFObjectHelper.h"
@implementation PFRelationCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(void) setEditing:(BOOL)isEditing animated:(BOOL)animated{
    [super setEditing:isEditing animated:animated];
    _editingView.hidden = YES;
    _displayView.hidden = NO;
}

-(void)setEditing:(BOOL)isEditing{
    [super setEditing:isEditing];
    _editingView.hidden = YES;
    _displayView.hidden = NO;
}

-(void) layoutSubviews{
    [super layoutSubviews];
    NSString *format;
    if (self.isEditing) {
        format = @"Edit Relation on %@";
    }else{
       format = @"Relation on %@";
    }
    _label.text = [NSString stringWithFormat:format, self.parseClassName];
    /*if (self.editedObject[self.editedKey]) {
        _label.text = [self.editedObject[self.editedKey] preferedText];
    }else{
        if (self.object[self.editedKey] != [NSNull null]) {
            _label.text = [self.object[self.editedKey] preferedText];
        }else{
           
        }
    }*/


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
