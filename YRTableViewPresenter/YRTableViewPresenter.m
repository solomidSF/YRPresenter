//
// YRTableViewPresenter.m
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

#import "YRTableViewPresenter.h"
#import "YRTableSectionDatasource+Private.h"
#import "YRTableRowDatasource+Private.h"

@interface YRTableViewPresenter ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, readwrite) IBOutlet UITableView *tableView;

@end

@implementation YRTableViewPresenter {
	NSMutableArray <YRTableSectionDatasource *> *_sectionDatasource;
}

#pragma mark - Lifecycle

- (instancetype)initWithTableView:(UITableView *)tableView {
	if (self = [super init]) {
		_tableView = tableView;
		
		_tableView.delegate = self;
		_tableView.dataSource = self;
		
		[_tableView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:NULL];
		
		_sectionDatasource = [NSMutableArray new];
	}
	
	return self;
}

- (void)dealloc {
	[_tableView removeObserver:self forKeyPath:@"contentSize"];
}

- (void)awakeFromNib {
	[super awakeFromNib];
	
	_sectionDatasource = [NSMutableArray new];
}

#pragma mark - Dynamic Properties

- (void)setTableView:(UITableView *)tableView {
	if (_tableView != tableView) {
		_tableView = tableView;
		
		_tableView.delegate = self;
		_tableView.dataSource = self;
		
		[_tableView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:NULL];
	}
}

- (NSArray <YRTableSectionDatasource *> *)sectionDatasource {
	return [_sectionDatasource copy];
}

- (void)setSectionDatasource:(NSArray <YRTableSectionDatasource *> *)sectionDatasource {
	if (_sectionDatasource != sectionDatasource) {
		[_sectionDatasource setValue:nil forKey:@"presenter"];
		
		_sectionDatasource = [sectionDatasource mutableCopy];

		[_sectionDatasource setValue:self forKey:@"presenter"];
		
		[self.tableView reloadData];
	}
}

#pragma mark - Updates

- (void)beginUpdates {
	_isPerformingUpdates = YES;
	
	[self.tableView beginUpdates];
}

- (void)endUpdates {
	_isPerformingUpdates = NO;
	
	[self.tableView endUpdates];
}

#pragma mark - Insert

- (void)insertSectionDatasource:(NSArray <YRTableSectionDatasource *> *)sections atIndex:(NSInteger)index withAnimation:(UITableViewRowAnimation)animation {
	[sections setValue:self forKey:@"presenter"];

	NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:(NSRange){index, sections.count}];
	
	[_sectionDatasource insertObjects:sections atIndexes:indexSet];
	
	[self.tableView insertSections:indexSet withRowAnimation:animation];
}

- (void)insertSectionDatasource:(NSArray <YRTableSectionDatasource *> *)sections beforeSection:(YRTableSectionDatasource *)section withAnimation:(UITableViewRowAnimation)animation {
	NSInteger sectionIdx = [self.sectionDatasource indexOfObject:section];
	
	if (sectionIdx != NSNotFound) {
		[self insertSectionDatasource:sections atIndex:sectionIdx withAnimation:animation];
	} else {
		NSLog(@"[YRTableViewPresenter]: <WARNING> Trying to insert sections %@ before section %@ that isn't present in %@! Ignoring.", sections, section, self);
	}
}

- (void)insertSectionDatasource:(NSArray <YRTableSectionDatasource *> *)sections afterSection:(YRTableSectionDatasource *)section withAnimation:(UITableViewRowAnimation)animation {
	NSInteger sectionIdx = [self.sectionDatasource indexOfObject:section];
	
	if (sectionIdx != NSNotFound) {
		[self insertSectionDatasource:sections atIndex:sectionIdx + 1 withAnimation:animation];
	} else {
		NSLog(@"[YRTableViewPresenter]: <WARNING> Trying to insert sections %@ after section %@ that isn't present in %@! Ignoring.", sections, section, self);
	}
}

- (void)insertRowDatasource:(NSArray <YRTableRowDatasource *> *)datasource inSection:(YRTableSectionDatasource *)sectionDatasource atIndex:(NSInteger)index withAnimation:(UITableViewRowAnimation)animation {
	NSInteger sectionIndex = [self.sectionDatasource indexOfObject:sectionDatasource];
	
	if (sectionIndex != NSNotFound) {
		[datasource setValue:sectionDatasource forKey:@"section"];

		NSMutableArray <NSIndexPath *> *indexPaths = [NSMutableArray new];
		
		NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:(NSRange){index, datasource.count}];
		[sectionDatasource.mutableRowDatasource insertObjects:datasource atIndexes:indexes];
		
		for (int i = 0; i < datasource.count; i++) {
			[indexPaths addObject:[NSIndexPath indexPathForRow:index + i inSection:sectionIndex]];
		}
		
		[self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:animation];
	} else {
		NSLog(@"[YRTableViewPresenter]: <WARNING> Trying to insert rows %@ for section %@ that isn't present in %@! Ignoring.", datasource, sectionDatasource, self);
	}
}

