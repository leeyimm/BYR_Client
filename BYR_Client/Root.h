//
//  Root.h
//  JSONParse_iOS
//
//  Created by Ying on 5/8/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import "Section.h"

@interface Root : JSONModel

@property (nonatomic, strong) NSNumber *section_count;
@property (nonatomic, strong) NSArray<Section> *sections;

@end
