//
//  ZoomAnimator.h
//  PhotoViewerOBJC
//
//  Created by Somoy Das Gupta on 15/3/20.
//  Copyright © 2020 Somoy Das Gupta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZoomAnimator;

@protocol ZoomAnimatorDelegate <NSObject>

-(void)transitionWillStartWith:(ZoomAnimator*)zoomAnimator;
-(void)transitionDidEndWith:(ZoomAnimator*)zoomAnimator;
-(UIImageView*)referenceImageViewForZoomAnimator:(ZoomAnimator*)zoomAnimator;
-(CGRect)referenceImageViewFrameInTransitioningViewForZoomAnimator:(ZoomAnimator*)zoomAnimator;

@end

@interface ZoomAnimator : NSObject

@property (weak, nonatomic) id<ZoomAnimatorDelegate> fromDelegate;
@property (weak, nonatomic) id<ZoomAnimatorDelegate> toDelegate;

@property (nonatomic)  UIImageView * _Nullable transitionImageView;
@property (nonatomic) BOOL isPresenting;

@end

NS_ASSUME_NONNULL_END
