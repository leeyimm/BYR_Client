//
//  HotTopicTableViewController.m
//  BYR_Client
//
//  Created by Ying on 4/9/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import "HotTopicTableViewController.h"
//#import "HotTopicSectionInfo.h"
#import "DataModel.h"
#import "Utilities.h"
#import "GeneralCell.h"
#import "RootViewController.h"
#import "NetworkManager.h"
#import "ThreadTableViewController.h"

static NSString *SectionHeaderViewIdentifier = @"SectionHeaderViewIdentifier";


@interface HotTopicTableViewController ()

//@property (nonatomic) NSMutableArray *sectionInfoArray;
@property (nonatomic) NSIndexPath *pinchedIndexPath;
@property (nonatomic) NSInteger openSectionIndex;
@property (nonatomic) CGFloat initialPinchHeight;
@property (nonatomic ,strong) NSArray *allWidgetSections;
@property (nonatomic, strong) NSMutableArray *hotTopicSections;


//@property (nonatomic) IBOutlet HotTopicSectionHeaderView *sectionHeaderView;

// use the uniformRowHeight property if the pinch gesture should change all row heights simultaneously
//@property (nonatomic) NSInteger uniformRowHeight;

@end

#pragma mark -

#define DEFAULT_ROW_HEIGHT 88
#define HEADER_HEIGHT 48

@implementation HotTopicTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _allWidgetSections = @[@{@"title" : @"今日十大", @"name" : @"topten"},
                         @{@"title" : @"热点活动", @"name" : @"recommend"},
                         @{@"title" : @"北邮校园", @"name" : @"section-1"},
                         @{@"title" : @"学术科技", @"name" : @"section-2"},
                         @{@"title" : @"信息社会", @"name" : @"section-3"},
                         @{@"title" : @"人文艺术", @"name" : @"section-4"},
                         @{@"title" : @"生活时尚", @"name" : @"section-5"},
                         @{@"title" : @"休闲娱乐", @"name" : @"section-6"},
                         @{@"title" : @"体育健身", @"name" : @"section-7"},
                         @{@"title" : @"游戏对战", @"name" : @"section-8"},
                         @{@"title" : @"乡亲乡爱", @"name" : @"section-9"},
                         ];
    
    // Set up default values.
    self.tableView.sectionHeaderHeight = HEADER_HEIGHT;

    //self.uniformRowHeight = DEFAULT_ROW_HEIGHT;
    
    self.tableView.estimatedRowHeight = 66.0;
    //self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.openSectionIndex = NSNotFound;
    
    UINib *sectionHeaderNib = [UINib nibWithNibName:@"HotTopicSectionHeaderView" bundle:nil];
    [self.tableView registerNib:sectionHeaderNib forHeaderFooterViewReuseIdentifier:SectionHeaderViewIdentifier];
    
    UINib *articleCellNib = [UINib nibWithNibName:@"GeneralCell" bundle:nil];
    [self.tableView registerNib:articleCellNib forCellReuseIdentifier:@"HotTopicCellIdentifier"];
    
    for (Widget *section in self.hotTopicSections) {
        [self loadDataForSection:section];
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [self.allWidgetSections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    Widget *hotTopicSection = (self.hotTopicSections)[section];
    NSInteger numArticlesInSection = [hotTopicSection.threads count];
    
    return [hotTopicSection.isOpen boolValue]? numArticlesInSection : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Widget *hotTopicSection = (self.hotTopicSections)[indexPath.section];
    
    GeneralCell *cell = (GeneralCell *)[tableView dequeueReusableCellWithIdentifier:@"HotTopicCellIdentifier"];
    Thread *hotTopic = hotTopicSection.threads[indexPath.row];
    cell.titleLabel.text = hotTopic.title;
    cell.leftLabel.text = hotTopic.author.ID;
    cell.middleLabel.text = [hotTopic.reply_count stringValue];
    cell.rightLabel.text = hotTopic.board_name;
    cell.data = hotTopic;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    HotTopicSectionHeaderView *sectionHeaderView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:SectionHeaderViewIdentifier];
    
    Widget *hotTopicSection = (self.hotTopicSections)[section];
    hotTopicSection.headerView = sectionHeaderView;
    
    sectionHeaderView.sectionTitleLabel.text = [self.allWidgetSections[section] objectForKey:@"title"];
    sectionHeaderView.section = section;
    sectionHeaderView.delegate = self;
    
    return sectionHeaderView;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    HotTopicSectionInfo *sectionInfo = (self.sectionInfoArray)[indexPath.section];
//    return [[sectionInfo objectInRowHeightsAtIndex:indexPath.row] floatValue];
    // Alternatively, return rowHeight.
//}


#pragma mark - SectionHeaderViewDelegate

- (void)sectionHeaderView:(HotTopicSectionHeaderView *)sectionHeaderView sectionOpened:(NSInteger)sectionOpened {
    
    
    Widget *section = (self.hotTopicSections)[sectionOpened];
    section.isOpen = [NSNumber numberWithBool:YES];
    
    [self loadDataForSection:section];
    /*
     Create an array containing the index paths of the rows to insert: These correspond to the rows for each quotation in the current section.
     */
    NSInteger countOfRowsToInsert = [section.threads count];
    NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < countOfRowsToInsert; i++) {
        [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:sectionOpened]];
    }
    /*
     Create an array containing the index paths of the rows to delete: These correspond to the rows for each quotation in the previously-open section, if there was one.
     */
    NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
    
    NSInteger previousOpenSectionIndex = self.openSectionIndex;
    if (previousOpenSectionIndex != NSNotFound) {
        
        Widget *previousOpenSection = (self.hotTopicSections)[previousOpenSectionIndex];
        previousOpenSection.isOpen = [NSNumber numberWithBool:NO];
        [previousOpenSection.headerView toggleOpenWithUserAction:NO];
        NSInteger countOfRowsToDelete = [previousOpenSection.threads count];
        for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:previousOpenSectionIndex]];
        }
    }
    
    // style the animation so that there's a smooth flow in either direction
    UITableViewRowAnimation insertAnimation;
    UITableViewRowAnimation deleteAnimation;
    if (previousOpenSectionIndex == NSNotFound || sectionOpened < previousOpenSectionIndex) {
        insertAnimation = UITableViewRowAnimationTop;
        deleteAnimation = UITableViewRowAnimationBottom;
    }
    else {
        insertAnimation = UITableViewRowAnimationBottom;
        deleteAnimation = UITableViewRowAnimationTop;
    }
    
    // apply the updates
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:insertAnimation];
    [self.tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:deleteAnimation];
    [self.tableView endUpdates];
    
    self.openSectionIndex = sectionOpened;
}

