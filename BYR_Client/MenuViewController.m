//
//  MenuViewController.m
//  BYR_Client
//
//  Created by Ying on 4/8/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import "MenuViewController.h"
#import "RootViewController.h"
#import "MenuViewCell.h"
#import "NetworkManager.h"

@interface MenuViewController () <UITableViewDataSource, UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UITableView *menuTableView;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (nonatomic, strong) NSArray *menuItems;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation MenuViewController

-(NSArray *)menuItems{
    if (_menuItems) return _menuItems;
    
    _menuItems = @[@[@"十大",@"分区"], @[@"收藏",@"邮箱",@"提醒"]];
    return _menuItems;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self validatePreviousLoginInfo];
    
    UIScreenEdgePanGestureRecognizer *recognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    recognizer.edges = UIRectEdgeRight;
    [self.view addGestureRecognizer:recognizer];
    
    // Do any additional setup after loading the view.

    self.menuTableView.rowHeight = 66;
}

-(void)pan:(UIScreenEdgePanGestureRecognizer*)recognizer
{
    //disable pangesture in menuView
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refreshMenu];
}

- (void)refreshMenu{
    if ([[NetworkManager sharedManager] loginUser]) {
        [self.loginButton setTitle:[[[NetworkManager sharedManager] loginUser] ID] forState:UIControlStateNormal];
    }else{
        [self.loginButton setTitle:@"login" forState:UIControlStateNormal];
    }
    [self.menuTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[NetworkManager sharedManager] loginUser]? 2:1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 0) {
        return 2;
    }else{
        return 3;
    }

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuViewCell *cell = (MenuViewCell *)[tableView dequeueReusableCellWithIdentifier:@"MenuViewCellIdentifier"];
    
    cell.label.text = self.menuItems[indexPath.section][indexPath.row];
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"导航";
    }else{
        return @"用户";
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UINavigationController *frontNavController;
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    frontNavController = [self.storyboard instantiateViewControllerWithIdentifier:@"HotTopicNavViewController"];
                    break;
                case 1:
                    frontNavController = [self.storyboard instantiateViewControllerWithIdentifier:@"ContentNavViewController"];
                    break;
                case 2:
                    frontNavController = [self.storyboard instantiateViewControllerWithIdentifier:@"ActivitiesNavViewController"];
                    break;                    
                default:
                    break;
            }
            [self.rootController resetFrontNavController:frontNavController];
            [self.rootController transitionToViewController:self.rootController.frontNavController];
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    frontNavController = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"FavoriteNavController"];
                    break;
                case 1:
                    frontNavController = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"MailBoxNavController"];
                    break;
                case 2:
                    frontNavController = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"ReminderNavController"];
                    break;
                default:
                    break;
            }
            [self.rootController resetFrontNavController:frontNavController];
            [self.rootController transitionToViewController:self.rootController.frontNavController];
            break;
            
        default:
            break;
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

*/



- (IBAction)userLogin {
    if ([[NetworkManager sharedManager] loginUser]) {
        [self performSegueWithIdentifier:@"currentUserInfoSegue" sender:nil];
    }else{
        [self performSegueWithIdentifier:@"userLoginSegue" sender:nil];
    }

}

-(void)validatePreviousLoginInfo{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* previousUserName = [defaults stringForKey:@"userName"];
    NSString* previousPassword = [defaults stringForKey:@"password"];
    if (previousUserName && ![previousUserName isEqualToString:@"guest"]) {
        [[NetworkManager sharedManager] validateLoginUserName:previousUserName password:previousPassword success:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self refreshMenu];
        });} failue:nil];
    }

}



@end
