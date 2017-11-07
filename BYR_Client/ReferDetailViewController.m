//
//  ReferDetailViewController.m
//  BYR_Client
//
//  Created by Ying on 5/9/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import "ReferDetailViewController.h"
#import "ArticleTitleViewCell.h"
#import "SingleArticleViewCell.h"
#import "Utilities.h"
#import "NetworkManager.h"
#import "NYTPhotosViewController.h"
#import "Attachment.h"
#import "DataModel.h"
#import "ThreadTableViewController.h"

@interface ReferDetailViewController () <SingleArticleViewCellDelegate, NYTPhotosViewControllerDelegate>

@end

static NSString *ArticleTitleViewIdentifier = @"ArticleTitleViewCellIdentifier";
static NSString *SingleArticleViewIdentifier = @"SingleArticleViewCellIdentifier";

@implementation ReferDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *articleTitleCellNib = [UINib nibWithNibName:@"ArticleTitleViewCell" bundle:nil];
    [self.tableView registerNib:articleTitleCellNib forCellReuseIdentifier:ArticleTitleViewIdentifier];
    
    UINib *singleArticleCellNib = [UINib nibWithNibName:@"SingleArticleViewCell" bundle:nil];
    [self.tableView registerNib:singleArticleCellNib forCellReuseIdentifier:SingleArticleViewIdentifier];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self loadData];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row ==0) {
        ArticleTitleViewCell *cell = (ArticleTitleViewCell*)[tableView dequeueReusableCellWithIdentifier:ArticleTitleViewIdentifier];
        cell.articleTitleLabel.text =self.article.title;
        return cell;
    }else{
        SingleArticleViewCell *cell = (SingleArticleViewCell*)[tableView dequeueReusableCellWithIdentifier:SingleArticleViewIdentifier forIndexPath:indexPath];
        cell.article = self.article;
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
//        CGSize size1 = [self.article.title boundingRectWithSize:CGSizeMake(self.tableView.frame.size.width - 16, 1000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: font, NSParagraphStyleAttributeName: paragraphStyle} context:nil].size;
//        
//        returnHeight = size1.height  + 16;
        returnHeight=88;
    }
   else {
        
        Article *article = self.article;
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        CGSize size = [article.content boundingRectWithSize:CGSizeMake(self.tableView.frame.size.width -32, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font,NSParagraphStyleAttributeName: paragraphStyle} context:nil].size;
        paragraphStyle = nil;
        returnHeight = size.height+50;
        
        if (article.attachment.attachedFiles != nil) {
            returnHeight += (240 * [article.attachment.attachedFiles count]);
        }
       
      // returnHeight = 2000;
    }
    return returnHeight;
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

-(void)loadData{
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSString *urlPath = [NSString stringWithFormat:@"article/%@/%@.json?%@",self.article.board_name, self.article.ID, APIKEY];
    
    [[NetworkManager sharedManager] loadDataFromURL:urlPath
                                 withSuccessHandler:^(id responseObject) {
        NSDictionary *articleDict = responseObject;
        
        NSError *error;
        self.article = [[Article alloc] initWithDictionary:articleDict error:&error];
        if (error) {
            [SVProgressHUD showErrorWithStatus:@"parse refer error"];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    }
                                     failureHandler:nil];
    
}

#pragma mark - SingleArticleViewCellDelegate
-(void)attachmentImageViewTappedInArticleCell:(SingleArticleViewCell *)articleCell imageIndex:(NSInteger)index{
    
    AttachmentImageView *attachmentImageView = articleCell.attachmentsViewArray[index];
    
    NYTPhotosViewController *photoViewController = [[NYTPhotosViewController alloc] initWithPhotos:articleCell.attachmentsViewArray initialPhoto:attachmentImageView];
    photoViewController.delegate = self;
    [self presentViewController:photoViewController animated:YES completion:nil];
}

- (IBAction)unfoldRelatedThread:(id)sender {
    Thread *thread = [[Thread alloc] init];
    thread.board_name = self.article.board_name;
    thread.ID = self.article.group_id;
    ThreadTableViewController *threadTableViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ThreadTableViewController"];
    threadTableViewController.thread = thread;
    
    [self.navigationController pushViewController:threadTableViewController animated:YES];
    
}


@end
