//
//  YRTableSectionDatasource+Private.h
//  YRPresenterDemo
//
//  Created by Yuriy Romanchenko on 10/7/16.
//  Copyright © 2016 solomidSF. All rights reserved.
//

#import "YRTableSectionDatasource.h"

NS_ASSUME_NONNULL_BEGIN

@interface YRTableSectionDatasource (Private)
@property (nonatomic, weak, readwrite, nullable) YRTableViewPresenter *presenter;
@property (nonatomic, readwrite) NSMutableArray <YRTableRowDatasource *> *mutableRowDatasource;
@end

NS_ASSUME_NONNULL_END
