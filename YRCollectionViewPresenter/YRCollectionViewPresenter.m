//
//  YRCollectionViewPresenter.m
//  YRPresenterDemo
//
//  Created by Yuriy Romanchenko on 11/24/16.
//  Copyright © 2016 solomidSF. All rights reserved.
//

#import "YRCollectionViewPresenter.h"

@interface YRCollectionViewPresenter ()
<
UICollectionViewDelegate,
UICollectionViewDataSource
>

@property (nonatomic, readwrite) IBOutlet UICollectionView *collectionView;

@end

@implementation YRCollectionViewPresenter {
	NSMutableArray <YRCollectionRowDatasource *> *_rowDatasource;
}

#pragma mark - Lifecycle

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView {
	if (self = [super init]) {
		_collectionView = collectionView;
		
		_collectionView.delegate = self;
		_collectionView.dataSource = self;

		_rowDatasource = [NSMutableArray new];
	}
	
	return self;
}

- (void)awakeFromNib {
	[super awakeFromNib];
	
	_rowDatasource = [NSMutableArray new];
}

#pragma mark - Dynamic Properties

- (void)setRowDatasource:(NSArray<YRCollectionRowDatasource *> *)rowDatasource {
	if (_rowDatasource != rowDatasource) {
		_rowDatasource = [rowDatasource mutableCopy];
		
		[self.collectionView reloadData];
	}
}

#pragma mark - <UICollectionViewDelegate & UICollectionViewDataSource>

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	YRCollectionRowDatasource *datasource = self.rowDatasource[indexPath.row];
	
	UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:datasource.identifier forIndexPath:indexPath];
	
	!datasource.configurationCallback ?: datasource.configurationCallback(datasource, collectionView, cell, indexPath);
	
	return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	YRCollectionRowDatasource *datasource = self.rowDatasource[indexPath.row];
	
	!datasource.selectionCallback ?: datasource.selectionCallback(datasource, collectionView, [collectionView cellForItemAtIndexPath:indexPath], indexPath);
}

@end
