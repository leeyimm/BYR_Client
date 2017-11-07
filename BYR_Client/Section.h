//
//  Section.h
//  BYR_Client
//
//  Created by Ying on 4/8/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import "Board.h"

@protocol NSString

@end

@protocol Section

@end


@interface Section : JSONModel

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *selfDescription;
@property (nonatomic, strong) NSString<Optional> *parent;
@property (nonatomic, strong) NSNumber *is_root;
@property (nonatomic, strong) NSArray<NSString,Optional> *sub_sections;
@property (nonatomic, strong) NSArray<Board,Optional> *boards;

@end
