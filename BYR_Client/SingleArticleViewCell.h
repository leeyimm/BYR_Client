//
//  SingleArticleViewCell.h
//  BYR_Client
//
//  Created by Ying on 5/9/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article.h"
#import "AttachmentImageView.h"

@class SingleArticleViewCell;

@protocol SingleArticleViewCellDelegate <NSObject>

-(void)attachmentImageViewTappedInArticleCell:(SingleArticleViewCell *)commentCell imageIndex:(NSInteger)index;
-(void)replyPostInArticleCell:(SingleArticleViewCell *)commentCell;
-(void)sendMailInArticleCell:(SingleArticleViewCell *)commentCell;

@end

@interface SingleArticleViewCell : UITableViewCell <AttachmentImageViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *userThumbnailImage;
@property (weak, nonatomic) IBOutlet UIButton *useridButton;
@property (weak, nonatomic) IBOutlet UILabel *postTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (nonatomic, strong) Article *article;
@property (strong, nonatomic) NSMutableArray *attachmentsViewArray;
@property (strong, nonatomic) id<SingleArticleViewCellDelegate> delegate;

-(void)prepareDataToShow;

@end
