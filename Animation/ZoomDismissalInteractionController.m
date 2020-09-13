//
//  ZoomDismissalInteractionController.m
//  PhotoViewerOBJC
//
//  Created by Somoy Das Gupta on 15/3/20.
//  Copyright © 2020 Somoy Das Gupta. All rights reserved.
//

#import "ZoomDismissalInteractionController.h"

@interface ZoomDismissalInteractionController ()<UIViewControllerInteractiveTransitioning>

@end

@implementation ZoomDismissalInteractionController

- (void)didPanWithGestureRecognizer:(UIPanGestureRecognizer*)gestureRecognizer {
    
    if (self.transitionContext == nil)
        return;
    
    id<UIViewControllerContextTransitioning> transitionContext = self.transitionContext;
    
    if (![self.animator isKindOfClass:[ZoomAnimator class]])
        return;
        
    ZoomAnimator *animator = (ZoomAnimator*)self.animator;
    
    if (animator.transitionImageView == nil)
        return;
    
    UIImageView *transitionImageView = animator.transitionImageView;
    
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    if (!fromVC || !toVC) {
        return;
    }
    
    UIImageView *fromReferenceImageView;
    if ([animator.fromDelegate respondsToSelector:@selector(referenceImageViewForZoomAnimator:)]) {
        fromReferenceImageView = [animator.fromDelegate referenceImageViewForZoomAnimator:animator];
    }
    
    UIImageView *toReferenceImageView;
    if ([animator.toDelegate respondsToSelector:@selector(referenceImageViewForZoomAnimator:)]) {
        toReferenceImageView = [animator.toDelegate referenceImageViewForZoomAnimator:animator];
    }
    
    if (!fromReferenceImageView || !toReferenceImageView) {
        return;
    }
    
    CGRect fromReferenceImageViewFrame = CGRectNull;
    if ([animator.fromDelegate respondsToSelector:@selector(referenceImageViewFrameInTransitioningViewForZoomAnimator:)]) {
        fromReferenceImageViewFrame = [animator.fromDelegate referenceImageViewFrameInTransitioningViewForZoomAnimator:animator];
    }
    
    CGRect toReferenceImageViewFrame = CGRectNull;
    if ([animator.toDelegate respondsToSelector:@selector(referenceImageViewFrameInTransitioningViewForZoomAnimator:)]) {
        toReferenceImageViewFrame = [animator.toDelegate referenceImageViewFrameInTransitioningViewForZoomAnimator:animator];
    }
    
    if (CGRectIsNull(fromReferenceImageViewFrame) || CGRectIsNull(toReferenceImageViewFrame)) {
        return;
    }
    
    fromReferenceImageView.hidden = true;
    
    CGPoint anchorPoint = CGPointMake(CGRectGetMidX(fromReferenceImageViewFrame), CGRectGetMidY(fromReferenceImageViewFrame));
    CGPoint translatedPoint = [gestureRecognizer translationInView:fromReferenceImageView];
    CGFloat verticalDelta = translatedPoint.y < 0 ? 0 : translatedPoint.y;

    CGFloat backgroundAlpha = [self backgroundAlphaForView:fromVC.view withPanningVerticalDelta:verticalDelta];
    CGFloat scale = [self scaleForView:fromVC.view withPanningVerticalDelta:verticalDelta];
    
    fromVC.view.alpha = backgroundAlpha;
    
    transitionImageView.transform = CGAffineTransformMakeScale(scale, scale);
    CGPoint newCenter = CGPointMake(anchorPoint.x + translatedPoint.x, anchorPoint.y + translatedPoint.y - transitionImageView.frame.size.height * (1 - scale) / 2.0);
    transitionImageView.center = newCenter;
    
    toReferenceImageView.hidden = true;
    
    [transitionContext updateInteractiveTransition:(1 - scale)];
    
    if (toVC.tabBarController)
        toVC.tabBarController.tabBar.alpha = 1 - backgroundAlpha;
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        
        CGPoint velocity = [gestureRecognizer velocityInView:fromVC.view];
        
        if (velocity.y < 0 || newCenter.y < anchorPoint.y) {
            
            //cancel
            [UIView animateWithDuration:0.5
                                  delay:0
                 usingSpringWithDamping:0.9
                  initialSpringVelocity:0
                                options:UIViewAnimationOptionTransitionNone
                             animations:^{
                
                                transitionImageView.frame = fromReferenceImageViewFrame;
                                fromVC.view.alpha = 1.0;
                                
                                if (toVC.tabBarController)
                                    toVC.tabBarController.tabBar.alpha = 0;
            }
                             completion:^(BOOL finished) {
                
                                toReferenceImageView.hidden = false;
                                fromReferenceImageView.hidden = false;
                                [transitionImageView removeFromSuperview];
                                animator.transitionImageView = nil;
                                [transitionContext cancelInteractiveTransition];
                                [transitionContext completeTransition:!(transitionContext.transitionWasCancelled)];
                                [animator.toDelegate transitionDidEndWith:animator];
                                [animator.fromDelegate transitionDidEndWith:animator];
                                self.transitionContext = nil;
            }];
            
            return;
        }
        
        //start animation
        CGRect finalTransitionSize = toReferenceImageViewFrame;
        
        [UIView animateWithDuration:0.25
                              delay:0
                            options:UIViewAnimationOptionTransitionNone
                         animations:^{
            
                            fromVC.view.alpha = 0;
                            transitionImageView.frame = finalTransitionSize;
                            
                            if (toVC.tabBarController)
                                toVC.tabBarController.tabBar.alpha = 1;
        }
                         completion:^(BOOL finished) {
            
                            [transitionImageView removeFromSuperview];
                            toReferenceImageView.hidden = false;
                            fromReferenceImageView.hidden = false;
                            
                            [self.transitionContext finishInteractiveTransition];
                            [transitionContext completeTransition:!(transitionContext.transitionWasCancelled)];
                            [animator.toDelegate transitionDidEndWith: animator];
                            [animator.fromDelegate transitionDidEndWith: animator];
                            self.transitionContext = nil;
        }];
    }
}

