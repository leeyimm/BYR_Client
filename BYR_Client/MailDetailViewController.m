//
//  MailDetailViewController.m
//  BYR_Client
//
//  Created by Ying on 5/26/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import "MailDetailViewController.h"
#import "Utilities.h"
#import "NetworkManager.h"
#import "MailComposeViewController.h"

@interface MailDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *userIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *networkIndicator;

@end

@implementation MailDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _userIDLabel.text = _mail.user.ID;
    
    _titleLabel.text = _mail.title;
    _timeLabel.text = [Utilities dateToString:[_mail.post_time intValue]];
    _contentTextView.text = _mail.content;
    
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.title = self.mailType;
    
    [self loadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ReplyMailSegue"])
    {
        MailComposeViewController *mailComposeViewController = (MailComposeViewController*)segue.destinationViewController;
        mailComposeViewController.mail = self.mail;
        mailComposeViewController.mailType = self.mailType;
        
    }
}


-(void)loadData{
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self.networkIndicator startAnimating];
    
    NSString *urlPath = [NSString stringWithFormat:@"mail/%@/%@.json?%@",self.mailType,self.mail.index, APIKEY];
    
    [[NetworkManager sharedManager] loadDataFromURL:urlPath
                                 withSuccessHandler:^(id responseObject) {
                                     NSDictionary *mailDict = responseObject;
                                     
                                     NSError *error;
                                     self.mail = [[Mail alloc] initWithDictionary:mailDict error:&error];
                                     if (error) {
                                         [SVProgressHUD showErrorWithStatus:@"parse refer error"];
                                     }else{
                                         dispatch_async(dispatch_get_main_queue(), ^{
                                             
                                             NSString *trimmedString = [self.mail.content stringByTrimmingCharactersInSet:
                                                                        [NSCharacterSet whitespaceAndNewlineCharacterSet]];
                                             self.contentTextView.text = trimmedString;
                                             [self.networkIndicator stopAnimating];
                                             [self.networkIndicator removeFromSuperview];
                                         });
                                     }
                                 }
                                     failureHandler:nil];
    
}

@end





