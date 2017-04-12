//
// YRTableViewPresenter.h
//
// The MIT License (MIT)
//
// Copyright (c) 2015 Yuri R.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

@import UIKit;

#import "YRTableSectionDatasource.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^YRTableViewPresenterScrollCallback) (UIScrollView *scrollView);

/**
 *  Manages table view, let you focus on your content.
 */
@interface YRTableViewPresenter : NSObject

/**
 *  Table view associated with this presenter.
 */
@property (nonatomic, readonly) UITableView *tableView;

/**
 *  Section datasource for presenter.
 */
@property (nonatomic) NSArray <YRTableSectionDatasource *> *sectionDatasource;

/**
 *  Tells if receiver is performing updates on it's datasource.
 */
@property (nonatomic, readonly) BOOL isPerformingUpdates;

@property (nonatomic, copy, nullable) YRTableViewPresenterScrollCallback scrollViewDidScrollCallback;
@property (nonatomic, copy, nullable) YRTableViewPresenterScrollCallback scrollViewWillBeginDraggingCallback;
@property (nonatomic, copy, nullable) void (^scrollViewDidEndDraggingCallback) (UIScrollView *scrollView, BOOL willDecelerate);
@property (nonatomic, copy, nullable) void (^contentSizeDidChangeCallback) (UITableView  *tableView);

- (instancetype)initWithTableView:(UITableView *)tableView;

#pragma mark - Updates

- (void)beginUpdates;
- (void)endUpdates;

#pragma mark - Insert

- (void)insertSectionDatasource:(NSArray <YRTableSectionDatasource *> *)sections atIndex:(NSInteger)index withAnimation:(UITableViewRowAnimation)animation;
- (void)insertSectionDatasource:(NSArray <YRTableSectionDatasource *> *)sections beforeSection:(YRTableSectionDatasource *)section withAnimation:(UITableViewRowAnimation)animation;
- (void)insertSectionDatasource:(NSArray <YRTableSectionDatasource *> *)sections afterSection:(YRTableSectionDatasource *)section withAnimation:(UITableViewRowAnimation)animation;

- (void)insertRowDatasource:(NSArray <YRTableRowDatasource *> *)datasource inSection:(YRTableSectionDatasource *)sectionDatasource atIndex:(NSInteger)index withAnimation:(UITableViewRowAnimation)animation;
- (void)insertRowDatasource:(NSArray <YRTableRowDatasource *> *)rowDatasource afterRowDatasource:(YRTableRowDatasource *)datasource withAnimation:(UITableViewRowAnimation)animation;
- (void)insertRowDatasource:(NSArray <YRTableRowDatasource *> *)rowDatasource beforeRowDatasource:(YRTableRowDatasource *)datasource withAnimation:(UITableViewRowAnimation)animation;

#pragma mark - Deletion

- (void)removeSectionDatasource:(NSArray <YRTableSectionDatasource *> *)sectionDatasource withAnimation:(UITableViewRowAnimation)animation;

- (void)removeRowDatasource:(NSArray <YRTableRowDatasource *> *)datasource withAnimation:(UITableViewRowAnimation)animation;
- (void)removeAllRowsInSection:(YRTableSectionDatasource *)section withAnimation:(UITableViewRowAnimation)animation;

#pragma mark - Reload

- (void)reloadSections:(NSArray <YRTableSectionDatasource *> *)sections withRowAnimation:(UITableViewRowAnimation)animation;
- (void)reloadRows:(NSArray <YRTableRowDatasource *> *)rows withAnimation:(UITableViewRowAnimation)animation;

@end

NS_ASSUME_NONNULL_END
