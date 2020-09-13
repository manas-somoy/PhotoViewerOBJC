//
//  ZoomTransitionController.m
//  PhotoViewerOBJC
//
//  Created by Somoy Das Gupta on 15/3/20.
//  Copyright © 2020 Somoy Das Gupta. All rights reserved.
//

#import "ZoomTransitionController.h"

@interface ZoomTransitionController () <UIViewControllerTransitioningDelegate, UINavigationControllerDelegate>

@end

@implementation ZoomTransitionController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.animator = [[ZoomAnimator alloc] init];
        self.interactionController = [[ZoomDismissalInteractionController alloc] init];
    }
    return self;
}

- (void)didPanWithGestureRecognizer:(UIPanGestureRecognizer*)gestureRecognizer {
    [self.interactionController didPanWithGestureRecognizer:gestureRecognizer];
}

//MARK:- UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    
    self.animator.isPresenting = true;
    self.animator.fromDelegate = self.fromDelegate;
    self.animator.toDelegate = self.toDelegate;
    return self.animator;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    
    self.animator.isPresenting = false;
    id<ZoomAnimatorDelegate> tmp = self.fromDelegate;
    self.animator.fromDelegate = self.toDelegate;
    self.animator.toDelegate = tmp;
    return self.animator;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    
    if (!self.isInteractive) {
        return nil;
    }
    
    self.interactionController.animator = animator;
    return self.interactionController;
}

//MARK:- UINavigationControllerDelegate
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    
    if (operation == UINavigationControllerOperationPush) {
        self.animator.isPresenting = true;
        self.animator.fromDelegate = self.fromDelegate;
        self.animator.toDelegate = self.toDelegate;
    } else {
        self.animator.isPresenting = false;
        id<ZoomAnimatorDelegate> tmp = self.fromDelegate;
        self.animator.fromDelegate = self.toDelegate;
        self.animator.toDelegate = tmp;
    }
    
    return self.animator;
}

@end
