//
//  Mailbox.h
//  BYR_Client
//
//  Created by Ying on 4/8/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import "Mail.h"
#import "Pagination.h"

@interface Mailbox : JSONModel

@property (nonatomic, strong) NSString *selfDescription;
@property (nonatomic, strong) Pagination *pagination;
@property (nonatomic, strong) NSArray<Mail> *mails;

@end