- (void)insertRowDatasource:(NSArray <YRTableRowDatasource *> *)rowDatasource beforeRowDatasource:(YRTableRowDatasource *)datasource withAnimation:(UITableViewRowAnimation)animation {
	YRTableSectionDatasource *section = datasource.section;
	
	if (section) {
		NSInteger rowIdx = [section.rowDatasource indexOfObject:datasource];
		
		if (rowIdx != NSNotFound) {
			[self insertRowDatasource:rowDatasource inSection:section atIndex:rowIdx withAnimation:animation];
		} else {
			NSLog(@"[YRTableViewPresenter]: <ERROR> Trying to insert rows %@ before %@ row, but this row isn't present in associated section in %@! Ignoring.", rowDatasource, datasource, self);
		}
	} else {
		NSLog(@"[YRTableViewPresenter]: <WARNING> Trying to insert rows %@ before %@ row, but this row isn't associated with any section in %@! Ignoring.", rowDatasource, datasource, self);
	}
}

- (void)insertRowDatasource:(NSArray <YRTableRowDatasource *> *)rowDatasource afterRowDatasource:(YRTableRowDatasource *)datasource withAnimation:(UITableViewRowAnimation)animation {
	YRTableSectionDatasource *section = datasource.section;
	
	if (section) {
		NSInteger rowIdx = [section.rowDatasource indexOfObject:datasource];
		
		if (rowIdx != NSNotFound) {
			[self insertRowDatasource:rowDatasource inSection:section atIndex:rowIdx + 1 withAnimation:animation];
		} else {
			NSLog(@"[YRTableViewPresenter]: <ERROR> Trying to insert rows %@ after %@ row, but this row isn't present in associated section in %@! Ignoring.", rowDatasource, datasource, self);
		}
	} else {
		NSLog(@"[YRTableViewPresenter]: <WARNING> Trying to insert rows %@ after %@ row, but this row isn't associated with any section in %@! Ignoring.", rowDatasource, datasource, self);
	}
}

#pragma mark - Deletion

- (void)removeSectionDatasource:(NSArray <YRTableSectionDatasource *> *)sectionDatasource withAnimation:(UITableViewRowAnimation)animation {
	NSMutableIndexSet *indexes = [NSMutableIndexSet new];
	
	for (YRTableSectionDatasource *datasource in sectionDatasource) {
		NSInteger idx = [_sectionDatasource indexOfObject:datasource];
		
		if (idx != NSNotFound) {
			datasource.presenter = nil;

			[indexes addIndex:idx];
		}
	}
	
	[_sectionDatasource removeObjectsAtIndexes:indexes];
	[self.tableView deleteSections:indexes withRowAnimation:animation];
}

- (void)removeRowDatasource:(NSArray <YRTableRowDatasource *> *)datasource withAnimation:(UITableViewRowAnimation)animation {
	NSMutableArray <NSIndexPath *> *indexPaths = [NSMutableArray new];
	NSMutableDictionary *sectionsAndIndexesMap = [NSMutableDictionary new];
	
	for (YRTableRowDatasource *rowDatasource in datasource) {
		NSInteger sectionIdx = [_sectionDatasource indexOfObject:rowDatasource.section];
		
		if (sectionIdx != NSNotFound) {
			NSInteger rowIdx = [rowDatasource.section.rowDatasource indexOfObject:rowDatasource];
			
			if (rowIdx != NSNotFound) {
				if (sectionsAndIndexesMap[@(sectionIdx)] == nil) {
					sectionsAndIndexesMap[@(sectionIdx)] = [NSMutableIndexSet new];
				}

				[(NSMutableIndexSet *)sectionsAndIndexesMap[@(sectionIdx)] addIndex:rowIdx];
				
				[indexPaths addObject:[NSIndexPath indexPathForRow:rowIdx inSection:sectionIdx]];

				rowDatasource.section = nil;
			}
		}
	}
	
	for (NSNumber *sectionIdx in sectionsAndIndexesMap) {
		YRTableSectionDatasource *section = _sectionDatasource[[sectionIdx integerValue]];
		NSIndexSet *rowIndexesToRemove = sectionsAndIndexesMap[sectionIdx];
		
		[section.mutableRowDatasource removeObjectsAtIndexes:rowIndexesToRemove];
	}
	
	[self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:animation];
}

