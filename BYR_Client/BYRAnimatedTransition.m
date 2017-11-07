//
//  BYRAnimatedTransition.m
//  Menu
//
//  Created by Ying on 5/13/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import "BYRAnimatedTransition.h"
#import "MenuViewController.h"
#import "RootViewController.h"
#import "BYRMenuTransitionContext.h"

@implementation BYRAnimatedTransition

//static CGFloat const kChildViewPadding = 16;
//static CGFloat const kDamping = 0.75;
//static CGFloat const kInitialSpringVelocity = 0.5;

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.25;
}

/// Slide views horizontally, with a bit of space between, while fading out and in.
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController* toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController* fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    // When sliding the views horizontally in and out, figure out whether we are going left or right.
    //BOOL toMenu = [toViewController isKindOfClass:[BYRMenuViewController class]];
    //CGFloat travelDistance = [transitionContext containerView].bounds.size.width *2/3+ kChildViewPadding;
    //CGAffineTransform travel = CGAffineTransformMakeTranslation (goingRight ? travelDistance : -travelDistance, 0);
    toViewController.view.frame = [transitionContext initialFrameForViewController:toViewController];
    fromViewController.view.frame = [transitionContext initialFrameForViewController:fromViewController];
    CGRect finalToViewFrame = [transitionContext finalFrameForViewController:toViewController];
    CGRect finalFromViewFrame = [transitionContext finalFrameForViewController:fromViewController];

    
    UIView *dimmingView = toViewController.rootController.dimmView;
    
    if ([toViewController isKindOfClass:[MenuViewController class]]) {
        toViewController.view.alpha = 0.3;
        toViewController.view.transform = CGAffineTransformMakeScale(0.89, 0.85);
        dimmingView.frame=fromViewController.view.frame;
        dimmingView.backgroundColor = [UIColor whiteColor];
        dimmingView.userInteractionEnabled = NO;
        dimmingView.alpha=0.0;
        //[fromViewController.view addSubview:dimmingView];
        [[transitionContext containerView] addSubview:dimmingView];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                              delay:0
         //usingSpringWithDamping:kDamping
         //initialSpringVelocity:kInitialSpringVelocity
                            options:0x00
                         animations:^{
                             //toViewController.view.frame = finalToViewFrame;
                             fromViewController.view.frame = finalFromViewFrame;
                             dimmingView.frame = finalFromViewFrame;
                             toViewController.view.transform = CGAffineTransformMakeScale(1, 1);
                             //fromViewController.view.transform = travel;
                             //fromViewController.view.alpha = 0;
                             dimmingView.alpha = 0.6;
                             
                             dimmingView.layer.shadowRadius = 4;
                             dimmingView.layer.shadowOpacity = 0.7;
                             dimmingView.layer.shadowOffset = CGSizeZero;
                             //
                             toViewController.view.alpha = 1;
                         } completion:^(BOOL finished) {
                             if ([transitionContext transitionWasCancelled]) {
                                 fromViewController.view.frame = [transitionContext initialFrameForViewController:fromViewController];

                                 [dimmingView removeFromSuperview];
                             }else{
                                 dimmingView.userInteractionEnabled = YES;
                             }
                             
                             
                             [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                         }];
    }else{
        toViewController.rootController.transitionView.userInteractionEnabled = NO;
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                              delay:0
         //usingSpringWithDamping:kDamping
         //initialSpringVelocity:kInitialSpringVelocity
                            options:0x00
                         animations:^{
                             toViewController.view.frame = finalToViewFrame;
                             //fromViewController.view.frame = finalFromViewFrame;
                             fromViewController.view.transform = CGAffineTransformMakeScale(0.89, 0.85);
                             //fromViewController.view.transform = travel;
                             fromViewController.view.alpha = 0.2;
                             dimmingView.frame = finalToViewFrame;
                             dimmingView.alpha = 0.0;
                             //
                             //toViewController.view.alpha = 1;
                         } completion:^(BOOL finished) {
                             //toViewController.view.transform = CGAffineTransformMakeScale(1, 1);
                             fromViewController.view.transform = CGAffineTransformMakeScale(1, 1);
                             [dimmingView removeFromSuperview];
                             toViewController.rootController.transitionView.userInteractionEnabled = YES;
                             [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                         }];
        
    }
    
    //[[transitionContext containerView] addSubview:toViewController.view];
    
}

@end
