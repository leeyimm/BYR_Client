//
//  NetworkManager.m
//  BYR_Client
//
//  Created by Ying on 4/27/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import "NetworkManager.h"

@interface NetworkManager ()

@property (copy) NSString *userName;
@property (copy) NSString *password;

@end

@implementation NetworkManager


+(NetworkManager *)sharedManager{
    static NetworkManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //NSURL *baseURL = [NSURL URLWithString:@"http://api.byr.cn"];
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        _sharedManager = [[NetworkManager alloc] initWithSessionConfiguration:config];
        _sharedManager.responseSerializer = [AFJSONResponseSerializer serializer];
        _sharedManager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        [_sharedManager getPreviousLoginIngo];
        
    });
    
    return _sharedManager;
}

- (void)loadDataFromURL:(NSString *)URLString
     withSuccessHandler:(void (^)(id))successHandler
         failureHandler:(void (^)())failureHandler
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    //NSString *URL = [NSString stringWithFormat:@"http://%@:%@@%@%@?%@",_userName, _password, BYRAPIURL,URLString, APIKEY];
    [self.requestSerializer setAuthorizationHeaderFieldWithUsername:_userName password:_password];
    
    NSString *URL = [NSString stringWithFormat:@"%@%@", BYRAPIURL,URLString];
    

    [[NetworkManager sharedManager] GET:URL
                                 parameters:nil
                                    success:^(NSURLSessionDataTask *task, id responseObject) {
                                        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                        successHandler(responseObject);
                                    }
                                    failure:^(NSURLSessionDataTask *task, NSError *error) {
                                        //NSLog(@"error is %@", error);
                                        [SVProgressHUD showErrorWithStatus:@"网络不给力哦"];
                                        if(failureHandler)failureHandler();
                                    }];
    
}

- (void)validateLoginUserName:(NSString *)userName
                     password:(NSString *)password
                      success:(void (^)())success
                       failue:(void (^)())failure
{
    [self.requestSerializer setAuthorizationHeaderFieldWithUsername:userName password:password];
    
    NSString *URLString =[NSString stringWithFormat:@"http://nforum.byr.edu.cn/byr/api/user/login.json"];
    
    [self GET:URLString parameters:nil
                                success:^(NSURLSessionDataTask *task, id responseObject)
    {
        NSDictionary *dict = responseObject;
        NSError *error;
        User *loginUser = [[User alloc] initWithDictionary:dict error:&error];
        if (error) {
            [self resetLoginInfo];
            if(failure)failure();
        }else{
            [self setLoginUserName:userName password:password];
            [self setLoginUser:loginUser];
            if(success)success();
        }

    }
                                failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self resetLoginInfo];
        [SVProgressHUD showErrorWithStatus:@"network error"];
    }];
}

-(void)getPreviousLoginIngo{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _userName = [defaults objectForKey:@"userName"];
    _password = [defaults objectForKey:@"password"];
    if (_userName == nil) {
        [self resetLoginInfo];
    }
}


- (void)setLoginUserName:(NSString *)userName password:(NSString*)password
{
    _userName = userName;
    _password = password;
    
    [self saveLoginIngo];
}


-(void)resetLoginInfo{
    _userName= @"guest";
    _password=@"";
    _loginUser = nil;
    [self saveLoginIngo];
}

-(void)saveLoginIngo{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_userName forKey:@"userName"];
    [defaults setObject:_password forKey:@"password"];
}


@end
