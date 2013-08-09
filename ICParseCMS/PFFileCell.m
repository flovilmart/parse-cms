//
//  PFFileCell.m
//  ICParseCMS
//
//  Created by Florent Vilmart on 2013-07-09.
//  Copyright (c) 2013 Soevolved. All rights reserved.
//

#import "PFFileCell.h"

@implementation PFFileCell

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
    _displayView.hidden = NO;
    _editingView.hidden = YES;
    
    PFFile * file = self.object[self.editedKey];

    NSString * format = @"PFFile : %@";
    if(self.editing){
        if (self.editedObject[self.editedKey]) {
            file = self.editedObject[self.editedKey];
            format = @"File changed";
        }else{
            format = @"Upload new file";
        }
    }
    _label.text = [NSString stringWithFormat:format, file.url];
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