- (void)sectionHeaderView:(HotTopicSectionHeaderView *)sectionHeaderView sectionClosed:(NSInteger)sectionClosed {
    
    /*
     Create an array of the index paths of the rows in the section that was closed, then delete those rows from the table view.
     */
    Widget *section = (self.hotTopicSections)[sectionClosed];
    
    section.isOpen = [NSNumber numberWithBool:NO];
    NSInteger countOfRowsToDelete = [self.tableView numberOfRowsInSection:sectionClosed];
    
    if (countOfRowsToDelete > 0) {
        NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:sectionClosed]];
        }
        [self.tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationTop];
    }
    self.openSectionIndex = NSNotFound;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Widget *selectedSection = (self.hotTopicSections)[indexPath.section];
    
    Thread *selectedThread = [selectedSection.threads objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:@"ShowHotTopicDetail" sender:selectedThread];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"ShowHotTopicDetail"])
    {
        ThreadTableViewController *threadTableViewController = (ThreadTableViewController*)segue.destinationViewController;
        threadTableViewController.thread = sender;
        
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark -


- (NSMutableArray *)hotTopicSections{
    if (_hotTopicSections ==nil) {
        _hotTopicSections = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in self.allWidgetSections) {
            Widget *widgetSection = [[Widget alloc] init];
            widgetSection.title = [dict objectForKey:@"title"];
            widgetSection.name = [dict objectForKey:@"name"];
            [_hotTopicSections addObject:widgetSection];
        }
    }
    return _hotTopicSections;
}

- (void)loadDataForSection: (Widget *)WidgetSection{
    
    //[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSString *urlPath = [NSString stringWithFormat:@"widget/%@.json?%@",WidgetSection.name, APIKEY];
    /*
     NSURLSessionDataTask *task = [[NetworkManager sharedManager] GET:urlPath parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSDictionary *hotTopicSectionDict = responseObject;
        
        NSError *error;
        Widget *widget = [[Widget alloc] initWithDictionary:hotTopicSectionDict error:&error];
        if (error) {
            NSLog(@"parse hot topic error: %@",error.localizedDescription);
        }else{
            WidgetSection.threads = widget.threads;
            widget = nil;
        }
        if (WidgetSection.isOpen) {
            NSInteger countOfRowsToReload = [WidgetSection.threads count];
            NSMutableArray *indexPathsToReload = [[NSMutableArray alloc] init];
            for (NSInteger i = 0; i < countOfRowsToReload; i++) {
                [indexPathsToReload addObject:[NSIndexPath indexPathForRow:i inSection:[self.hotTopicSections indexOfObject:WidgetSection]]];
            }
            
            [self.tableView reloadRowsAtIndexPaths:indexPathsToReload withRowAnimation:NO];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"error is %@", error);
    }];*/
    
    [[NetworkManager sharedManager] loadDataFromURL:urlPath withSuccessHandler:^(id responseObject) {
        NSDictionary *hotTopicSectionDict = responseObject;
        NSError *error;
        Widget *widget = [[Widget alloc] initWithDictionary:hotTopicSectionDict error:&error];
        if (error) {
            [SVProgressHUD showErrorWithStatus:@"parse hottopic error"];
            //NSLog(@"parse hot topic error: %@",error.localizedDescription);
        }else{
            WidgetSection.threads = widget.threads;
            widget = nil;
        }
        if (WidgetSection.isOpen) {
            NSInteger countOfRowsToReload = [WidgetSection.threads count];
            NSMutableArray *indexPathsToReload = [[NSMutableArray alloc] init];
            for (NSInteger i = 0; i < countOfRowsToReload; i++) {
                [indexPathsToReload addObject:[NSIndexPath indexPathForRow:i inSection:[self.hotTopicSections indexOfObject:WidgetSection]]];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadRowsAtIndexPaths:indexPathsToReload withRowAnimation:NO];
            });
        }
    }
     failureHandler:nil];
}

- (IBAction)menuButtonTapped:(id)sender {
    
    [self.rootController  transitionToViewController:self.rootController.menuViewController];
}


@end
