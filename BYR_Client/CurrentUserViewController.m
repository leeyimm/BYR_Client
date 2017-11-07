//
//  CurrentUserViewController.m
//  BYR_Client
//
//  Created by Ying on 4/29/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import "CurrentUserViewController.h"
#import "NetworkManager.h"

@interface CurrentUserViewController ()

@end

@implementation CurrentUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)userLogout:(id)sender {
    [[NetworkManager sharedManager] resetLoginInfo];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
