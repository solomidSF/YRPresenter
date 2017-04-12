//
//  YRCollectionRowDatasource.h
//  YRPresenterDemo
//
//  Created by Yuriy Romanchenko on 11/24/16.
//  Copyright © 2016 solomidSF. All rights reserved.
//

@import UIKit;

@class YRCollectionRowDatasource;

NS_ASSUME_NONNULL_BEGIN

typedef void (^YRCollectionRowDatasourceCallback) (YRCollectionRowDatasource *datasource, UICollectionView *collectionView, __kindof UICollectionViewCell * __nullable cell, NSIndexPath *indexPath);

@interface YRCollectionRowDatasource : NSObject

/**
 *  Reuse identifier associated with cell.
 */
@property (nonatomic, readonly) NSString *identifier;

/**
 *  Optional user-defined context.
 */
@property (nonatomic, nullable) id context;

@property (nonatomic, copy, nullable) YRCollectionRowDatasourceCallback configurationCallback;
@property (nonatomic, copy, nullable) YRCollectionRowDatasourceCallback selectionCallback;

- (instancetype)initWithReuseIdentifier:(NSString *)identifier context:(nullable id)context;

@end

NS_ASSUME_NONNULL_END
