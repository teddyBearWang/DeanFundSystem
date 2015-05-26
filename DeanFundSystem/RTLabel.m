//
//  RTLabel.m
//  DeanFundSystem
//
//  Created by teddy on 15/1/23.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "RTLabel.h"

@implementation RTLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self customPoportyAction];
    }
    return self;
}

- (void)customPoportyAction
{
    self.textAlignment = NSTextAlignmentCenter;
    self.font = [UIFont boldSystemFontOfSize:15];
    self.backgroundColor = [UIColor clearColor];
}

@end
