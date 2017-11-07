//
//  SearchViewController.m
//  BYR_Client
//
//  Created by Ying on 5/27/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import "SearchViewController.h"
#import "NetworkManager.h"
#import "GeneralCell.h"
#import "Utilities.h"
#import "ThreadTableViewController.h"

@interface SearchViewController () <UITabBarControllerDelegate, UITableViewDataSource, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *resultTableView;

@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,assign) NSInteger totalPages;

@property (strong, nonatomic) NSMutableArray *threadsArray;
@property (strong, nonatomic) ThreadsSearchResult *searchResult;
@property (strong, nonatomic) NSString *keyWord;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *articleCellNib = [UINib nibWithNibName:@"GeneralCell" bundle:nil];
    [self.resultTableView registerNib:articleCellNib forCellReuseIdentifier:@"ArticleCellIdentifier"];
    // Do any additional setup after loading the view.
    
    _currentPage = 1;
    _totalPages = 1;
    _threadsArray = [[NSMutableArray alloc] init];
    
    self.navigationItem.title = self.board.selfDescription;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark tableviewdatasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.threadsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GeneralCell *cell = (GeneralCell *)[tableView dequeueReusableCellWithIdentifier:@"ArticleCellIdentifier" forIndexPath:indexPath];
    
    Thread *thread = self.threadsArray[indexPath.row];
    
    cell.titleLabel.text = thread.title;
    cell.leftLabel.text = thread.author.ID;
    cell.middleLabel.text = [thread.reply_count stringValue];
    cell.rightLabel.text = [Utilities dateToString:[thread.last_reply_time intValue]];
    cell.data = thread;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Thread *selectedThread = self.threadsArray[indexPath.row];
    [self performSegueWithIdentifier:@"ShowArticleDetail" sender:selectedThread];
}



#pragma mark searchBarDelegate

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    NSString *keyWord = [searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([keyWord isEqualToString:self.keyWord]) {
        return;
    }else{
        self.keyWord = keyWord;
        _currentPage = 1;
        _totalPages = 1;
        [self loadData];
        
    }

}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 if ([segue.identifier isEqualToString:@"ShowArticleDetail"])
 {
 ThreadTableViewController *threadTableViewController = (ThreadTableViewController*)segue.destinationViewController;
 Thread *selectedThread = sender;
 threadTableViewController.thread = selectedThread;
 
 }
}


-(void)loadData{
    if (_currentPage<=_totalPages) {
        NSString *urlPath = [NSString stringWithFormat:@"search/threads.json?%@&board=%@&title1=%@&page=%ld", APIKEY,_board.name,_keyWord,_currentPage];
        
        [[NetworkManager sharedManager] loadDataFromURL:[urlPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                                     withSuccessHandler:^(id responseObject) {
                                         NSDictionary *resultDict = responseObject;
                                         
                                         NSError *error;
                                         self.searchResult = [[ThreadsSearchResult alloc] initWithDictionary:resultDict error:&error];
                                         if (error) {
                                             [SVProgressHUD showErrorWithStatus:@"parse result error"];
                                         }else{
                                             if ([self.searchResult.pagination.item_all_count intValue]==0) {
                                                 [SVProgressHUD showInfoWithStatus:@"没有包含关键字内容"];
                                             }else{
                                                 if (_currentPage ==1) {
                                                     [_threadsArray removeAllObjects];
                                                 }
                                                 [_threadsArray addObjectsFromArray:self.searchResult.threads];
                                                 _totalPages = [self.searchResult.pagination.page_all_count integerValue];
                                                 _currentPage++;
                                                 [self.resultTableView reloadData];
                                                 [self.searchBar resignFirstResponder];
                                             }
                                             
                                         }
                                         //[self.tableView.header endRefreshing];
                                         //[self.tableView.footer endRefreshing];
                                         
                                     }
                                         failureHandler:^{
                                             //[self.tableView.header endRefreshing];
                                             //[self.tableView.footer endRefreshing];
                                             
                                         }];
    }else{
        //[self.tableView.footer noticeNoMoreData];
    }
}

@end
