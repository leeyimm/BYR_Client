//
//  AttachmentImageView.h
//  BYR_Client
//
//  Created by Ying on 5/6/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIImageView+WebCache.h"
#import "NYTPhoto.h"

@protocol AttachmentImageViewDelegate <NSObject>

-(void)attachmentImageViewTapped:(NSInteger)index;

@end

@interface AttachmentImageView : UIView <NYTPhoto>

@property (nonatomic, assign) NSInteger index;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *nameLabel;

@property (nonatomic, weak) id<AttachmentImageViewDelegate> delegate;

@property (nonatomic) UIImage *image;
@property (nonatomic) UIImage *placeholderImage;
@property (nonatomic) NSAttributedString *attributedCaptionTitle;
@property (nonatomic) NSAttributedString *attributedCaptionSummary;
@property (nonatomic) NSAttributedString *attributedCaptionCredit;

@end
