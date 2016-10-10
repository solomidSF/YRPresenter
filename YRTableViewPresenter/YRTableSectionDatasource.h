//
//  YRTableSectionDatasource.h
//  YRPresenterDemo
//
//  Created by Yuriy Romanchenko on 10/7/16.
//  Copyright © 2016 solomidSF. All rights reserved.
//

@import Foundation;

#import "YRTableRowDatasource.h"

@class YRTableViewPresenter;
@class YRTableSectionDatasource;

NS_ASSUME_NONNULL_BEGIN

typedef CGFloat (^YRTableSectionDatasourceHeightCallback) (YRTableSectionDatasource *sectionDatasource, UITableView *tableView, NSInteger sectionIndex);
typedef NSString * __nullable (^YRTableSectionDatasourceTitleCallback) (YRTableSectionDatasource *sectionDatasource, UITableView *tableView, NSInteger sectionIndex);
typedef UIView * __nullable (^YRTableSectionDatasourceViewCallback) (YRTableSectionDatasource *sectionDatasource, UITableView *tableView, NSInteger sectionIndex);

@interface YRTableSectionDatasource : NSObject

/**
 *  Presenter that's currently presents content of given section.
 */
@property (nonatomic, weak, readonly, nullable) YRTableViewPresenter *presenter;

/**
 *  Row datasource associated with given section.
 */
@property (nonatomic, readonly) NSArray <YRTableRowDatasource *> *rowDatasource;

/**
 *  Optional user-defined context.
 */
@property (nonatomic, nullable) id context;

@property (nonatomic, copy, nullable) YRTableSectionDatasourceHeightCallback headerHeightCallback;
@property (nonatomic, copy, nullable) YRTableSectionDatasourceHeightCallback footerHeightCallback;
@property (nonatomic, copy, nullable) YRTableSectionDatasourceTitleCallback headerTitleCallback;
@property (nonatomic, copy, nullable) YRTableSectionDatasourceTitleCallback footerTitleCallback;
@property (nonatomic, copy, nullable) YRTableSectionDatasourceViewCallback headerViewCallback;
@property (nonatomic, copy, nullable) YRTableSectionDatasourceViewCallback footerViewCallback;

- (instancetype)initWithContext:(__nullable id)context;
- (instancetype)initWithRowDatasource:(NSArray <YRTableRowDatasource *> * __nullable)rowDatasource
							  context:(__nullable id)context;

@end

NS_ASSUME_NONNULL_END
