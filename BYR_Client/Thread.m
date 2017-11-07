//
//  Thread.m
//  JSONParse_iOS
//
//  Created by Ying on 5/8/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import "Thread.h"

@implementation Thread

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary: @{
                                                        @"id":@"ID",
                                                        @"user":@"author",
                                                        @"article":@"articles"
                                                        }];
}

@end
