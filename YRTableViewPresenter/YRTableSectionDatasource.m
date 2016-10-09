//
//  YRTableSectionDatasource.m
//  YRPresenterDemo
//
//  Created by Yuriy Romanchenko on 10/7/16.
//  Copyright © 2016 solomidSF. All rights reserved.
//

#import "YRTableSectionDatasource.h"

@interface YRTableSectionDatasource ()
@property (nonatomic, weak, readwrite, nullable) YRTableViewPresenter *presenter;
@end

@implementation YRTableSectionDatasource {
	NSMutableArray <YRTableRowDatasource *> *_rowDatasource;
}

#pragma mark - Lifecycle

- (instancetype)initWithContext:(__nullable id)context {
	return [self initWithRowDatasource:@[] context:context];
}

- (instancetype)initWithRowDatasource:(NSArray <YRTableRowDatasource *> * __nullable)rowDatasource
							  context:(__nullable id)context {
	if (self = [super init]) {
		_rowDatasource = rowDatasource ? [rowDatasource mutableCopy] : [NSMutableArray new];
		_context = context;
	}
	
	return self;
}

@end
