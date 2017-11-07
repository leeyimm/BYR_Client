//
//  Thread.h
//  JSONParse_iOS
//
//  Created by Ying on 5/8/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import "Article.h"
#import "Pagination.h"

@protocol Thread 
@end


@interface Thread : JSONModel

@property (nonatomic,strong) NSNumber *ID;
@property (nonatomic,strong) NSNumber *group_id;
@property (nonatomic,strong) NSNumber *reply_id;
@property (nonatomic,strong) NSNumber *position;
@property (nonatomic,strong) NSNumber *is_top;
@property (nonatomic,strong) NSNumber *is_subject;
@property (nonatomic,strong) NSNumber *has_attachment;
@property (nonatomic,strong) NSNumber *is_admin;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) User<Optional> *author;
@property (nonatomic,strong) NSNumber *post_time;
@property (nonatomic,strong) NSString *board_name;
@property (nonatomic,strong) NSNumber *reply_count;
@property (nonatomic,strong) NSString *last_reply_user_id;
@property (nonatomic,strong) NSNumber *last_reply_time;
@property (nonatomic,strong) Pagination<Optional> *pagination;
@property (nonatomic,strong) NSArray<Article, Optional> *articles;


@end
