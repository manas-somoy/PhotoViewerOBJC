//
//  ZoomTransitionController.h
//  PhotoViewerOBJC
//
//  Created by Somoy Das Gupta on 15/3/20.
//  Copyright © 2020 Somoy Das Gupta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ZoomDismissalInteractionController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZoomTransitionController : NSObject

@property (nonatomic) ZoomAnimator *animator;
@property (nonatomic) ZoomDismissalInteractionController *interactionController;
@property (nonatomic) BOOL isInteractive;

@property (weak, nonatomic) id<ZoomAnimatorDelegate> fromDelegate;
@property (weak, nonatomic) id<ZoomAnimatorDelegate> toDelegate;



@end

NS_ASSUME_NONNULL_END
