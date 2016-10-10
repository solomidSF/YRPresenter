//
//  YRTableRowDatasource+Private.h
//  YRPresenterDemo
//
//  Created by Yuriy Romanchenko on 10/11/16.
//  Copyright © 2016 solomidSF. All rights reserved.
//

#import "YRTableRowDatasource.h"

@interface YRTableRowDatasource (Private)
@property (nonatomic, weak, readwrite, nullable) YRTableSectionDatasource *section;
@end
