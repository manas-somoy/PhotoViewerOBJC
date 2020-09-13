//
//  AssetCell.h
//  PhotoViewerOBJC
//
//  Created by Somoy Das Gupta on 13/9/20.
//  Copyright © 2020 Somoy Das Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AssetCell : UICollectionViewCell
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
