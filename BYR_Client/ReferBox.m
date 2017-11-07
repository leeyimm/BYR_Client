//
//  ReferBox.m
//  JSONParse_iOS
//
//  Created by Ying on 5/8/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import "ReferBox.h"

@implementation ReferBox

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary: @{
             @"description":@"selfDescription",
             @"article":@"refers"
              }];
}

@end
