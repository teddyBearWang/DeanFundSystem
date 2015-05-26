//
//  MainViewController.h
//  DeanFundSystem
//
//  Created by teddy on 15/1/22.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"

@interface MainViewController : UIViewController
{
    NSArray *_functionArr;//功能数组
    ASIHTTPRequest *_request; //网络请求
    BOOL _isLoad;//表示正在加载数据
}

@end
