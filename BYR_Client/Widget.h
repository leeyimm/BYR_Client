//
//  Widget.h
//  JSONParse_iOS
//
//  Created by Ying on 5/8/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import "Thread.h"
@class HotTopicSectionHeaderView;

@interface Widget : JSONModel

@property (nonatomic, strong) NSNumber<Optional> *isOpen;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSNumber *time;
@property (nonatomic, strong) NSArray<Thread> *threads;
@property HotTopicSectionHeaderView<Optional> *headerView;


@end
