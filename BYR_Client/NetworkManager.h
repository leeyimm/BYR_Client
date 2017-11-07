//
//  NetworkManager.h
//  BYR_Client
//
//  Created by Ying on 4/27/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "User.h"

static NSString *BYRAPIURL = @"http://api.byr.cn/";
//@"http://nforum.byr.edu.cn/byr/api/";
//



static NSString *APIKEY = @"appkey=ff7504fa9d6a4975";

@interface NetworkManager : AFHTTPSessionManager

@property  (nonatomic, strong) User *loginUser;

+ (NetworkManager *)sharedManager;

- (void)loadDataFromURL:(NSString *)URLString
     withSuccessHandler:(void (^)(id responseObject))successHandler
         failureHandler:(void (^)())failureHandler;


- (void)validateLoginUserName:(NSString *)userName
                     password:(NSString *)password
                      success:(void (^)())success
                       failue:(void (^)())failure;

- (void)resetLoginInfo;

@end
