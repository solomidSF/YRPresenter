//
//  YRTableRowDatasource.m
//  YRPresenterDemo
//
//  Created by Yuriy Romanchenko on 10/7/16.
//  Copyright © 2016 solomidSF. All rights reserved.
//

#import "YRTableRowDatasource.h"

@interface YRTableRowDatasource ()
@property (nonatomic, weak, readwrite, nullable) YRTableSectionDatasource *section;
@end

@implementation YRTableRowDatasource

- (instancetype)initWithReuseIdentifier:(NSString *)identifier context:(nullable id)context {
	if (self = [super init]) {
		_identifier = identifier;
		_context = context;
	}
	
	return self;
}

@end
