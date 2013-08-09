//
//  ICEditableCell.h
//  icangowithoutcms
//
//  Created by Florent Vilmart on 2013-07-05.
//  Copyright (c) 2013 Soevolved. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ICEditableCell : UITableViewCell<UITextFieldDelegate, UIPopoverControllerDelegate>{
    __weak IBOutlet UILabel *_label;
    __weak IBOutlet UITextField *_textField;
    __weak IBOutlet UIView *_editingView;
    __weak IBOutlet UIView *_displayView;
    id _currentValue;
    id _newValue;

}
@property (weak) UIView * displayView;
@property (weak) UIView * editingView;
@property PFObject * object;
@property NSString * editedKey;
@property NSMutableDictionary * editedObject;
@end
