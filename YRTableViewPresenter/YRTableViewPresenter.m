//
//  YRTableViewPresenter.m
//  YRPresenterDemo
//
//  Created by Yuriy Romanchenko on 10/7/16.
//  Copyright © 2016 solomidSF. All rights reserved.
//

#import "YRTableViewPresenter.h"
#import "YRTableSectionDatasource+Private.h"

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
		
		_sectionDatasource = [NSMutableArray new];
	}
	
	return self;
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
	}
}

- (void)setSectionDatasource:(NSArray <YRTableSectionDatasource *> *)sectionDatasource {
	if (_sectionDatasource != sectionDatasource) {
		_sectionDatasource = [sectionDatasource mutableCopy];
		
		[self.tableView reloadData];
	}
}

#pragma mark - Updates

- (void)beginUpdates {
	_isPerformingUpdates = YES;
}

- (void)endUpdates {
	_isPerformingUpdates = NO;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	YRTableRowDatasource *datasource = self.sectionDatasource[indexPath.section].rowDatasource[indexPath.row];
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:datasource.identifier];

	!datasource.configurationCallback ?: datasource.configurationCallback(datasource, tableView, cell, indexPath);
	
	return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	YRTableRowDatasource *datasource = self.sectionDatasource[indexPath.section].rowDatasource[indexPath.row];
	
	!datasource.willDisplayCallback ?: datasource.willDisplayCallback(datasource, tableView, [tableView cellForRowAtIndexPath:indexPath], indexPath);
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath {
	YRTableRowDatasource *datasource = self.sectionDatasource[indexPath.section].rowDatasource[indexPath.row];
	
	!datasource.didEndDisplayingCallback ?: datasource.didEndDisplayingCallback(datasource, tableView, [tableView cellForRowAtIndexPath:indexPath], indexPath);
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
