//
//  Attachment.m
//  BYR_Client
//
//  Created by Ying on 4/8/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import "Attachment.h"

@implementation Attachment

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:
            @{@"file":@"attachedFiles"}];
}

@end
