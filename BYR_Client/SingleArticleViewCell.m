//
//  SingleArticleViewCell.m
//  BYR_Client
//
//  Created by Ying on 5/9/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import "SingleArticleViewCell.h"
#import "Utilities.h"

@implementation SingleArticleViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setArticle:(Article *)article
{
    if (_article != article) {
        _article=article;
        [_useridButton setTitle:article.author.ID forState:UIControlStateNormal];
        _postTimeLabel.text = [Utilities dateToString:[article.post_time intValue]];
        _contentLabel.text = article.content;
        [_userThumbnailImage sd_setImageWithURL:[NSURL URLWithString:article.author.face_url]];
    }
}

-(void)prepareDataToShow{
    self.attachmentsViewArray = [[NSMutableArray alloc] init];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    CGSize size = [_contentLabel.text boundingRectWithSize:CGSizeMake(self.frame.size.width -32, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font,NSParagraphStyleAttributeName: paragraphStyle} context:nil].size;
    
    for (NSInteger i = 0; i< [_article.attachment.attachedFiles count]; i++) {
        AttachmentImageView *attachmentImageView = [[AttachmentImageView alloc] initWithFrame:CGRectMake(16, i*240+_contentLabel.frame.origin.y+size.height,self.frame.size.width-32, 240)];
        NSString *urlString = [(NSString*)[_article.attachment.attachedFiles[i] url] stringByReplacingOccurrencesOfString:@"api.byr.cn/attachment" withString:@"bbs.byr.cn/att"];
        [attachmentImageView.imageView sd_setImageWithURL:[NSURL URLWithString:urlString]completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            attachmentImageView.image = image;
        }];
        attachmentImageView.delegate = self;
        [self addSubview:attachmentImageView];
        [self.attachmentsViewArray addObject:attachmentImageView];
    }
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark -AttachmentImageViewDelegate
-(void)attachmentImageViewTapped:(NSInteger)index{
    
    [_delegate attachmentImageViewTappedInArticleCell:self imageIndex:index];
    
}


-(void)prepareForReuse{
    for (AttachmentImageView *attachmentImageView in self.attachmentsViewArray) {
        [attachmentImageView removeFromSuperview];
    }
    //self.attachmentsViewArray = nil;
}
- (IBAction)replyPost:(id)sender {
    
    [self.delegate replyPostInArticleCell:self];
}

@end
