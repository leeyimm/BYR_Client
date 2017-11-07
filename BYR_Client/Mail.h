//
//  Mail.h
//  BYR_Client
//
//  Created by Ying on 4/8/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//


#import "Attachment.h"
#import "User.h"

@protocol Mail
@end

@interface Mail : JSONModel

@property (nonatomic, strong) NSNumber * index;
@property (nonatomic, strong) NSNumber * post_time;
@property (nonatomic, strong) NSNumber *is_m;
@property (nonatomic, strong) NSNumber *is_read;
@property (nonatomic, strong) NSNumber *is_reply;
@property (nonatomic, strong) NSNumber *has_attachment;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *box_name;
@property (nonatomic, strong) NSString<Optional> *content;
@property (nonatomic, strong) Attachment<Optional> *attachment;
@property (nonatomic, strong) User* user;

@end
