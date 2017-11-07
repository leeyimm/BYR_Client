//
//  Article.m
//  BYR_Client
//
//  Created by Ying on 4/8/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import "Article.h"

@implementation Article

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:
            @{@"id":@"ID",
              @"user":@"author",
              }];
}

@end

