//
//  ICInputAccessoryView.h
//  ICParseCMS
//
//  Created by Florent Vilmart on 2013-07-08.
//  Copyright (c) 2013 Soevolved. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ICInputAccessoryView : UIToolbar<UITextViewDelegate>{
    UITextField * _originalTextField;
    UITextView * _textView;
}
@property  UITextField * originalTextField;
@property UITextView * textView;
+(UIView *) accessoryViewForTextField:(UITextField *) aTextField;
@end
