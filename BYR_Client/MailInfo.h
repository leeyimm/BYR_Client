//
//  MailInfo.h
//  JSONParse_iOS
//
//  Created by Ying on 5/8/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import "JSONModel.h"

@interface MailInfo : JSONModel

@property (nonatomic, strong) NSNumber *has_new_mail;
@property (nonatomic, strong) NSNumber *full_mail;
@property (nonatomic, strong) NSString *space_used;
@property (nonatomic, strong) NSNumber *can_send;


@end
