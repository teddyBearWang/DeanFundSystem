//
//  DateActionSheet.m
//  DeanFundSystem
//
//  Created by teddy on 15/1/26.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "DateActionSheet.h"
#define KDuration 0.3



@implementation DateActionSheet

- (id)initWithTitle:(NSString *)title delegate:(id<UIActionSheetDelegate>)delegate
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"DateActionSheet" owner:self options:nil] lastObject];
    if (self) {
        self.delegate = delegate;
        self.selectedDate = [[DateObject alloc] init];
        
        self.datePicker.datePickerMode = UIDatePickerModeDate;
        self.datePicker.tag = 200;
        self.datePicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:-60*60*24*365*10];
        self.datePicker.maximumDate = [NSDate date];
       // self.datePicker.date = [NSDate dateWithTimeIntervalSinceNow:-60*60*24];
    }
    return self;
}

- (void)showInView:(UIView *)view
{
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = KDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromTop;
    [self setAlpha:1.0f];
    [self.layer addAnimation:animation forKey:@"DDLocateView"];
        
    self.frame = CGRectMake(0, view.frame.size.height - self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [view addSubview:self];
}

- (IBAction)cancelAction:(id)sender
{
    CATransition *animation = [CATransition  animation];
    animation.delegate = self;
    animation.duration = KDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromBottom;
    [self setAlpha:0.0f];
    [self.layer addAnimation:animation forKey:@"TSLocateView"];
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:KDuration];
    if(self.delegate) {
        self.Index = 0;
        [self.delegate actionSheet:self clickedButtonAtIndex:0];
    }
}

- (IBAction)confirmAction:(id)sender
{
    UIDatePicker *datePicker = (UIDatePicker *)[self viewWithTag:200];
    NSDate *seleted = datePicker.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.selectedDate.date = [dateFormatter stringFromDate:seleted];
    
    CATransition *animation = [CATransition  animation];
    animation.delegate = self;
    animation.duration = KDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromBottom;
    [self setAlpha:0.0f];
    [self.layer addAnimation:animation forKey:@"TSLocateView"];
    
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:KDuration];
    if (self.delegate) {
        self.index = 1;
        [self.delegate actionSheet:self clickedButtonAtIndex:1];
    }
}
@end
