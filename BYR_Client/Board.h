//
//  Board.h
//  BYR_Client
//
//  Created by Ying on 4/8/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import "Thread.h"

@protocol Board

@end

@interface Board : JSONModel

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *manager;
@property (nonatomic, strong) NSString *selfDescription;
@property (nonatomic, strong) NSString *board_class;
@property (nonatomic, strong) NSString *section;
@property (nonatomic, strong) NSNumber<Optional> *post_today_count;
@property (nonatomic, strong) NSNumber<Optional> *post_threads_count;
@property (nonatomic, strong) NSNumber<Optional> *post_all_count;
@property (nonatomic, strong) NSNumber<Optional> *user_online_count;
@property (nonatomic, strong) NSNumber<Optional> *user_online_max_count;
@property (nonatomic, strong) NSNumber<Optional> *user_online_max_time;
@property (nonatomic, strong) NSNumber<Optional> *is_read_only;
@property (nonatomic, strong) NSNumber<Optional> *is_no_reply;
@property (nonatomic, strong) NSNumber<Optional> *allow_attachment;
@property (nonatomic, strong) NSNumber<Optional> *allow_anonymous;
@property (nonatomic, strong) NSNumber<Optional> *allow_outgo;
@property (nonatomic, strong) NSNumber<Optional> *allow_post;
@property (nonatomic, strong) Pagination<Optional> *pagination;
@property (nonatomic, strong) NSArray<Thread, Optional> *threads;

@end
