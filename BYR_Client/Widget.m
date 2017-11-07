//
//  Widget.m
//  JSONParse_iOS
//
//  Created by Ying on 5/8/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import "Widget.h"

@implementation Widget

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary: @{
                                                        @"article":@"threads",}];
}

@end