- (CGFloat)backgroundAlphaForView:(UIView*)view withPanningVerticalDelta:(CGFloat)verticalDelta {
    CGFloat startingAlpha = 1.0;
    CGFloat finalAlpha = 0.5;
    CGFloat totalAvailableScale = startingAlpha - finalAlpha;
    
    CGFloat maximumDelta = view.bounds.size.height / 2.0;
    CGFloat deltaAsPercentageOfMaximun = MIN(((fabs(verticalDelta)) / maximumDelta), 1.0);
    
    return startingAlpha - (deltaAsPercentageOfMaximun * totalAvailableScale);
}

- (CGFloat)scaleForView:(UIView*)view withPanningVerticalDelta:(CGFloat)verticalDelta {
    CGFloat startingScale = 1.0;
    CGFloat finalScale = 0.5;
    CGFloat totalAvailableScale = startingScale - finalScale;
    
    CGFloat maximumDelta = view.bounds.size.height / 2.0;
    CGFloat deltaAsPercentageOfMaximun = MIN(((fabs(verticalDelta)) / maximumDelta), 1.0);
    
    return startingScale - (deltaAsPercentageOfMaximun * totalAvailableScale);
}

//MARK:- UIViewControllerInteractiveTransitioning
- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    self.transitionContext = transitionContext;
    
    UIView *containerView = transitionContext.containerView;
    
    if (![self.animator isKindOfClass:[ZoomAnimator class]])
        return;
        
    ZoomAnimator *animator = (ZoomAnimator*)self.animator;
    
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    if (!fromVC || !toVC) {
        return;
    }
    
    UIImageView *fromReferenceImageView;
    if ([animator.fromDelegate respondsToSelector:@selector(referenceImageViewForZoomAnimator:)]) {
        fromReferenceImageView = [animator.fromDelegate referenceImageViewForZoomAnimator:animator];
    }
    
    if (!fromReferenceImageView) {
        return;
    }
    
    CGRect fromReferenceImageViewFrame = CGRectNull;
    if ([animator.fromDelegate respondsToSelector:@selector(referenceImageViewFrameInTransitioningViewForZoomAnimator:)]) {
        fromReferenceImageViewFrame = [animator.fromDelegate referenceImageViewFrameInTransitioningViewForZoomAnimator:animator];
    }
    
    CGRect toReferenceImageViewFrame = CGRectNull;
    if ([animator.toDelegate respondsToSelector:@selector(referenceImageViewFrameInTransitioningViewForZoomAnimator:)]) {
        toReferenceImageViewFrame = [animator.toDelegate referenceImageViewFrameInTransitioningViewForZoomAnimator:animator];
    }
    
    if (CGRectIsNull(fromReferenceImageViewFrame) || CGRectIsNull(toReferenceImageViewFrame)) {
        return;
    }
    
    [animator.fromDelegate transitionWillStartWith:animator];
    [animator.toDelegate transitionWillStartWith:animator];
    
    self.fromReferenceImageViewFrame = fromReferenceImageViewFrame;
    self.toReferenceImageViewFrame = toReferenceImageViewFrame;
    
    UIImage *referenceImage = fromReferenceImageView.image;
    
    [containerView insertSubview:toVC.view belowSubview:fromVC.view];
    
    if (animator.transitionImageView == nil) {
        UIImageView *transitionImageView = [[UIImageView alloc] initWithImage:referenceImage];
        transitionImageView.contentMode = UIViewContentModeScaleAspectFill;
        transitionImageView.clipsToBounds = true;
        transitionImageView.frame = fromReferenceImageViewFrame;
        animator.transitionImageView = transitionImageView;
        
        [containerView addSubview:transitionImageView];
    }
}

@end
