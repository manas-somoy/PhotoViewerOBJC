//
//  ZoomDismissalInteractionController.h
//  PhotoViewerOBJC
//
//  Created by Somoy Das Gupta on 15/3/20.
//  Copyright © 2020 Somoy Das Gupta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ZoomAnimator.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZoomDismissalInteractionController : NSObject

@property (nonatomic) id<UIViewControllerContextTransitioning> _Nullable transitionContext;
@property (nonatomic) id<UIViewControllerAnimatedTransitioning> animator;

@property (nonatomic) CGRect fromReferenceImageViewFrame;
@property (nonatomic) CGRect toReferenceImageViewFrame;

- (void)didPanWithGestureRecognizer:(UIPanGestureRecognizer*)gestureRecognizer;

@end

NS_ASSUME_NONNULL_END
