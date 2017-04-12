//
//  YRCollectionRowDatasource.m
//  YRPresenterDemo
//
//  Created by Yuriy Romanchenko on 11/24/16.
//  Copyright © 2016 solomidSF. All rights reserved.
//

#import "YRCollectionRowDatasource.h"

@implementation YRCollectionRowDatasource

- (instancetype)initWithReuseIdentifier:(NSString *)identifier context:(id)context {
	if (self = [super init]) {
		_identifier = identifier;
		_context = context;
	}
	return self;
}

@end
