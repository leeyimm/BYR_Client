//
//  FavoriteViewController.m
//  BYR_Client
//
//  Created by Ying on 5/8/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import "FavoriteViewController.h"
#import "RootViewController.h"
#import "NetworkManager.h"
#import "DataModel.h"
#import "DirectoryCell.h"
#import "BoardTableViewController.h"

@interface FavoriteViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) Favorite *favorite;

@end

@implementation FavoriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 66.0;
    
    
    UINib *articleCellNib = [UINib nibWithNibName:@"DirectoryCell" bundle:nil];
    [self.tableView registerNib:articleCellNib forCellReuseIdentifier:@"FavoriteCellIdentifier"];
    
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.favorite.boards count];
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DirectoryCell *cell = (DirectoryCell*)[self.tableView dequeueReusableCellWithIdentifier:@"FavoriteCellIdentifier" forIndexPath:indexPath];
    Board *board = self.favorite.boards[indexPath.row];
    cell.titleLabel.text = board.selfDescription;
    cell.subTitleLabel.text = board.name;
    cell.board = board;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BoardTableViewController *boardTableViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"BoardTableViewController"];
    boardTableViewController.board = self.favorite.boards[indexPath.row];
    
    [self.navigationController pushViewController:boardTableViewController animated:YES];
}





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)loadData{
    
    NSString *urlPath = [NSString stringWithFormat:@"favorite/0.json?%@", APIKEY];
    
    [[NetworkManager sharedManager] loadDataFromURL:urlPath withSuccessHandler:^(id responseObject) {
        NSDictionary *favoriteDict = responseObject;
        
        NSError *error;
        self.favorite = [[Favorite alloc] initWithDictionary:favoriteDict error:&error];
        if (error) {
            [SVProgressHUD showErrorWithStatus:@"parse favorite error"];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    }
     failureHandler:nil];
    
}

- (IBAction)editFavorite:(id)sender {
}

@end
