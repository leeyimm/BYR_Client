//
//  Root.m
//  JSONParse_iOS
//
//  Created by Ying on 5/8/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import "Root.h"

@implementation Root

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary: @{
             @"section":@"sections",
             }];
}

@end
