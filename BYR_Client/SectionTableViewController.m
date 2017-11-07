//
//  SectionTableViewController.m
//  BYR_Client
//
//  Created by Ying on 4/14/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import "SectionTableViewController.h"
#import "DataModel.h"
#import "DirectoryCell.h"
#import "Utilities.h"
#import "BoardTableViewController.h"
#import "NetworkManager.h"
#import "RootViewController.h"
#import "Root.h"

@interface SectionTableViewController ()

@property (nonatomic, strong) Root *root;

@end

@implementation SectionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    UINib *articleCellNib = [UINib nibWithNibName:@"DirectoryCell" bundle:nil];
    [self.tableView registerNib:articleCellNib forCellReuseIdentifier:@"DirectoryCellIdentifier"];
    
    [self loadData];
    
    if (_hasParent) {
        self.navigationItem.rightBarButtonItem = nil;
    }
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
    NSInteger rows = 0;
    if (self.hasParent) {
        rows = [self.section.sub_sections count] + [self.section.boards count];
    }else{
        rows = [self.root.section_count integerValue];
    }
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //static NSString *sectionCellIdentifier = @"SectionCellIdentifier";
    
    DirectoryCell *cell = (DirectoryCell *)[tableView dequeueReusableCellWithIdentifier:@"DirectoryCellIdentifier" forIndexPath:indexPath];
    if (self.hasParent) {
        if (indexPath.row<[self.section.sub_sections count]) {
            cell.titleLabel.text=self.section.sub_sections[indexPath.row];
            cell.subTitleLabel.text = @"Directory";
            Section *section = [[Section alloc] init];
            section.name = self.section.sub_sections[indexPath.row];
            cell.section = section;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else{
            Board *board = self.section.boards[indexPath.row - [self.section.sub_sections count]];
            cell.titleLabel.text=[board valueForKey:@"selfDescription"];
            cell.subTitleLabel.text = [board valueForKey:@"name"];
            //cell.board = board;
            cell.accessoryType = UITableViewCellAccessoryNone;
            
        }
    }else{
        cell.titleLabel.text=[self.root.sections[indexPath.row] valueForKey:@"selfDescription"];
        cell.subTitleLabel.text = [self.root.sections[indexPath.row] valueForKey:@"name"];
        cell.section = self.root.sections[indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DirectoryCell *sectionCell = (DirectoryCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (_hasParent) {
        if (sectionCell.section) {
            SectionTableViewController * subSectionViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SectionTableViewController"];
            subSectionViewController.section = sectionCell.section;
            subSectionViewController.hasParent = YES;
            [self.navigationController pushViewController:subSectionViewController animated:YES];
        }else{
            BoardTableViewController *boardTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"BoardTableViewController"];
            boardTableViewController.board = self.section.boards[indexPath.row - [self.section.sub_sections count]];;
            
            [self.navigationController pushViewController:boardTableViewController animated:YES];
        }
    }else{
        SectionTableViewController * sectionViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SectionTableViewController"];
        sectionViewController.section = self.root.sections[indexPath.row];
        sectionViewController.hasParent = YES;
        [self.navigationController pushViewController:sectionViewController animated:YES];
        
    }

        
}



/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/
-(BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    return NO;
}



#pragma mark - loadData

- (void)loadData {
    if (_hasParent == NO) {
        self.navigationItem.title = @"分区";
        
        [[NetworkManager sharedManager] loadDataFromURL:[NSString stringWithFormat:@"section.json?%@", APIKEY] withSuccessHandler:^(id responseObject) {
            NSDictionary *rooSectionDict = responseObject;
            
            NSError *error;
            self.root = [[Root alloc] initWithDictionary:rooSectionDict error:&error];
            if (error) {
                [SVProgressHUD showErrorWithStatus:@"parse root section error"];
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }
        }
         failureHandler:nil];
        
    }else{
        
        NSString *urlPath = [NSString stringWithFormat:@"section/%@.json?%@",self.section.name, APIKEY];
        
        [[NetworkManager sharedManager] loadDataFromURL:urlPath withSuccessHandler:^(id responseObject) {
            NSDictionary *sectionDict = responseObject;
            
            NSError *error;
            self.section = [[Section alloc] initWithDictionary:sectionDict error:&error];
            if (error) {
                [SVProgressHUD showErrorWithStatus:@"parse section error"];
            }else{
                self.navigationItem.title = self.section.selfDescription;
                [self.tableView reloadData];
            }
        }
         failureHandler:nil];
    }
}

- (IBAction)menuButtonTapped:(id)sender {
    
   [self.rootController  transitionToViewController:self.rootController.menuViewController];
}

@end