- (void)removeAllRowsInSection:(YRTableSectionDatasource *)section withAnimation:(UITableViewRowAnimation)animation {
	[self removeRowDatasource:section.rowDatasource withAnimation:animation];
}

#pragma mark - Reload

- (void)reloadSections:(NSArray <YRTableSectionDatasource *> *)sections withRowAnimation:(UITableViewRowAnimation)animation {
	NSMutableIndexSet *indexes = [NSMutableIndexSet new];
	
	for (YRTableSectionDatasource *section in sections) {
		NSInteger idx = [_sectionDatasource indexOfObject:section];
		
		if (idx != NSNotFound) {
			[indexes addIndex:idx];
		}
	}
	
	[self.tableView reloadSections:indexes withRowAnimation:animation];
}

- (void)reloadRows:(NSArray <YRTableRowDatasource *> *)rows withAnimation:(UITableViewRowAnimation)animation {
	NSMutableArray <NSIndexPath *> *indexes = [NSMutableArray new];
	
	for (YRTableRowDatasource *row in rows) {
		NSInteger sectionIdx = [_sectionDatasource indexOfObject:row.section];
		
		if (sectionIdx != NSNotFound) {
			NSInteger rowIdx = [row.section.rowDatasource indexOfObject:row];
			
			if (rowIdx != NSNotFound) {
				[indexes addObject:[NSIndexPath indexPathForRow:rowIdx inSection:sectionIdx]];
			}
		}
	}
	
	[self.tableView reloadRowsAtIndexPaths:indexes withRowAnimation:animation];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
	if ([keyPath isEqualToString:@"contentSize"]) {
		!self.contentSizeDidChangeCallback ?: self.contentSizeDidChangeCallback(self.tableView);
	} else {
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
}

#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	!_scrollViewDidScrollCallback ?: _scrollViewDidScrollCallback(scrollView);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	!_scrollViewWillBeginDraggingCallback ?: _scrollViewWillBeginDraggingCallback(scrollView);
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	!_scrollViewDidEndDraggingCallback ?: _scrollViewDidEndDraggingCallback(scrollView, decelerate);
}

