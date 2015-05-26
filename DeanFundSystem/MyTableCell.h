//
//  MyTableCell.h
//  DeanFundSystem
//
//  Created by teddy on 15/1/22.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTableCell : UITableViewCell


@property (nonatomic, strong) IBOutlet UILabel *platLabel;//测站
@property (nonatomic, strong) IBOutlet UILabel *lastestLabel;//最新
@property (nonatomic, strong) IBOutlet UILabel *eightLabel;//今日8时
@property (nonatomic, strong) IBOutlet UILabel *trafficeLabel;//流量

@end
