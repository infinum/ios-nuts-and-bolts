//
//  TableDataSourceDelegateTests.m
//  Tests
//
//  Created by Ivana Mršić on 20/05/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TableDataSourceDelegate.h"
//#import "TableSectionItem.h"
//#import "BaseTableCellItem.h"

@interface TableDataSourceDelegateTests : XCTestCase

@property (nonatomic, strong) TableDataSourceDelegate *tableDataSourceDelegate;

@end

@implementation TableDataSourceDelegateTests

- (void)setUp
{
    [super setUp];
    
}

- (NSArray<TableSectionItem> *)createSections
{
    TestCellItem *item1 = [[TestCellItem alloc] init];
    TestCellItem *item2 = [[TestCellItem alloc] init];
    
    
}

@end


@interface TestCellItem: BaseTableCellItem

@end

@implementation TestCellItem

@end
