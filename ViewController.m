//
//  ViewController.m
//  PhotoViewerOBJC
//
//  Created by Somoy Das Gupta on 15/3/20.
//  Copyright © 2020 Somoy Das Gupta. All rights reserved.
//

#import "ViewController.h"
#import "AssetCollectionViewCell.h"

@interface ViewController () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource> {
    NSMutableArray *imageURLs;
}

@property (weak, nonatomic) IBOutlet UICollectionView *gridCollectionView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    imageURLs = [NSMutableArray arrayWithObjects:@"cell", @"cell1", @"cell2", @"cell3", @"cell4", @"cell5", @"cell6", @"cell7", @"cell8", @"cell9", @"cell10", @"cell11", @"cell12", @"cell13", @"cell14", @"cell15", @"cell16", @"cell17", nil];
    
    [self prepareGridCollectionView];
}

-(void)prepareGridCollectionView {
    _gridCollectionView.delegate = self;
    _gridCollectionView.dataSource = self;
    _gridCollectionView.contentInset = UIEdgeInsetsMake(0, 0,300, 0);
    _gridCollectionView.bounces = true;
}

//MARK:- GridCollectionView Delegate & DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return imageURLs.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    double width = (self.view.frame.size.width - (2 * 3 + 2 * 4)) / 3;
//    NSLog(@"%f", width);
    return CGSizeMake(width, width);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AssetCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AssetCollectionViewCell" forIndexPath:indexPath];
    
    NSString *imageName = imageURLs[indexPath.item];
    cell.assetImage = [UIImage imageNamed:imageName];
    
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    return true;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    return true;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

@end
