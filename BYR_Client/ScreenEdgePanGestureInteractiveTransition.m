//
//  ScreenEdgePanGestureInteractiveTransition.m
//  Menu
//
//  Created by Ying on 5/15/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import "ScreenEdgePanGestureInteractiveTransition.h"

@implementation ScreenEdgePanGestureInteractiveTransition

- (id)initWithGestureRecognizerInView:(UIView *)view recognizedBlock:(void (^)(UIScreenEdgePanGestureRecognizer *recognizer))gestureRecognizedBlock {
    
    self = [super init];
    if (self) {
        _gestureRecognizedBlock = [gestureRecognizedBlock copy];
        _recognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        _recognizer.edges = UIRectEdgeRight;
        [view addGestureRecognizer:_recognizer];
    }
    return self;
}

- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    [super startInteractiveTransition:transitionContext];
}



- (void)pan:(UIScreenEdgePanGestureRecognizer*)recognizer {
    
    CGFloat translationX  = [recognizer translationInView:recognizer.view].x;
    CGFloat velocityX     = [recognizer velocityInView:recognizer.view].x;
    
    //NSLog(@"translationX: %f", translationX);
    //NSLog(@"velocutyX: %f",velocityX);
    ;
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.gestureRecognizedBlock(recognizer);
    }else if (recognizer.state == UIGestureRecognizerStateChanged) {
        //CGPoint translation = [recognizer translationInView:recognizer.view];
        CGFloat d = 0.0-translationX / CGRectGetWidth(recognizer.view.bounds) ;
        [self updateInteractiveTransition:d];
    } else if (recognizer.state >= UIGestureRecognizerStateEnded) {
        if (self.percentComplete > 0.2 && velocityX < 0) {
            [self finishInteractiveTransition];
        }else {
            [self cancelInteractiveTransition];
        }
    }
}

@end
