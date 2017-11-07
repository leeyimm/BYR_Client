//
//  SectionTableViewController.h
//  BYR_Client
//
//  Created by Ying on 4/14/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Section.h"

@interface SectionTableViewController : UITableViewController

@property (nonatomic, strong) Section *section;
@property (nonatomic, assign) BOOL hasParent;

@end
