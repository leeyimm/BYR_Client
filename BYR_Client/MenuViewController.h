//
//  MenuViewController.h
//  BYR_Client
//
//  Created by Ying on 4/8/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuViewController : UIViewController

@property (nonatomic) id<UIViewControllerTransitioningDelegate> transitioningDelegate;

- (void)refreshMenu;

@end
