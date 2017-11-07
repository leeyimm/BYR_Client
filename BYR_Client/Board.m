//
//  Board.m
//  BYR_Client
//
//  Created by Ying on 4/8/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import "Board.h"

@implementation Board

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary: @{
                    @"description":@"selfDescription",
                    @"article":@"threads",
                    @"class":@"board_class"
                    }];
}

@end
