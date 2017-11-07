//
//  ReferBox.h
//  JSONParse_iOS
//
//  Created by Ying on 5/8/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import "Refer.h"
#import "Pagination.h"

@interface ReferBox : JSONModel

@property (nonatomic, strong) NSString *selfDescription;
@property (nonatomic, strong) Pagination *pagination;
@property (nonatomic, strong) NSArray<Refer> *refers;

@end
