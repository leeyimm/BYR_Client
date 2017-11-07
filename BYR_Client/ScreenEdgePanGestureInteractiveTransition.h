//
//  ScreenEdgePanGestureInteractiveTransition.h
//  Menu
//
//  Created by Ying on 5/15/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AWPercentDrivenInteractiveTransition.h"

@interface ScreenEdgePanGestureInteractiveTransition : AWPercentDrivenInteractiveTransition
- (id)initWithGestureRecognizerInView:(UIView *)view recognizedBlock:(void (^)(UIScreenEdgePanGestureRecognizer *recognizer))gestureRecognizedBlock;

@property (nonatomic, readonly) UIScreenEdgePanGestureRecognizer *recognizer;
@property (nonatomic, copy) void (^gestureRecognizedBlock)(UIScreenEdgePanGestureRecognizer *recognizer);

@end
