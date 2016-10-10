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
@property (nonatomic, readwrite) NSMutableArray <YRTableRowDatasource *> *mutableRowDatasource;
@end

@implementation YRTableSectionDatasource

#pragma mark - Lifecycle

- (instancetype)initWithContext:(__nullable id)context {
	return [self initWithRowDatasource:@[] context:context];
}

- (instancetype)initWithRowDatasource:(NSArray <YRTableRowDatasource *> * __nullable)rowDatasource
							  context:(__nullable id)context {
	if (self = [super init]) {
		self.mutableRowDatasource = rowDatasource ? [rowDatasource mutableCopy] : [NSMutableArray new];
		_context = context;
		
		[self.mutableRowDatasource setValue:self forKey:@"section"];
	}
	
	return self;
}

#pragma mark - Dynamic Properties

- (NSArray <YRTableRowDatasource *> *)rowDatasource {
	return [self.mutableRowDatasource copy];
}

@end
