//
//  Pagination.h
//  JSONParse_iOS
//
//  Created by Ying on 5/8/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import "JSONModel.h"

@interface Pagination : JSONModel

@property (nonatomic, strong) NSNumber *page_all_count;
@property (nonatomic, strong) NSNumber *page_current_count;
@property (nonatomic, strong) NSNumber *item_page_count;
@property (nonatomic, strong) NSNumber *item_all_count;

@end
