//
//  BYRMenuTransitionContext.m
//  Menu
//
//  Created by Ying on 5/13/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import "BYRMenuTransitionContext.h"



@interface BYRMenuTransitionContext ()

@property (nonatomic, strong) NSDictionary *privateViewControllers;
@property (nonatomic, strong) NSDictionary *privateViews;
@property (nonatomic, assign) CGRect privateDisappearingFromRect;
@property (nonatomic, assign) CGRect privateAppearingFromRect;
@property (nonatomic, assign) CGRect privateDisappearingToRect;
@property (nonatomic, assign) CGRect privateAppearingToRect;
@property (nonatomic, weak) UIView *containerView;
@property (nonatomic, assign) UIModalPresentationStyle presentationStyle;

@property (nonatomic, assign) BOOL transitionWasCancelled;

@end

@implementation BYRMenuTransitionContext

- (instancetype)initWithFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController toMenu:(BOOL)toMenu {
    NSAssert ([fromViewController isViewLoaded] && fromViewController.view.superview, @"The fromViewController view must reside in the container view upon initializing the transition context.");
    
    if ((self = [super init])) {
        self.presentationStyle = UIModalPresentationCustom;
        self.containerView = fromViewController.view.superview;
        _transitionWasCancelled = NO;

        self.privateViewControllers = @{
                                        UITransitionContextFromViewControllerKey:fromViewController,
                                        UITransitionContextToViewControllerKey:toViewController,
                                        };
        
        self.privateViews = @{
                                        UITransitionContextFromViewKey:fromViewController.view,
                                        UITransitionContextToViewKey:toViewController.view,
                                        };
        
        // Set the view frame properties which make sense in our specialized ContainerViewController context. Views appear from and disappear to the sides, corresponding to where the icon buttons are positioned. So tapping a button to the right of the currently selected, makes the view disappear to the left and the new view appear from the right. The animator object can choose to use this to determine whether the transition should be going left to right, or right to left, for example.
        
        CGFloat travelDistance = self.containerView.bounds.size.width*ScaleFactor;
        if (toMenu) {
            self.privateAppearingFromRect =  self.containerView.bounds;
            self.privateDisappearingFromRect = CGRectOffset (self.containerView.bounds, -travelDistance, 0);
            self.privateAppearingToRect = self.privateDisappearingToRect = CGRectMake(self.containerView.bounds.size.width*(1-ScaleFactor), 0, self.containerView.bounds.size.width*ScaleFactor, self.containerView.bounds.size.height);
        }else{
            self.privateDisappearingToRect = self.containerView.bounds;
            self.privateAppearingToRect = CGRectOffset (self.containerView.bounds, -travelDistance, 0);
            //self.privateAppearingToRect = toViewController.view.frame;
            self.privateAppearingFromRect =  self.privateDisappearingFromRect = CGRectMake(self.containerView.bounds.size.width*(1-ScaleFactor), 0, self.containerView.bounds.size.width*ScaleFactor, self.containerView.bounds.size.height);
        }
    }
    
    return self;
}

- (CGRect)initialFrameForViewController:(UIViewController *)viewController {
    if (viewController == [self viewControllerForKey:UITransitionContextFromViewControllerKey]) {
        return self.privateAppearingFromRect;
    } else {
        return self.privateAppearingToRect;
    }
}

- (CGRect)finalFrameForViewController:(UIViewController *)viewController {
    if (viewController == [self viewControllerForKey:UITransitionContextFromViewControllerKey]) {
        return self.privateDisappearingFromRect;
    } else {
        return self.privateDisappearingToRect;
    }
}

- (UIViewController *)viewControllerForKey:(NSString *)key {
    return self.privateViewControllers[key];
}

- (UIViewController *)viewForKey:(NSString *)key {
    return self.privateViews[key];
}

- (void)completeTransition:(BOOL)didComplete {
    if (self.completionBlock) {
        self.completionBlock (didComplete);
    }
}


- (void)updateInteractiveTransition:(CGFloat)percentComplete {}
- (void)finishInteractiveTransition {self.transitionWasCancelled = NO;}
- (void)cancelInteractiveTransition {self.transitionWasCancelled = YES;}

- (CGAffineTransform)targetTransform
{
    return CGAffineTransformIdentity;
}


@end
