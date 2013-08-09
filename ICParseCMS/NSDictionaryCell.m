//
//  NSDictionaryCell.m
//  icangowithoutcms
//
//  Created by Florent Vilmart on 2013-07-05.
//  Copyright (c) 2013 Soevolved. All rights reserved.
//

#import "NSDictionaryCell.h"
#import "ICInputAccessoryView.h"
@implementation NSDictionaryCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    id value;
    if (self.dictionaryKey) {
        value = self.object[self.editedKey][self.dictionaryKey];
        if (self.editedObject[self.editedKey] && self.editedObject[self.editedKey][self.dictionaryKey]) {
            value = self.editedObject[self.editedKey][self.dictionaryKey];
        }
    }else{
        self.dictionaryKey = @"";
        value = @"";
    }
    
    _valueLabel.text = [value description];
    _valueTextField.text = [value description];
    _keyLabel.text = self.dictionaryKey;
    _keyTextField.text = self.dictionaryKey;
    _previousDictionaryKey = self.dictionaryKey;
    
     _valueTextField.inputAccessoryView = [ICInputAccessoryView accessoryViewForTextField:_valueTextField];
}

-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    return YES;
}

-(void) textFieldDidEndEditing:(UITextField *)textField{
    if (!self.editedObject[self.editedKey]) {
        if (self.object[self.editedKey]) {
            self.editedObject[self.editedKey] = [self.object[self.editedKey] mutableCopy];
        }else{
            self.editedObject[self.editedKey] = [NSMutableDictionary dictionary];
        }
    }
    if (textField == _keyTextField) {
        if (![_keyTextField.text isEqualToString:_previousDictionaryKey]) {
            [self.editedObject[self.editedKey] removeObjectForKey:_previousDictionaryKey];
        }
        _previousDictionaryKey = _keyTextField.text;
        self.dictionaryKey = _keyTextField.text;
    }
    id finalValue = _valueTextField.text;
    
    if (finalValue) {
        if ([self.dictionaryKey isEqualToString:@""]) {
            [self.editedObject[self.editedKey] removeObjectForKey:self.dictionaryKey];
        }else{
            self.editedObject[self.editedKey][self.dictionaryKey] = finalValue;
        }
        if(self.editedObject[self.editedKey][@""]){
            [self.editedObject[self.editedKey] removeObjectForKey:@""];
        }
    }
    
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    //[self.editedObject[self.dictionaryKey] setObject:finalValue forKey:self.editedKey];
    [textField resignFirstResponder];
    return YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)deleteTouched:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kDeleteDictionaryKey" object:nil userInfo:@{@"dictionaryKey": self.dictionaryKey, @"editedKey": self.editedKey}];
}
@end
