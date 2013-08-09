//
//  NSBooleanCell.m
//  icangowithoutcms
//
//  Created by Florent Vilmart on 2013-07-06.
//  Copyright (c) 2013 Soevolved. All rights reserved.
//

#import "NSBooleanCell.h"

@implementation NSBooleanCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(void) layoutSubviews{
    [super layoutSubviews];
    id value = self.object[self.editedKey];
    if (self.editedObject[self.editedKey]) {
        value = self.editedObject[self.editedKey];
    }
    [_editSwitch setOn:[value boolValue] animated:YES] ;
    [_displaySwitch setOn:[value boolValue] animated:YES] ;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)valueChanged:(id)sender {
     [self.editedObject setObject:[NSNumber numberWithBool:_editSwitch.isOn] forKey:self.editedKey];
}
@end