#pragma mark - <UITableViewDelegate&Datasource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return self.sectionDatasource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	YRTableSectionDatasource *sectionDatasource = self.sectionDatasource[section];
	
	if (sectionDatasource.headerHeightCallback) {
		return sectionDatasource.headerHeightCallback(sectionDatasource, tableView, section);
	} else {
		return tableView.sectionHeaderHeight;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	YRTableSectionDatasource *sectionDatasource = self.sectionDatasource[section];
	
	if (sectionDatasource.footerHeightCallback) {
		return sectionDatasource.footerHeightCallback(sectionDatasource, tableView, section);
	} else {
		return tableView.sectionFooterHeight;
	}
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	YRTableSectionDatasource *sectionDatasource = self.sectionDatasource[section];
	
	if (sectionDatasource.headerTitleCallback) {
		return sectionDatasource.headerTitleCallback(sectionDatasource, tableView, section);
	} else {
		return nil;
	}
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
	YRTableSectionDatasource *sectionDatasource = self.sectionDatasource[section];
	
	if (sectionDatasource.footerTitleCallback) {
		return sectionDatasource.footerTitleCallback(sectionDatasource, tableView, section);
	} else {
		return nil;
	}
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	YRTableSectionDatasource *sectionDatasource = self.sectionDatasource[section];
	
	if (sectionDatasource.headerViewCallback) {
		return sectionDatasource.headerViewCallback(sectionDatasource, tableView, section);
	} else {
		return nil;
	}
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	YRTableSectionDatasource *sectionDatasource = self.sectionDatasource[section];
	
	if (sectionDatasource.footerViewCallback) {
		return sectionDatasource.footerViewCallback(sectionDatasource, tableView, section);
	} else {
		return nil;
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.sectionDatasource[section].rowDatasource.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
	YRTableRowDatasource *datasource = self.sectionDatasource[indexPath.section].rowDatasource[indexPath.row];
	
	if (datasource.estimatedHeightCallback) {
		return datasource.estimatedHeightCallback(datasource, tableView, nil, indexPath);
	} else {
		return tableView.estimatedRowHeight;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	YRTableRowDatasource *datasource = self.sectionDatasource[indexPath.section].rowDatasource[indexPath.row];
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:datasource.identifier];
	
	CGFloat leadingInset = datasource.leadingNormalizedMargin * tableView.bounds.size.width;
	CGFloat trailingInset = datasource.trailingNormalizedMargin * tableView.bounds.size.width;
	
	cell.contentView.layoutMargins = UIEdgeInsetsMake(0, leadingInset, 0, trailingInset);
	
	!datasource.configurationCallback ?: datasource.configurationCallback(datasource, tableView, cell, indexPath);
	
	return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	YRTableRowDatasource *datasource = self.sectionDatasource[indexPath.section].rowDatasource[indexPath.row];
	
	!datasource.willDisplayCallback ?: datasource.willDisplayCallback(datasource, tableView, [tableView cellForRowAtIndexPath:indexPath], indexPath);
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath {
	if (indexPath.section < self.sectionDatasource.count &&
		indexPath.row < self.sectionDatasource[indexPath.section].rowDatasource.count) {
		YRTableRowDatasource *datasource = self.sectionDatasource[indexPath.section].rowDatasource[indexPath.row];
		
		!datasource.didEndDisplayingCallback ?: datasource.didEndDisplayingCallback(datasource, tableView, [tableView cellForRowAtIndexPath:indexPath], indexPath);
	}
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	YRTableRowDatasource *datasource = self.sectionDatasource[indexPath.section].rowDatasource[indexPath.row];

	return datasource.deletionCallback != nil;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
	forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		YRTableRowDatasource *datasource = self.sectionDatasource[indexPath.section].rowDatasource[indexPath.row];

		if (datasource.deletionCallback) {
			datasource.deletionCallback(datasource, tableView, [tableView cellForRowAtIndexPath:indexPath], indexPath);
			
			[self removeRowDatasource:@[datasource] withAnimation:UITableViewRowAnimationLeft];
		}
	}
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
	YRTableRowDatasource *datasource = self.sectionDatasource[indexPath.section].rowDatasource[indexPath.row];
	
	!datasource.accessoryTappedCallback ?: datasource.accessoryTappedCallback(datasource, tableView, [tableView cellForRowAtIndexPath:indexPath], indexPath);
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
	YRTableRowDatasource *datasource = self.sectionDatasource[indexPath.section].rowDatasource[indexPath.row];
	
	if (datasource.shouldHighlightCallback) {
		return datasource.shouldHighlightCallback(datasource, tableView, [tableView cellForRowAtIndexPath:indexPath], indexPath);
	} else {
		return YES;
	}
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
	YRTableRowDatasource *datasource = self.sectionDatasource[indexPath.section].rowDatasource[indexPath.row];
	
	!datasource.highlightCallback ?: datasource.highlightCallback(datasource, tableView, [tableView cellForRowAtIndexPath:indexPath], indexPath);
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
	YRTableRowDatasource *datasource = self.sectionDatasource[indexPath.section].rowDatasource[indexPath.row];
	
	!datasource.unhighlightCallback ?: datasource.unhighlightCallback(datasource, tableView, [tableView cellForRowAtIndexPath:indexPath], indexPath);
}

- (nullable NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	YRTableRowDatasource *datasource = self.sectionDatasource[indexPath.section].rowDatasource[indexPath.row];

	if (datasource.willSelectCallback) {
		return datasource.willSelectCallback(datasource, tableView, [tableView cellForRowAtIndexPath:indexPath], indexPath);
	} else {
		return indexPath;
	}
}

- (nullable NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
	YRTableRowDatasource *datasource = self.sectionDatasource[indexPath.section].rowDatasource[indexPath.row];
	
	if (datasource.willDeselectCallback) {
		return datasource.willDeselectCallback(datasource, tableView, [tableView cellForRowAtIndexPath:indexPath], indexPath);
	} else {
		return indexPath;
	}
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	YRTableRowDatasource *datasource = self.sectionDatasource[indexPath.section].rowDatasource[indexPath.row];

	!datasource.selectionCallback ?: datasource.selectionCallback(datasource, tableView, [tableView cellForRowAtIndexPath:indexPath], indexPath);
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
	YRTableRowDatasource *datasource = self.sectionDatasource[indexPath.section].rowDatasource[indexPath.row];
	
	!datasource.deselectionCallback ?: datasource.deselectionCallback(datasource, tableView, [tableView cellForRowAtIndexPath:indexPath], indexPath);
}

@end
