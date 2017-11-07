//
//  DirectoryCell.h
//  BYR_Client
//
//  Created by Ying on 5/9/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"

@interface DirectoryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@property (strong, nonatomic) Section *section;
@property (strong, nonatomic) Board *board;

@end
