//
//  Mailbox.m
//  BYR_Client
//
//  Created by Ying on 4/8/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import "Mailbox.h"

@implementation Mailbox

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary: @{
              @"description":@"selfDescription",
              @"mail":@"mails"
              }];
}

@end
