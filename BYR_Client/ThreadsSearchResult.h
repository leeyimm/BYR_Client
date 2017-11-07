//
//  ThreadsSearchResult.h
//  BYR_Client
//
//  Created by Ying on 5/27/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import "JSONModel.h"
#import "Pagination.h"
#import "Thread.h"

@interface ThreadsSearchResult : JSONModel

@property (nonatomic, strong) Pagination<Optional> *pagination;
@property (nonatomic, strong) NSArray<Thread, Optional> *threads;

@end
