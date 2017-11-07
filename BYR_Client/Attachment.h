//
//  Attachment.h
//  BYR_Client
//
//  Created by Ying on 4/8/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import "AttachedFile.h"

@protocol AttachedFile
@end

@interface Attachment : JSONModel

@property (nonatomic, strong) NSArray<AttachedFile> *attachedFiles;
@property (nonatomic, strong) NSString *remain_space;
@property (nonatomic, strong) NSNumber *remain_count;

@end
