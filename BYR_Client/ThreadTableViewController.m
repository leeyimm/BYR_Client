//
//  ThreadTableViewController.m
//  BYR_Client
//
//  Created by Ying on 5/9/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import "ThreadTableViewController.h"
#import "ArticleTitleViewCell.h"
#import "SingleArticleViewCell.h"
#import "Utilities.h"
#import "NetworkManager.h"
#import "NYTPhotosViewController.h"
#import "Attachment.h"
#import "DataModel.h"
#import <MJRefresh/MJRefresh.h>
#import "PostViewController.h"
#import "PostViewController.h"

@interface ThreadTableViewController () <SingleArticleViewCellDelegate, NYTPhotosViewControllerDelegate>

@property (nonatomic,strong) NSMutableArray *articles;
@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,assign) NSInteger totalPages;

@end

static NSString *ArticleTitleViewIdentifier = @"ArticleTitleViewCellIdentifier";
static NSString *SingleArticleViewIdentifier = @"SingleArticleViewCellIdentifier";

@implementation ThreadTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *articleTitleCellNib = [UINib nibWithNibName:@"ArticleTitleViewCell" bundle:nil];
    [self.tableView registerNib:articleTitleCellNib forCellReuseIdentifier:ArticleTitleViewIdentifier];
    
    UINib *singleArticleCellNib = [UINib nibWithNibName:@"SingleArticleViewCell" bundle:nil];
    [self.tableView registerNib:singleArticleCellNib forCellReuseIdentifier:SingleArticleViewIdentifier];
    
    [self setupHeaderAndFooter];
    
    _articles = [[NSMutableArray alloc] init];
    
    _currentPage = 1;
    _totalPages = 1;
    
    [self.tableView.header beginRefreshing];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    
    //[self loadData];
    
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.articles count]+1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row ==0) {
        ArticleTitleViewCell *cell = (ArticleTitleViewCell*)[tableView dequeueReusableCellWithIdentifier:ArticleTitleViewIdentifier];
        cell.articleTitleLabel.text =self.thread.title;
        return cell;
    }else{
        SingleArticleViewCell *cell = (SingleArticleViewCell*)[tableView dequeueReusableCellWithIdentifier:SingleArticleViewIdentifier forIndexPath:indexPath];
        Article *article = self.articles[indexPath.row-1];
        cell.article = article;
        cell.delegate = self;
        [cell prepareDataToShow];
        return cell;
    }
}


#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int returnHeight;
    if (indexPath.row == 0)
    {
//        UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
//        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
//        CGSize size1 = [self.thread.title boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 16, 1000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: font, NSParagraphStyleAttributeName: paragraphStyle} context:nil].size;
//        
//        returnHeight = size1.height  + 16;
        returnHeight=66;
    }
    else {
        
        Article *article = self.articles[indexPath.row-1];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        CGSize size = [article.content boundingRectWithSize:CGSizeMake(self.view.frame.size.width -32, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font,NSParagraphStyleAttributeName: paragraphStyle} context:nil].size;
        paragraphStyle = nil;
        returnHeight = size.height+60;
        
        if (article.attachment.attachedFiles != nil) {
            returnHeight += (240 * [article.attachment.attachedFiles count]);
        }
    }
    return returnHeight;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


-(void)loadData{
    
    if (_currentPage<=_totalPages) {
        NSString *urlPath = [NSString stringWithFormat:@"threads/%@/%@.json?%@&page=%ld&count=20",_thread.board_name, _thread.ID, APIKEY,_currentPage];
        
        [[NetworkManager sharedManager] loadDataFromURL:urlPath
                                     withSuccessHandler:^(id responseObject) {
                                         NSDictionary *threadsDict = responseObject;
                                         NSError *error;
                                         self.thread = [[Thread alloc] initWithDictionary:threadsDict error:&error];
                                         if (error) {
                                             [SVProgressHUD showErrorWithStatus:@"parse threads error"];
                                         }else{
                                             if (_currentPage ==1) {
                                                 [_articles removeAllObjects];
                                             }
                                             [_articles addObjectsFromArray:self.thread.articles];
                                             _totalPages = [self.thread.pagination.page_all_count integerValue];
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

#pragma mark - SingleArticleViewCellDelegate
-(void)attachmentImageViewTappedInArticleCell:(SingleArticleViewCell *)articleCell imageIndex:(NSInteger)index{
    
    AttachmentImageView *attachmentImageView = articleCell.attachmentsViewArray[index];
    
    NYTPhotosViewController *photoViewController = [[NYTPhotosViewController alloc] initWithPhotos:articleCell.attachmentsViewArray initialPhoto:attachmentImageView];
    photoViewController.delegate = self;
    [self presentViewController:photoViewController animated:YES completion:nil];
}

-(void)replyPostInArticleCell:(SingleArticleViewCell *)articleCell{
    UINavigationController *postNavController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PostNavController"];
    PostViewController *replyPostViewController = (PostViewController *)postNavController.topViewController;
    replyPostViewController.relatedArticle = articleCell.article;
    replyPostViewController.postType = REPLY_POST;
    
    [self presentViewController:postNavController animated:YES completion:nil];
    
}

-(void)sendMailInArticleCell:(SingleArticleViewCell *)commentCell{
    
}






@end
