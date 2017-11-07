//
//  RootViewController.h
//  Menu
//
//  Created by Ying on 5/12/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"
#import "ScreenEdgePanGestureInteractiveTransition.h"

@class  RootViewController;

@protocol RootViewControllerDelegate <NSObject>

@optional
- (id <UIViewControllerAnimatedTransitioning>)containerViewController:(RootViewController *)containerViewController animationControllerForTransitionFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController;

@end


@interface UIViewController (RootAdditions)
@property (nonatomic, readonly) RootViewController *rootController;
@end




@interface RootViewController : UIViewController

@property (nonatomic, strong) MenuViewController *menuViewController;
@property (nonatomic, strong) UINavigationController *frontNavController;
@property (nonatomic, strong, readonly) UIView *dimmView;
@property (nonatomic, weak) UIView *transitionView;

-(void)resetFrontNavController:(UINavigationController *)frontNavController;
-(void)transitionToViewController:(UIViewController*)toViewController;

@property (nonatomic, weak) id<RootViewControllerDelegate> delegate;

@property (nonatomic, strong) ScreenEdgePanGestureInteractiveTransition *defaultInteractionController; 

@end
