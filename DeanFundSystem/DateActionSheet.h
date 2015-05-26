//
//  DateActionSheet.h
//  DeanFundSystem
//
//  Created by teddy on 15/1/26.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DateObject.h"

@interface DateActionSheet : UIActionSheet

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) DateObject *selectedDate;

- (IBAction)cancelAction:(id)sender;
- (IBAction)confirmAction:(id)sender;
- (id)initWithTitle:(NSString *)title delegate:(id<UIActionSheetDelegate>)delegate;
- (void)showInView:(UIView *)view;
@end
