//
//  NSDictionaryCell.h
//  icangowithoutcms
//
//  Created by Florent Vilmart on 2013-07-05.
//  Copyright (c) 2013 Soevolved. All rights reserved.
//

#import "ICEditableCell.h"

@interface NSDictionaryCell : ICEditableCell{

    __weak IBOutlet UILabel *_keyLabel;
    
    __weak IBOutlet UILabel *_valueLabel;
    __weak IBOutlet UITextField *_keyTextField;
    __weak IBOutlet UITextField *_valueTextField;
    
    NSString *_previousDictionaryKey;
}
- (IBAction)deleteTouched:(id)sender;

@property NSString * dictionaryKey;
@end
