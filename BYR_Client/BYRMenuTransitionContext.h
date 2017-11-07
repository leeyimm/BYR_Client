//
//  BYRMenuTransitionContext.h
//  Menu
//
//  Created by Ying on 5/13/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

static float ScaleFactor =11.0/15.0;

@interface BYRMenuTransitionContext : NSObject <UIViewControllerContextTransitioning>

- (instancetype)initWithFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController toMenu:(BOOL)toMenu;
/// Designated initializer.
@property (nonatomic, copy) void (^completionBlock)(BOOL didComplete);
/// A block of code we can set to execute after having received the completeTransition: message.
@property (nonatomic, assign, getter=isAnimated) BOOL animated;
/// Private setter for the animated property.
@property (nonatomic, assign, getter=isInteractive) BOOL interactive;
/// Private setter for the interactive property.
@end

