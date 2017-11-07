//
//  MailboxViewController.m
//  BYR_Client
//
//  Created by Ying on 5/8/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import "MailboxViewController.h"
#import "RootViewController.h"
#import "NetworkManager.h"
#import "DataModel.h"
#import "GeneralCell.h"
#import <MJRefresh/MJRefresh.h>
#import "Utilities.h"
#import "MailDetailViewController.h"


@interface MailboxViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;

@property (strong, nonatomic) NSMutableArray *mailsArray;
@property (strong, nonatomic) NSString *mailboxType;

@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,assign) NSInteger totalPages;


@end

@implementation MailboxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    UINib *articleTitleCellNib = [UINib nibWithNibName:@"GeneralCell" bundle:nil];
    [self.tableView registerNib:articleTitleCellNib forCellReuseIdentifier:@"MailViewCellIdentifier"];
    
    self.mailboxType = @"inbox";
    self.segmentControl.selectedSegmentIndex = 1;
    
    [self setupHeaderAndFooter];
    
    _mailsArray = [[NSMutableArray alloc] init];
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

#pragma mark -Table view datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_mailsArray count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    GeneralCell *cell = (GeneralCell *)[self.tableView dequeueReusableCellWithIdentifier:@"MailViewCellIdentifier" forIndexPath:indexPath];
    Mail *mail = [self.mailsArray objectAtIndex:indexPath.row];
    cell.leftLabel.text = mail.user.ID;
    cell.rightLabel.text = [Utilities dateToString:[mail.post_time intValue]];
    cell.titleLabel.text = mail.title;
    cell.data = mail;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [self performSegueWithIdentifier:@"ShowMailDetailSegue" sender:self.mailsArray[indexPath.row]];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowMailDetailSegue"])
    {
        MailDetailViewController *mailDetailViewController = (MailDetailViewController*)segue.destinationViewController;
        mailDetailViewController.mail = (Mail*)sender;
        
        mailDetailViewController.mailType  = _mailboxType;
    }
}

-(void)loadData{
    if (_currentPage<=_totalPages) {
        NSString *urlPath = [NSString stringWithFormat:@"mail/%@.json?%@&page=%ld&count=20",_mailboxType, APIKEY, _currentPage];
        [[NetworkManager sharedManager] loadDataFromURL:urlPath
                                     withSuccessHandler:^(id responseObject) {
                                         NSDictionary *mailboxDict = responseObject;
                                         
                                         NSError *error;
                                         Mailbox *mailbox = [[Mailbox alloc] initWithDictionary:mailboxDict error:&error];
                                         if (error) {
                                             [SVProgressHUD showErrorWithStatus:@"parse mailbox error"];
                                         }else{
                                             if (_currentPage ==1) {
                                                 [_mailsArray removeAllObjects];
                                             }
                                             [_mailsArray addObjectsFromArray:mailbox.mails];
                                             _totalPages = [mailbox.pagination.page_all_count integerValue];
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



- (IBAction)mailboxSwitch:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:
            self.mailboxType = @"outbox";
            break;
        case 1:
            self.mailboxType = @"inbox";
            break;
        case 2:
            self.mailboxType = @"deleted";
            break;
        default:
            break;
    }
    [self refreshData];
}


- (IBAction)editMailbox:(id)sender {
    
}

@end
