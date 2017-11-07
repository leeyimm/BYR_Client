//
//  MailInfo.m
//  JSONParse_iOS
//
//  Created by Ying on 5/8/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import "MailInfo.h"

@implementation MailInfo

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary: @{
        @"new_mail":@"has_new_mail"
                                                        }];
}

@end
