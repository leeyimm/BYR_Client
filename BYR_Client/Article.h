//
//  Article.h
//  BYR_Client
//
//  Created by Ying on 4/8/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import "Attachment.h"
#import "User.h"

@protocol Article

@end

@interface Article : JSONModel

@property (nonatomic,strong) NSNumber *ID;
@property (nonatomic,strong) NSNumber *group_id;
@property (nonatomic,strong) NSNumber *reply_id;
@property (nonatomic,strong) NSNumber *position;
@property (nonatomic,strong) NSNumber *is_top;
@property (nonatomic,strong) NSNumber *is_subject;
@property (nonatomic,strong) NSNumber *has_attachment;
@property (nonatomic,strong) NSNumber *is_admin;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) User *author;
@property (nonatomic,strong) NSNumber *post_time;
@property (nonatomic,strong) NSString *board_name;
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) Attachment *attachment;


//@property (nonatomic,strong) NSNumber * previous_id;
//@property (nonatomic,strong) NSNumber *next_id;
//@property (nonatomic,strong) NSNumber *threads_previous_id;
//@property (nonatomic,strong) NSNumber *threads_next_id;
//@property (nonatomic,strong) NSNumber *reply_count;
//@property (nonatomic,strong) NSNumber *ast_reply_time;
//@property (nonatomic,strong) NSString *last_reply_user_id;


@end
