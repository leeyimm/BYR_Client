//
//  Section.m
//  BYR_Client
//
//  Created by Ying on 4/8/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import "Section.h"

@implementation Section

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary: @{
                   @"description":@"selfDescription",
                   @"sub_section":@"sub_sections",
                   @"board":@"boards"
                   }];
}

@end
