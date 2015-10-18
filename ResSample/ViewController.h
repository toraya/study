//
//  ViewController.h
//  ResSample
//
//  Created by OhnumaRina on 2015/10/05.
//  Copyright (c) 2015年 OhnumaRina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReqHTTP.h"

@interface ViewController : UIViewController

@property (nonatomic, strong) NSString *dateStr;
@property (nonatomic, strong) NSURL *requstUrl;
@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, strong) NSData *imgDate;


@end

