//
//  NSBooleanCell.h
//  icangowithoutcms
//
//  Created by Florent Vilmart on 2013-07-06.
//  Copyright (c) 2013 Soevolved. All rights reserved.
//

#import "ICEditableCell.h"

@interface NSBooleanCell : ICEditableCell{

    __weak IBOutlet UISwitch *_editSwitch;
    __weak IBOutlet UISwitch *_displaySwitch;
}
- (IBAction)valueChanged:(id)sender;

@end
