//
//  Refer.h
//  BYR_Client
//
//  Created by Ying on 4/8/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import "User.h"

@protocol Refer 
@end

@interface Refer : JSONModel

@property (nonatomic, strong) NSNumber *index;
@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, strong) NSNumber *group_id;
@property (nonatomic, strong) NSNumber *reply_id;
@property (nonatomic, strong) NSNumber *time;
@property (nonatomic, strong) NSNumber *is_read;
@property (nonatomic, strong) NSString *board_name;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) User *user;


@end
