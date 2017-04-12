//
//  SimpleTableViewController.m
//  YRPresenterDemo
//
//  Created by Yuriy Romanchenko on 10/17/16.
//  Copyright © 2016 solomidSF. All rights reserved.
//

// View Controllers
#import "SimpleTableViewController.h"

// 3rdParty
#import "YRTableViewPresenter.h"

@interface SimpleTableViewController ()

@end

@implementation SimpleTableViewController {
	IBOutlet YRTableViewPresenter *_presenter;
	
	NSArray <NSString *> *_titles;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	_titles = @[@"First title", @"Second title", @"#3", @"#4?", @"Title for 4 row", @"Title for 5 row", @""];
	
	[self setupDatasource];
}

- (void)setupDatasource {
	
}

@end
