//
//  AttachedFile.h
//  BYR_Client
//
//  Created by Ying on 4/8/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import "JSONModel.h"

@interface AttachedFile : JSONModel

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *size;
@property (nonatomic, strong) NSString *thumbnail_small;
@property (nonatomic, strong) NSString *thumbnail_middle;


@end
