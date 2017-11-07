//
//  ReferboxViewController.m
//  BYR_Client
//
//  Created by Ying on 5/8/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import "ReferboxViewController.h"
#import "RootViewController.h"
#import "GeneralCell.h"
#import "DataModel.h"
#import "NetworkManager.h"
#import "ReferDetailViewController.h"
#import <MJRefresh/MJRefresh.h>

@interface ReferboxViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;

//@property (strong, nonatomic) NSMutableDictionary *referBoxDict;
@property (strong, nonatomic) NSString *referType;

@property (strong, nonatomic) NSMutableArray *referArticles;

@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,assign) NSInteger totalPages;

@end

@implementation ReferboxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.dataSource =self;
    self.tableView.delegate = self;
    
    //[self.tableView registerClass:[GeneralCell class] forCellReuseIdentifier:@"ReferViewCellIdentifier"];
    UINib *articleTitleCellNib = [UINib nibWithNibName:@"GeneralCell" bundle:nil];
    [self.tableView registerNib:articleTitleCellNib forCellReuseIdentifier:@"ReferViewCellIdentifier"];
    
    //self.referBoxDict = [NSMutableDictionary dictionaryWithCapacity:2];
    
    self.referType = @"reply";
    
    self.segmentControl.selectedSegmentIndex = 0;
    
    [self setupHeaderAndFooter];
    
    _referArticles = [[NSMutableArray alloc] init];
    _currentPage = _totalPages = 1;
    [self.tableView.header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark -- data source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.referArticles count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GeneralCell *cell = (GeneralCell *)[self.tableView dequeueReusableCellWithIdentifier:@"ReferViewCellIdentifier" forIndexPath:indexPath];
    Refer *refer = [self.referArticles objectAtIndex:indexPath.row];
    cell.titleLabel.text = refer.title;
    cell.leftLabel.text = refer.user.ID;
    cell.middleLabel.text = refer.board_name;
    cell.rightLabel.text = [refer.time stringValue];
    cell.data = refer;
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Refer *refer = [self.referArticles objectAtIndex:indexPath.row];
    Article *article = [[Article alloc] init];
    article.board_name = refer.board_name;
    article.ID = refer.ID;
    
    [self performSegueWithIdentifier:@"ShowReferDetailSegue" sender:article];
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowReferDetailSegue"])
    {
        ReferDetailViewController *referDetailViewController = (ReferDetailViewController*)segue.destinationViewController;
        referDetailViewController.article = sender;
        referDetailViewController.navigationItem.title = self.referType;
        
    }
}


-(void)loadData{
    if (_currentPage<=_totalPages) {
        NSString *urlPath = [NSString stringWithFormat:@"refer/%@.json?%@&page=%ld&count=20",self.referType, APIKEY, _currentPage];
        
        [[NetworkManager sharedManager] loadDataFromURL:urlPath
                                     withSuccessHandler:^(id responseObject) {
                                         NSDictionary *referboxDict = responseObject;
                                         
                                         NSError *error;
                                         ReferBox *referbox = [[ReferBox alloc] initWithDictionary:referboxDict error:&error];
                                         if (error) {
                                             [SVProgressHUD showErrorWithStatus:@"parse mailbox error"];
                                         }else{
                                             if (_currentPage ==1) {
                                                 [_referArticles removeAllObjects];
                                             }
                                             [_referArticles addObjectsFromArray:referbox.refers];
                                             _totalPages = [referbox.pagination.page_all_count integerValue];
                                             _currentPage++;
                                             [self.tableView reloadData];
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
    
    _currentPage = 1;
    [self.tableView.footer resetNoMoreData];
    [self loadData];
}



- (IBAction)referboxSwitch:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:
            self.referType = @"reply";
            break;
        case 1:
            self.referType = @"at";
            break;
        default:
            break;
    }
    [self refreshData];
}
- (IBAction)editReferbox:(id)sender {
}

@end
