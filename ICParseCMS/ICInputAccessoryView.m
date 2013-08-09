//
//  ICInputAccessoryView.m
//  ICParseCMS
//
//  Created by Florent Vilmart on 2013-07-08.
//  Copyright (c) 2013 Soevolved. All rights reserved.
//

#import "ICInputAccessoryView.h"
#import <QuartzCore/QuartzCore.h>
@implementation ICInputAccessoryView
@synthesize originalTextField = _originalTextField, textView=_textView;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UITextView * textView = [[UITextView alloc] initWithFrame:CGRectMake(8.f, 12.f, 242.f, 30.f)];
        textView.autoresizingMask = UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight;
        textView.delegate = self;
        //[textView setContentInset:UIEdgeInsetsMake(2.f, 2.f, 2.f, 2.f)];
        [textView.layer setBackgroundColor: [[UIColor whiteColor] CGColor]];
        [textView.layer setBorderColor: [[UIColor grayColor] CGColor]];
        [textView.layer setBorderWidth: 1.0];
        [textView.layer setCornerRadius:4.0f];
        [textView.layer setMasksToBounds:YES];
        self.textView = textView;
        self.textView.inputAccessoryView  = self;
        //[textView becomeFirstResponder];
        UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:textView];
        UIBarButtonItem * doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(endEditing:)];
        
        [self setItems:@[item,  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], doneItem]];
        [self textViewDidChange:textView];
        
        // Initialization code
    }
    return self;
}
+(UIView *) accessoryViewForTextField:(UITextField *) aTextField{
    ICInputAccessoryView * toolbar = [[ICInputAccessoryView alloc] initWithFrame:CGRectMake(0.f, 0.f, 320.f, 44.f)];
    toolbar.originalTextField = aTextField;
    toolbar.textView.text = aTextField.text;
    return toolbar;
}

-(void) textViewDidEndEditing:(UITextView *)textView{
    NSLog(@"End editing");
    _originalTextField.text = textView.text;
}

-(void) textViewDidChangeSelection:(UITextView *)textView{
    [self textViewDidChange:textView];
}

-(void) textViewDidChange:(UITextView *)textView{
    //NSString * text  = textView.text;
    CGSize size = [textView sizeThatFits:CGSizeMake(textView.frame.size.width, CGFLOAT_MAX)];
    if (size.height < 170.f && size.height> 30.f) {
        CGRect frame = self.frame;
        frame.size.height = size.height+textView.font.pointSize;
        self.frame = frame;
    }
    _originalTextField.text = textView.text;
    //textView
}

-(void) endEditing:(id) sender{
    [_textView resignFirstResponder];
    [_originalTextField resignFirstResponder];
    _originalTextField.userInteractionEnabled = YES;
    [_originalTextField.delegate textFieldDidEndEditing:_originalTextField];
}

-(void) didMoveToSuperview{
    NSLog(@"Did move! %@", [self superview]);
}

-(void) willMoveToSuperview:(UIView *)newSuperview{
    NSLog(@"MOVE! %@", newSuperview);
    if(newSuperview){
        double delayInSeconds = 0.f;
        //
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            [_textView becomeFirstResponder];
            _originalTextField.userInteractionEnabled = NO;
        });
    }
    //[_originalTextField resignFirstResponder];
    
    
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
