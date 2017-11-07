//
//  User.h
//  BYR_Client
//
//  Created by Ying on 4/8/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import "JSONModel.h"

@interface User : JSONModel

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString<Optional> *user_name;
@property (nonatomic, strong) NSString<Optional> *face_url;
@property (nonatomic, strong) NSString<Optional> *gender;
@property (nonatomic, strong) NSString<Optional> *astro;
@property (nonatomic, strong) NSString<Optional> *level;
@property (nonatomic, strong) NSString<Optional> *last_login_ip;
@property (nonatomic, strong) NSNumber<Optional> *life;
@property (nonatomic, strong) NSNumber<Optional> *score;
@property (nonatomic, strong) NSNumber<Optional> *post_count;
@property (nonatomic, strong) NSNumber<Optional> *last_login_time;
@property (nonatomic, strong) NSNumber<Optional> *is_online;


@end
