//
//  YRTableRowDatasource.h
//  YRPresenterDemo
//
//  Created by Yuriy Romanchenko on 10/7/16.
//  Copyright © 2016 solomidSF. All rights reserved.
//

@import UIKit;

@class YRTableSectionDatasource;
@class YRTableRowDatasource;

NS_ASSUME_NONNULL_BEGIN

typedef void (^YRTableRowDatasourceCallback) (YRTableRowDatasource *datasource, UITableView *tableView, UITableViewCell * __nullable cell, NSIndexPath *indexPath);
typedef BOOL (^YRTableRowDatasourceBooleanReturnCallback) (YRTableRowDatasource *datasource, UITableView *tableView, UITableViewCell * __nullable cell, NSIndexPath *indexPath);
typedef NSIndexPath * __nullable (^YRTableRowDatasourceWillSelectDeselectCallback) (YRTableRowDatasource *datasource, UITableView *tableView, UITableViewCell * __nullable cell, NSIndexPath *indexPath);

@interface YRTableRowDatasource : NSObject

/**
 *  Associated section that presents this row.
 */
@property (nonatomic, weak, readonly, nullable) YRTableSectionDatasource *section;

/**
 *  Reuse identifier associated with cell.
 */
@property (nonatomic, readonly) NSString *identifier;

/**
 *  Optional user-defined context.
 */
@property (nonatomic, nullable) id context;

@property (nonatomic, copy) YRTableRowDatasourceCallback configurationCallback;
@property (nonatomic, copy) YRTableRowDatasourceCallback willDisplayCallback;
@property (nonatomic, copy) YRTableRowDatasourceCallback didEndDisplayingCallback;
@property (nonatomic, copy) YRTableRowDatasourceBooleanReturnCallback shouldHighlightCallback;
@property (nonatomic, copy) YRTableRowDatasourceCallback highlightCallback;
@property (nonatomic, copy) YRTableRowDatasourceCallback unhighlightCallback;
@property (nonatomic, copy) YRTableRowDatasourceWillSelectDeselectCallback willSelectCallback;
@property (nonatomic, copy) YRTableRowDatasourceWillSelectDeselectCallback willDeselectCallback;
@property (nonatomic, copy) YRTableRowDatasourceCallback accessoryTappedCallback;
@property (nonatomic, copy) YRTableRowDatasourceCallback selectionCallback;
@property (nonatomic, copy) YRTableRowDatasourceCallback deselectionCallback;

- (instancetype)initWithReuseIdentifier:(NSString *)identifier context:(nullable id)context;

@end

NS_ASSUME_NONNULL_END
