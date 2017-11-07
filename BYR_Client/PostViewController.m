//
//  PostViewController.m
//  BYR_Client
//
//  Created by Ying on 5/17/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import "PostViewController.h"
#import "NetworkManager.h"

@interface PostViewController ()
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

@end

@implementation PostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    switch (self.postType) {
        case REPLY_POST:
            self.titleField.text = [NSString stringWithFormat:@"Re: %@", _relatedArticle.title];
            self.contentTextView.text = [NSString stringWithFormat:@"\n%@", _relatedArticle.content];
            break;
        case UPDATE_POST:
            self.titleField.text = [NSString stringWithFormat:@"%@", _relatedArticle.title];
            self.contentTextView.text = [NSString stringWithFormat:@"%@", _relatedArticle.content];
        default:
            break;
    }
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.titleField becomeFirstResponder];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)send:(id)sender {
    if (![self.titleField.text length]||![self.contentTextView.text length]) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"My Alert"
                                                                       message:@"Title or content could not be empty."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        
        NSMutableString *postUrl = [NSMutableString stringWithFormat:@"%@article/",BYRAPIURL];
        switch (self.postType) {
            case NEW_POST:
                [postUrl appendFormat:@"%@/post.json?%@",self.boardName, APIKEY];
                break;
            case REPLY_POST:
                [postUrl appendFormat:@"%@/post.json?%@",_relatedArticle.board_name, APIKEY];
                break;
            case UPDATE_POST:
                [postUrl appendFormat:@"%@/update/%@.json?%@",_relatedArticle.board_name,[_relatedArticle.ID stringValue],APIKEY];
            default:
                break;
        }
        
        [[NetworkManager sharedManager] POST:postUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
            if (self.postType == REPLY_POST) {
                NSString *reid = [_relatedArticle.ID stringValue];
                NSData *reidData = [reid dataUsingEncoding:NSUTF8StringEncoding];
                [formData appendPartWithFormData:reidData name:@"reid"];
            }
            //NSString *messageJSON = [NSString stringWithFormat:@"{title:%@}",self.titleField.text];
            NSData *titleData = [self.titleField.text dataUsingEncoding:NSUTF8StringEncoding];
            [formData appendPartWithFormData:titleData name:@"title"];
            NSData *contentData = [self.contentTextView.text dataUsingEncoding:NSUTF8StringEncoding];
            [formData appendPartWithFormData:contentData name:@"content"];
        }
                                     success:^(NSURLSessionDataTask *task, id responseObject) {
                                         NSDictionary *responseDict = responseObject;
                                         
                                         NSError *error;
                                         Article *article = [[Article alloc] initWithDictionary:responseDict error:&error];
                                         if (error) {
                                             [SVProgressHUD showErrorWithStatus:@"send post error"];
                                         }else{
                                             [SVProgressHUD showSuccessWithStatus:@"success"];
                                             [self dismissViewControllerAnimated:YES completion:nil];
                                         }
                                         
                                     }
                                     failure:^(NSURLSessionDataTask *task, NSError *error) {
                                         NSLog(@"%@",error);
                                     }];

    }
}
@end


