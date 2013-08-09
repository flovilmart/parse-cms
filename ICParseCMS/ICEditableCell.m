//
//  ICEditableCell.m
//  icangowithoutcms
//
//  Created by Florent Vilmart on 2013-07-05.
//  Copyright (c) 2013 Soevolved. All rights reserved.
//

#import "ICEditableCell.h"
#import "ICInputAccessoryView.h"
#import "ICObjectKeysCache.h"
#import "PFObjectHelper.h"
@implementation ICEditableCell
@synthesize editingView=_editingView, displayView=_displayView;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setEditing:(BOOL)isEditing animated:(BOOL)animated{
    [super setEditing:isEditing animated:animated];
    _editingView.hidden = !isEditing;
    _displayView.hidden = isEditing;
}

-(void)setEditing:(BOOL)isEditing{
    [super setEditing:isEditing];
    _editingView.hidden = !isEditing;
    _displayView.hidden = isEditing;
}

-(void) layoutSubviews{
    [super layoutSubviews];
    _textField.inputAccessoryView = [ICInputAccessoryView accessoryViewForTextField:_textField];

    id value = self.object[self.editedKey];
    if (self.editedObject[self.editedKey]) {
        value = self.editedObject[self.editedKey];
    }
    _textField.delegate = self;
    
    if ([value isKindOfClass:[PFObject class]]) {
        _textField.text = [PFObjectHelper preferedText:(PFObject *)value];
        _label.text = [PFObjectHelper preferedText:(PFObject *)value];
    }else{
        _textField.text = [value description];
        _label.text = [value description];
    }
    
    
    if ([value isKindOfClass:[NSNumber class]]) {
        _textField.keyboardType = UIKeyboardTypeNumberPad;
    }else{
        _textField.keyboardType = UIKeyboardTypeDefault;
    }
}

-(void) textFieldDidEndEditing:(UITextField *)textField{
    id value = self.object[self.editedKey];
    id finalValue;
    if ([value isKindOfClass:[NSNumber class]]) {
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        finalValue = [f numberFromString:textField.text ];
    }else{
        finalValue = textField.text;
    }
    self.editedObject[self.editedKey] = finalValue;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
   // [self.editedObject setObject:finalValue forKey:self.editedKey];
    [textField resignFirstResponder];
    return YES;
}

@end
