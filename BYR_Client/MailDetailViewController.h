//
//  MailDetailViewController.h
//  BYR_Client
//
//  Created by Ying on 5/26/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"

@interface MailDetailViewController : UIViewController

@property (strong, nonatomic) Mail *mail;
@property (strong, nonatomic) NSString *mailType;

@end
