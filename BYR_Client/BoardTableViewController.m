//
//  BoardTableViewController.m
//  BYR_Client
//
//  Created by Ying on 4/15/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import "BoardTableViewController.h"
#import "GeneralCell.h"
#import "Board.h"
#import "Utilities.h"
#import "ThreadTableViewController.h"
#import "NetworkManager.h"
#import <MJRefresh/MJRefresh.h>
#import "PostViewController.h"
#import "SearchViewController.h"

@interface BoardTableViewController ()

@property (nonatomic,strong) NSMutableArray *threads;
@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,assign) NSInteger totalPages;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *batButton;

@end

@implementation BoardTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (![self.board.allow_post boolValue]) {
        self.batButton.enabled = NO;
    }
    
    [self setupHeaderAndFooter];
    
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchThreads)];
    UIBarButtonItem *composeMailButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(composeNewPost)];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects: composeMailButton,searchButton, nil];
    
    
    self.navigationItem.title = self.board.selfDescription;
    
    _threads = [[NSMutableArray alloc] init];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //
    
    UINib *articleCellNib = [UINib nibWithNibName:@"GeneralCell" bundle:nil];
    [self.tableView registerNib:articleCellNib forCellReuseIdentifier:@"ArticleCellIdentifier"];
    
    _currentPage = 1;
    _totalPages = 1;
    
    [self.tableView.header beginRefreshing];
}

-(void)searchThreads{
    
    [self performSegueWithIdentifier:@"ShowSearchViewController" sender:nil];
    
}

-(void)composeNewPost{
    [self performSegueWithIdentifier:@"WritePostSegue" sender:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupHeaderAndFooter {
    [self.tableView addLegendHeaderWithRefreshingTarget:self
                                       refreshingAction:@selector(refreshData)];
    [self.tableView addLegendFooterWithRefreshingTarget:self
                                       refreshingAction:@selector(loadData)];
    self.tableView.footer.automaticallyRefresh = YES;
    self.tableView.footer.hidden = NO;
    self.tableView.header.textColor = [UIColor lightGrayColor];
    self.tableView.footer.textColor = [UIColor lightGrayColor];
    
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    //_totalPages = 1;
    //[self.tableView.header beginRefreshing];
    //[self loadData];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.threads count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GeneralCell *cell = (GeneralCell *)[tableView dequeueReusableCellWithIdentifier:@"ArticleCellIdentifier" forIndexPath:indexPath];
    
    Thread *thread = self.threads[indexPath.row];
    
    cell.titleLabel.text = thread.title;
    cell.leftLabel.text = thread.author.ID;
    cell.middleLabel.text = [thread.reply_count stringValue];
    cell.rightLabel.text = [Utilities dateToString:[thread.last_reply_time intValue]];
    cell.data = thread;

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Thread *selectedThread = self.threads[indexPath.row];
    [self performSegueWithIdentifier:@"ShowArticleDetail" sender:selectedThread];
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
    if ([segue.identifier isEqualToString:@"WritePostSegue"]) {
        UINavigationController *nc = (UINavigationController *)[segue destinationViewController];
        PostViewController *postViewController = (PostViewController *)[nc topViewController];
        postViewController.boardName = self.board.name;
        postViewController.postType = NEW_POST;
    }
    if ([segue.identifier isEqualToString:@"ShowSearchViewController"]) {
        
        SearchViewController *searchViewController = (SearchViewController *)[segue destinationViewController];
        searchViewController.board = self.board;
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}



-(void)loadData{
    if (_currentPage<=_totalPages) {
        NSString *urlPath = [NSString stringWithFormat:@"board/%@.json?%@&page=%ld&count=20",_board.name, APIKEY,_currentPage];
        
        [[NetworkManager sharedManager] loadDataFromURL:urlPath
                                     withSuccessHandler:^(id responseObject) {
                                         NSDictionary *boardDict = responseObject;
                                         
                                         NSError *error;
                                         self.board = [[Board alloc] initWithDictionary:boardDict error:&error];
                                         if (error) {
                                             [SVProgressHUD showErrorWithStatus:@"parse board error"];
                                         }else{
                                             if (_currentPage ==1) {
                                                [_threads removeAllObjects];
                                             }
                                             [_threads addObjectsFromArray:self.board.threads];
                                             _totalPages = [self.board.pagination.page_all_count integerValue];
                                             _currentPage++;
                                             [self.tableView reloadData];
                                             if ([self.board.allow_post boolValue]) {
                                                 self.batButton.enabled = YES;
                                             }
                                             self.navigationItem.title = self.board.selfDescription;
                                         }
                                         [self.tableView.header endRefreshing];
                                         [self.tableView.footer endRefreshing];
                                         
                                     }
                                         failureHandler:^{
                                             [self.tableView.header endRefreshing];
                                             [self.tableView.footer endRefreshing];
                                            
                                         }];
    }else{
        [self.tableView.footer noticeNoMoreData];
    }
}

-(void)refreshData{

    [self.tableView reloadData];
    _currentPage = 1;
    [self.tableView.footer resetNoMoreData];
    [self loadData];
}

@end


