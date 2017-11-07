//
//  MailComposeViewController.m
//  BYR_Client
//
//  Created by Ying on 5/26/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import "MailComposeViewController.h"
#import "NetworkManager.h"

@interface MailComposeViewController ()

@property  (assign) SendMailType sendMailType;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *userIDTextField;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

@end

@implementation MailComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.mail) {
        _titleTextField.text = self.mail.title;
        _userIDTextField.text = self.mail.user.ID;
        _contentTextView.text = self.mail.content;
        [_contentTextView becomeFirstResponder];
        
    }else{
        [_titleTextField becomeFirstResponder];
    }
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
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)sendMail:(id)sender {
    
    if (![self.titleTextField.text length]||![self.userIDTextField.text length]) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Alert Alert"
                                                                       message:@"Title and UserID could not be empty."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        
        NSMutableString *postUrl = [NSMutableString stringWithFormat:@"%@mail/",BYRAPIURL];
        switch (self.sendMailType) {
            case NEW_MAIL:
                [postUrl appendFormat:@"send.json?%@", APIKEY];
                break;
            case REPLY_MAIL:
                [postUrl appendFormat:@"%@/reply/%@.json?%@",self.mailType,self.mail.index,APIKEY];
                break;
            default:
                break;
        }
        
        [[NetworkManager sharedManager] POST:postUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
            if (self.sendMailType == NEW_MAIL) {
                NSData *useridData = [self.userIDTextField.text dataUsingEncoding:NSUTF8StringEncoding];
                [formData appendPartWithFormData:useridData name:@"id"];
            }else if(self.sendMailType == REPLY_MAIL){
                NSData *mailTypeData = [self.mailType dataUsingEncoding:NSUTF8StringEncoding];
                [formData appendPartWithFormData:mailTypeData  name:@"box"];
                
                NSData *numData = [[self.mail.index stringValue] dataUsingEncoding:NSUTF8StringEncoding];
                [formData appendPartWithFormData:numData  name:@"num"];
            }
            
            NSData *titleData = [self.titleTextField.text dataUsingEncoding:NSUTF8StringEncoding];
            [formData appendPartWithFormData:titleData name:@"title"];
            NSData *contentData = [self.contentTextView.text dataUsingEncoding:NSUTF8StringEncoding];
            [formData appendPartWithFormData:contentData name:@"content"];
            NSData *backupData = [[[NSNumber numberWithInt:1] stringValue] dataUsingEncoding:NSUTF8StringEncoding];
            [formData appendPartWithFormData:backupData name:@"backup"];
        }
                                     success:^(NSURLSessionDataTask *task, id responseObject) {
                                         NSDictionary *responseDict = responseObject;
                                         
                                         NSError *error;
                                         Mail  *mail = [[Mail alloc] initWithDictionary:responseDict error:&error];
                                         if (error&&![responseDict valueForKey:@"status"]) {
                                             if ([responseDict valueForKey:@"msg"]) {
                                                 [SVProgressHUD showErrorWithStatus:[responseDict valueForKey:@"msg"]];
                                             }else{
                                                 [SVProgressHUD showErrorWithStatus:@"send post error"];
                                             }
                                         }else{
                                             [SVProgressHUD showSuccessWithStatus:@"success"];
                                             [self.navigationController popViewControllerAnimated:YES];
                                         }
                                         
                                     }
                                     failure:^(NSURLSessionDataTask *task, NSError *error) {
                                         NSLog(@"%@",error);
                                     }];
        
    }
}



@end
