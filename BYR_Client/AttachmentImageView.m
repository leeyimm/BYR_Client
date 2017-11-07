//
//  AttachmentImageView.m
//  BYR_Client
//
//  Created by Ying on 5/6/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import "AttachmentImageView.h"

@implementation AttachmentImageView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [_imageView setContentMode:UIViewContentModeScaleAspectFit];
        [_imageView setClipsToBounds:YES];
        [self addSubview:_imageView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height-40, frame.size.width, 20)];
        [_nameLabel setTextAlignment:NSTextAlignmentCenter];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_nameLabel];
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)];
        [self addGestureRecognizer:recognizer];
        recognizer = nil;
    }
    
    return self;
    
}

-(void)tapped
{
    [_delegate attachmentImageViewTapped:_index];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
