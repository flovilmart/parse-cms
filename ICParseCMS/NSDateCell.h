//
//  NSDateCell.h
//  icangowithoutcms
//
//  Created by Florent Vilmart on 2013-07-06.
//  Copyright (c) 2013 Soevolved. All rights reserved.
//

#import "ICEditableCell.h"
#import "FPPopoverController.h"
@interface NSDateCell : ICEditableCell<FPPopoverControllerDelegate>{
    FPPopoverController * _popoverController;
    UIDatePicker * _datePicker;
    UIView * _popoverView;
}

@end
