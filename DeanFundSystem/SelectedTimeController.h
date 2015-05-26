//
//  SelectedTimeController.h
//  DeanFundSystem
//
//  Created by teddy on 15/2/3.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ReturnBlock)(NSMutableArray *arr);

@interface SelectedTimeController : UIViewController<UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIButton *st_btn;
@property (weak, nonatomic) IBOutlet UIButton *et_btn;
@property (weak, nonatomic) IBOutlet UILabel *st_label;
@property (weak, nonatomic) IBOutlet UILabel *et_label;

@property (nonatomic, strong) ReturnBlock returnBlock;

- (void)setBlock:(ReturnBlock)block;
- (IBAction)selectStTimeAction:(id)sender;
- (IBAction)SelectEtTimeAction:(id)sender;

@end
