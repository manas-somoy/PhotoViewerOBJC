//
//  AssetCollectionViewCell.m
//  LivePhotoMaker
//
//  Created by Somoy on 16/6/19.
//  Copyright © 2019 Brain Craft Ltd. All rights reserved.
//

#import "AssetCollectionViewCell.h"

@implementation AssetCollectionViewCell

- (void)prepareForReuse {
    [super prepareForReuse];
    
//    _assetImageView.image = nil;
    _assetImage = nil;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _durationLabel.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.5];
    _durationLabel.layer.cornerRadius = 5.0;
    _durationLabel.layer.borderColor = UIColor.blackColor.CGColor;
    _durationLabel.layer.borderWidth = 0.7;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    if (selected) {
        self.selectImageView.image = [UIImage imageNamed:@"cellselect"];
    } else {
        self.selectImageView.image = [UIImage imageNamed:@"cellunselect"];
    }
}

- (void)setAssetImage:(UIImage *)assetImage {
    _assetImage = assetImage;
    _assetImageView.image = assetImage;
}

- (void)showDurationLabel {
    _durationLabel.hidden = false;
}

- (void)hideDurationLabel {
    _durationLabel.hidden = true;
}

- (void)showSelectedImage {
    _selectImageView.hidden = false;
}

- (void)hideSelectedImage {
    _selectImageView.hidden = true;
}

@end
