//
//  RootViewController.m
//  Menu
//
//  Created by Ying on 5/12/15.
//  Copyright (c) 2015 Ying. All rights reserved.
//

#import "RootViewController.h"
#import "BYRAnimatedTransition.h"
#import "BYRMenuTransitionContext.h"



@interface RootViewController () <RootViewControllerDelegate>


@property (nonatomic, strong) UIView *dimmView;

@end

@implementation RootViewController


-(void)resetFrontNavController:(UINavigationController *)frontNavController
{
    if (frontNavController == self.frontNavController) {
        return;
    }else{
        
        [self.frontNavController willMoveToParentViewController:nil];
        if ([self.frontNavController isViewLoaded] && [[self.frontNavController view] superview] == self.view) {
            [[self.frontNavController view] removeFromSuperview];
        }
        [self.frontNavController removeFromParentViewController];
        
        self.frontNavController = frontNavController;
        [self addChildViewController:self.frontNavController];
        [self.transitionView addSubview:self.frontNavController.view];
        [self.frontNavController didMoveToParentViewController:self];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *transitionView = [[UIView alloc] initWithFrame:[self.view bounds]];
    [transitionView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [transitionView setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:transitionView];
    
    [self setTransitionView:transitionView];
    
    __weak typeof(self) wself = self;
    self.defaultInteractionController = [[ScreenEdgePanGestureInteractiveTransition alloc] initWithGestureRecognizerInView:self.transitionView recognizedBlock:^(UIScreenEdgePanGestureRecognizer *recognizer) {
        
        [wself transitionToViewController:self.menuViewController];
    }];
    
    _dimmView = [[UIView alloc] init];
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [_dimmView addGestureRecognizer:panGestureRecognizer];
    [_dimmView addGestureRecognizer:tapGestureRecognizer];

    
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    
    if (!self.frontNavController) {
        
        self.menuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
        [self addChildViewController:self.menuViewController];
        self.menuViewController.view.frame = CGRectMake(self.transitionView.bounds.size.width*(1-ScaleFactor), 0, self.transitionView.bounds.size.width*ScaleFactor, self.transitionView.bounds.size.height);
        [self.transitionView addSubview:self.menuViewController.view];
        [self.menuViewController didMoveToParentViewController:self];
        
        
        self.frontNavController = [self.storyboard instantiateViewControllerWithIdentifier:@"HotTopicNavViewController"];
        //[self.frontNavController willMoveToParentViewController:self];
        [self addChildViewController:self.frontNavController];
        [self.transitionView addSubview:self.frontNavController.view];
        [self.frontNavController didMoveToParentViewController:self];
        
        //[self presentViewController:self.frontNavController animated:NO completion:nil];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)transitionToViewController:(UIViewController*)toViewController
{
    BOOL toMenu = [toViewController isKindOfClass:[MenuViewController class]];
    UIViewController *fromViewController = toMenu? self.frontNavController:self.menuViewController;
    
    UIView *toView = toViewController.view;
    [toView setTranslatesAutoresizingMaskIntoConstraints:YES];
    //toView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    //toView.frame = self.transitionView.bounds;
    
    //[fromViewController willMoveToParentViewController:nil];
    //[self addChildViewController:toViewController];
    
    id<UIViewControllerAnimatedTransitioning>animator = nil;
    if ([self.delegate respondsToSelector:@selector (containerViewController:animationControllerForTransitionFromViewController:toViewController:)]) {
        animator = [self.delegate containerViewController:self animationControllerForTransitionFromViewController:fromViewController toViewController:toViewController];
    }
    animator = (animator ?: [[BYRAnimatedTransition alloc] init]);
    
    BYRMenuTransitionContext *transitionContext = [[BYRMenuTransitionContext alloc] initWithFromViewController:fromViewController toViewController:toViewController toMenu:toMenu];
    
    transitionContext.animated = YES;
    
    id<UIViewControllerInteractiveTransitioning> interactionController = [self _interactionControllerForAnimator:animator];
    
    transitionContext.interactive = (interactionController != nil);
    transitionContext.completionBlock = ^(BOOL didComplete) {

        
        if ([animator respondsToSelector:@selector (animationEnded:)]) {
            [animator animationEnded:didComplete];
        }
    };
    
    if ([transitionContext isInteractive]) {
        [interactionController startInteractiveTransition:transitionContext];
    } else {
        [animator animateTransition:transitionContext];
    }
    
}

-(void)_finishTransitionToViewController:(UIViewController*)toViewController
{
    
}


-(void)pan:(UIPanGestureRecognizer *)panGestureRecognizer{
    
    CGFloat translationX  = [panGestureRecognizer translationInView:panGestureRecognizer.view].x;
    
    if (panGestureRecognizer.state >= UIGestureRecognizerStateEnded && translationX>0) {
        
        [self transitionToViewController:self.frontNavController];
    }
}


-(void)tap:(UITapGestureRecognizer *)tapGestureRecognizer{
    
    if (tapGestureRecognizer.state >= UIGestureRecognizerStateEnded) {
        
        [self transitionToViewController:self.frontNavController];
        
    }
    
}


- (id<UIViewControllerInteractiveTransitioning>)_interactionControllerForAnimator:(id<UIViewControllerAnimatedTransitioning>)animationController {
    
    if (self.defaultInteractionController.recognizer.state == UIGestureRecognizerStateBegan) {
        self.defaultInteractionController.animator = animationController;
        return self.defaultInteractionController;
    } else {
        return nil;
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

@implementation UIViewController (RootAdditions)

-(RootViewController *)rootController
{
    UIViewController *parent = [self parentViewController];
    while (parent) {
        if ([parent isKindOfClass:[RootViewController class]]) {
            return (RootViewController*)parent;
        }
        parent = [parent parentViewController];
    }
    return nil;
}

@end
