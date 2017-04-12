//
//  YRCollectionViewPresenter.h
//  YRPresenterDemo
//
//  Created by Yuriy Romanchenko on 11/24/16.
//  Copyright © 2016 solomidSF. All rights reserved.
//

@import UIKit;

#import "YRCollectionRowDatasource.h"

NS_ASSUME_NONNULL_BEGIN

@interface YRCollectionViewPresenter : NSObject

/**
 *  Collection view associated with this presenter.
 */
@property (nonatomic, readonly) UICollectionView *collectionView;

@property (nonatomic) NSArray <YRCollectionRowDatasource *> *rowDatasource;

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView;

@end

NS_ASSUME_NONNULL_END
