//
//  NSDateCell.m
//  icangowithoutcms
//
//  Created by Florent Vilmart on 2013-07-06.
//  Copyright (c) 2013 Soevolved. All rights reserved.
//

#import "NSDateCell.h"

@implementation NSDateCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)showDatePicker:(id)sender{
    
    
    
    _popoverView = [self pickerView];
    UIViewController* popoverContent = [[UIViewController alloc] init];
    FPPopoverController * popoverController = [[FPPopoverController alloc] initWithViewController:popoverContent delegate:self];
    
    popoverContent.view = _popoverView;
    
    [popoverController setContentSize:_popoverView.frame.size];
    [popoverController presentPopoverFromView:_textField];
    _popoverController = popoverController;
    

}

-(UIView *) pickerView{
    UIDatePicker *datePicker=[[UIDatePicker alloc]init];
    datePicker.frame=CGRectMake(0,44,320, 216);
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    //datePicker.
    datePicker.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    [datePicker setMinuteInterval:5];
    [datePicker setTag:10];
    [datePicker setDate:self.object[self.editedKey]];
    if (self.editedObject[self.editedKey]) {
        [datePicker setDate:self.editedObject[self.editedKey]];
    }
    //    [datePicker addTarget:self action:@selector(dateChanged) forControlEvents:UIControlEventValueChanged];
    
    UIView *popoverView = [[UIView alloc] init];
    popoverView.backgroundColor = [UIColor blackColor];
    [popoverView addSubview:datePicker];
    
    
    UIToolbar* toolbar = [[UIToolbar alloc] initWithFrame: CGRectMake(0.0, 0.0, 320.0, 44.0)];
    UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemCancel
                                                                                  target: self
                                                                                  action: @selector(cancel)];
    UIBarButtonItem* space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace
                                                                           target: nil
                                                                           action: nil];
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone
                                                                                target: self
                                                                                action: @selector(done)];
    
    
    UIBarButtonItem * title = [[UIBarButtonItem alloc] initWithTitle:@"GMT Time" style:UIBarButtonItemStylePlain target:nil action:nil];
    NSMutableArray* toolbarItems = [NSMutableArray array];
    [toolbarItems addObject:cancelButton];
    [toolbarItems addObject:space];
    [toolbarItems addObject:title];
    [toolbarItems addObject:space];
    [toolbarItems addObject:doneButton];
    toolbar.items = toolbarItems;
    
    [popoverView addSubview:toolbar];
    CGRect popoverFrame = popoverView.frame;
    popoverFrame.size.height = toolbar.frame.size.height+datePicker.frame.size.height;
    popoverView.frame = popoverFrame;
    _datePicker = datePicker;
    _popoverView = popoverView;
    return popoverView;
}

-(void) willPresentActionSheet:(UIActionSheet *)actionSheet{
    [actionSheet addSubview:_popoverView];
    //actionSheet.bounds = pickView.bounds;
    //pickView.y = -pickView.height;
}

-(void) cancel{
    [_popoverController dismissPopoverAnimated:YES];
    [self setEditing:self.isEditing animated:YES];
}

-(void) done{
    self.editedObject[self.editedKey] = _datePicker.date;
    [_popoverController dismissPopoverAnimated:YES];
    [self setEditing:self.isEditing];
}


-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField{
    if ([self.object[self.editedKey] isKindOfClass:[NSDate class]]) {
        [self showDatePicker:nil];
        return NO;
    }
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

@end
