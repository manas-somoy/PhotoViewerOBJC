//
//  ZoomAnimator.m
//  PhotoViewerOBJC
//
//  Created by Somoy Das Gupta on 15/3/20.
//  Copyright © 2020 Somoy Das Gupta. All rights reserved.
//

#import "ZoomAnimator.h"

@interface ZoomAnimator ()<UIViewControllerAnimatedTransitioning>

@end

@implementation ZoomAnimator

- (void)animateZoomInTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIView *containerView = transitionContext.containerView;
    
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    if (!fromVC || !toVC) {
        return;
    }
    
    UIImageView *fromReferenceImageView;
    if ([self.fromDelegate respondsToSelector:@selector(referenceImageViewForZoomAnimator:)]) {
        fromReferenceImageView = [self.fromDelegate referenceImageViewForZoomAnimator:self];
    }
    
    UIImageView *toReferenceImageView;
    if ([self.toDelegate respondsToSelector:@selector(referenceImageViewForZoomAnimator:)]) {
        toReferenceImageView = [self.toDelegate referenceImageViewForZoomAnimator:self];
    }
    
    if (!fromReferenceImageView || !toReferenceImageView) {
        return;
    }
    
    CGRect fromReferenceImageViewFrame = CGRectNull;
    if ([self.fromDelegate respondsToSelector:@selector(referenceImageViewFrameInTransitioningViewForZoomAnimator:)]) {
        fromReferenceImageViewFrame = [self.fromDelegate referenceImageViewFrameInTransitioningViewForZoomAnimator:self];
    }
    
    if (CGRectIsNull(fromReferenceImageViewFrame)) {
        return;
    }
    
    [self.fromDelegate transitionWillStartWith:self];
    [self.toDelegate transitionWillStartWith:self];
    
    toVC.view.alpha = 0.0;
    toReferenceImageView.hidden = true;
    [containerView addSubview:toVC.view];
    
    UIImage *referenceImage = fromReferenceImageView.image;
    
    if (self.transitionImageView == nil) {
        UIImageView *transitionImageView = [[UIImageView alloc] initWithImage:referenceImage];
        transitionImageView.contentMode = UIViewContentModeScaleAspectFill;
        transitionImageView.clipsToBounds = true;
        transitionImageView.frame = fromReferenceImageViewFrame;
        self.transitionImageView = transitionImageView;
        
        [containerView addSubview:transitionImageView];
    }
    
    fromReferenceImageView.hidden = true;
    
    CGRect finalTransitionSize = [self calculateZoomInImageFrame:referenceImage forView:toVC.view];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:0
                        options:UIViewAnimationOptionTransitionCrossDissolve
                     animations:^{
                                self.transitionImageView.frame = finalTransitionSize;
                                toVC.view.alpha = 1.0;
                                
                                if (fromVC.tabBarController)
                                    fromVC.tabBarController.tabBar.alpha = 0;
    }
                     completion:^(BOOL finished) {
        
        [self.transitionImageView removeFromSuperview];
        toReferenceImageView.hidden = false;
        fromReferenceImageView.hidden = false;
        
        self.transitionImageView = nil;
        
        [transitionContext completeTransition:!(transitionContext.transitionWasCancelled)];
        [self.toDelegate transitionDidEndWith:self];
        [self.fromDelegate transitionDidEndWith:self];
    }];
}

- (void)animateZoomOutTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIView *containerView = transitionContext.containerView;
    
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    if (!fromVC || !toVC) {
        return;
    }
    
    UIImageView *fromReferenceImageView;
    if ([self.fromDelegate respondsToSelector:@selector(referenceImageViewForZoomAnimator:)]) {
        fromReferenceImageView = [self.fromDelegate referenceImageViewForZoomAnimator:self];
    }
    
    UIImageView *toReferenceImageView;
    if ([self.toDelegate respondsToSelector:@selector(referenceImageViewForZoomAnimator:)]) {
        toReferenceImageView = [self.toDelegate referenceImageViewForZoomAnimator:self];
    }
    
    if (!fromReferenceImageView || !toReferenceImageView) {
        return;
    }
    
    CGRect fromReferenceImageViewFrame = CGRectNull;
    if ([self.fromDelegate respondsToSelector:@selector(referenceImageViewFrameInTransitioningViewForZoomAnimator:)]) {
        fromReferenceImageViewFrame = [self.fromDelegate referenceImageViewFrameInTransitioningViewForZoomAnimator:self];
    }
    
    CGRect toReferenceImageViewFrame = CGRectNull;
    if ([self.toDelegate respondsToSelector:@selector(referenceImageViewFrameInTransitioningViewForZoomAnimator:)]) {
        toReferenceImageViewFrame = [self.toDelegate referenceImageViewFrameInTransitioningViewForZoomAnimator:self];
    }
    
    if (CGRectIsNull(fromReferenceImageViewFrame) || CGRectIsNull(toReferenceImageViewFrame)) {
        return;
    }
    
    [self.fromDelegate transitionWillStartWith:self];
    [self.toDelegate transitionWillStartWith:self];
    
    toReferenceImageView.hidden = true;
    
    UIImage *referenceImage = fromReferenceImageView.image;
    
    if (self.transitionImageView == nil) {
        UIImageView *transitionImageView = [[UIImageView alloc] initWithImage:referenceImage];
        transitionImageView.contentMode = UIViewContentModeScaleAspectFill;
        transitionImageView.clipsToBounds = true;
        transitionImageView.frame = fromReferenceImageViewFrame;
        self.transitionImageView = transitionImageView;
        
        [containerView addSubview:transitionImageView];
    }
    
    [containerView insertSubview:toVC.view belowSubview:fromVC.view];
    fromReferenceImageView.hidden = true;
    
    CGRect finalTransitionSize = toReferenceImageViewFrame;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0
                        options:UIViewAnimationOptionTransitionNone
                     animations:^{
        
                            fromVC.view.alpha = 0;
                            self.transitionImageView.frame = finalTransitionSize;
                            
                            if (toVC.tabBarController)
                                toVC.tabBarController.tabBar.alpha = 1;
        
    } completion:^(BOOL finished) {
        
        [self.transitionImageView removeFromSuperview];
        toReferenceImageView.hidden = false;
        fromReferenceImageView.hidden = false;
        
        [transitionContext completeTransition:!(transitionContext.transitionWasCancelled)];
        [self.toDelegate transitionDidEndWith:self];
        [self.fromDelegate transitionDidEndWith:self];
    }];
}

- (CGRect)calculateZoomInImageFrame:(UIImage*)image forView:(UIView*)view {
    
    CGFloat viewRatio = view.frame.size.width / view.frame.size.height;
    CGFloat imageRatio = image.size.width / image.size.height;
    BOOL touchesSides = (imageRatio > viewRatio);
    
    if (touchesSides) {
        CGFloat height = view.frame.size.width / imageRatio;
        CGFloat yPoint = CGRectGetMinY(view.frame) + (view.frame.size.height - height) / 2;
        return CGRectMake(0, yPoint, view.frame.size.width, height);
    } else {
        CGFloat width = view.frame.size.height * imageRatio;
        CGFloat xPoint = CGRectGetMinX(view.frame) + (view.frame.size.width - width) / 2;
        return CGRectMake(xPoint, 0, width, view.frame.size.height);
    }
}

//MARK:- UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    if (self.isPresenting) {
        return 0.5;
    } else {
        return 0.25;
    }
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    if (self.isPresenting) {
        
    } else {
        
    }
}

@end
