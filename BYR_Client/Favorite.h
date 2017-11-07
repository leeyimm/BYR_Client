//
//  Favorite.h
//  BYR_Client
//
//  Created by Ying on 4/8/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import "Board.h"

@interface Favorite : JSONModel

@property (nonatomic, strong) NSArray<Board> *boards;

@end
