//
//  AssetCollectionViewCell.h
//  LivePhotoMaker
//
//  Created by Somoy on 16/6/19.
//  Copyright © 2019 Brain Craft Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AssetCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *assetImageView;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;

@property (weak, nonatomic) UIImage *assetImage;

- (void)showDurationLabel;
- (void)hideDurationLabel;
- (void)showSelectedImage;
- (void)hideSelectedImage;
@end

NS_ASSUME_NONNULL_END
