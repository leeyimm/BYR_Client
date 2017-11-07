//
//  PostViewController.h
//  BYR_Client
//
//  Created by Ying on 5/17/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"


typedef NS_ENUM (NSInteger, PostType){
    NEW_POST,
    REPLY_POST,
    UPDATE_POST
};

@interface PostViewController : UIViewController

@property (nonatomic, strong) Article *relatedArticle;
@property (nonatomic, strong) NSString *boardName;
@property (nonatomic, assign) PostType postType;

@end
