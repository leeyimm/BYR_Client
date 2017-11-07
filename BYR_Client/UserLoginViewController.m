//
//  UserLoginViewController.m
//  BYR_Client
//
//  Created by Ying on 4/27/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import "UserLoginViewController.h"
#import "NetworkManager.h"

@interface UserLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation UserLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.userNameTextField becomeFirstResponder];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)login:(id)sender {
    
    //self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    __weak typeof(self) weakSelf = self;
    [[NetworkManager sharedManager] validateLoginUserName:self.userNameTextField.text
                                 password:self.passwordTextField.text
                                  success:^{
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
                                   failue:^{
                                        [SVProgressHUD showErrorWithStatus:@"user login failed"];
                                   }];
//    [self.indicator setAnimatingWithStateOfTask:task];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
