//
//  TableDataSourceDelegateTests.m
//
//  Created by Ivana Mršić on 20/05/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "TableDataSourceDelegate.h"
#import "BaseTableCellItem.h"
#import "BaseTableSection.h"

@interface TestTableViewCell : UITableViewCell

@end

@implementation TestTableViewCell

@end

@interface TestCellItem: BaseTableCellItem

@property (nonatomic) BOOL didSelectCalled;

@end

@implementation TestCellItem

- (instancetype)init
{
    self = [super init];
    if (self) {
        _didSelectCalled = NO;
    }
    return self;
}

- (CGFloat)height
{
    return 50;
}

- (CGFloat)estimatedHeight
{
    return 44;
}

- (void)didSelectAt:(NSIndexPath *)indexPath
{
    self.didSelectCalled = YES;
}

- (UITableViewCell *)cellFromTableView:(UITableView *)tableView at:(NSIndexPath *)indexPath
{
    return [TestTableViewCell new];
}

@end

@interface TestSection : BaseTableSection

@property (nonatomic) NSString *title;

@end

@implementation TestSection

- (CGFloat)estimatedFooterHeight
{
    return 4;
}

- (CGFloat)estimatedHeaderHeight
{
    return 3;
}

- (CGFloat)footerHeight
{
    return 2;
}

- (CGFloat)headerHeight
{
    return 1;
}

- (UIView *)footerViewFromTableView:(UITableView *)tableView at:(NSInteger)index
{
    return [[UIView alloc] init];
}

- (UIView *)headerViewFromTableView:(UITableView *)tableView at:(NSInteger)index
{
    return [[UIView alloc] init];
}

- (NSString *)titleForFooterFrom:(UITableView *)tableView at:(NSInteger)index
{
    return self.title;
}

- (NSString *)titleForHeaderFrom:(UITableView *)tableView at:(NSInteger)index
{
    return self.title;
}

@end

@interface TableDataSourceDelegateTests : XCTestCase

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) TableDataSourceDelegate *tableDataSourceDelegate;

@end

@implementation TableDataSourceDelegateTests

- (void)setUp
{
    [super setUp];
    
    self.tableView = [[UITableView alloc] init];
    self.tableDataSourceDelegate = [[TableDataSourceDelegate alloc] initWithTableView:self.tableView];
    
    self.tableDataSourceDelegate.sections = self.createSections;
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testNumberOfSectionsAndItems
{
    XCTAssertEqual([self.tableDataSourceDelegate numberOfSectionsInTableView:self.tableView], 2);
    XCTAssertEqual([self.tableDataSourceDelegate tableView:self.tableView numberOfRowsInSection:0], 3);
}

- (void)testCellSize
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    CGFloat height = [self.tableDataSourceDelegate tableView:self.tableView heightForRowAtIndexPath:indexPath];
    CGFloat estimatedHeighteight = [self.tableDataSourceDelegate tableView:self.tableView estimatedHeightForRowAtIndexPath:indexPath];
    
    XCTAssertEqual(estimatedHeighteight, 44);
    XCTAssertEqual(height, 50);
}

- (void)testSectionHeaderSize
{
    CGFloat height = [self.tableDataSourceDelegate tableView:self.tableView heightForHeaderInSection:0];
    CGFloat estimatedHeighteight = [self.tableDataSourceDelegate tableView:self.tableView estimatedHeightForHeaderInSection:0];
    
    XCTAssertEqual(estimatedHeighteight, 3);
    XCTAssertEqual(height, 1);
}

- (void)testSectionFooterSize
{
    CGFloat height = [self.tableDataSourceDelegate tableView:self.tableView heightForFooterInSection:0];
    CGFloat estimatedHeighteight = [self.tableDataSourceDelegate tableView:self.tableView estimatedHeightForFooterInSection:0];
    
    XCTAssertEqual(estimatedHeighteight, 4);
    XCTAssertEqual(height, 2);
}

- (void)testSectionTitles
{
    NSString *headerTitle = [self.tableDataSourceDelegate tableView:self.tableView titleForHeaderInSection:1];
    NSString *footerTitle = [self.tableDataSourceDelegate tableView:self.tableView titleForFooterInSection:1];

    XCTAssertEqual(headerTitle, @"Section2");
    XCTAssertEqual(footerTitle, @"Section2");
}

- (void)testDidSelectInvocation
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [self.tableDataSourceDelegate tableView:self.tableView didSelectRowAtIndexPath:indexPath];
    
    TestCellItem *item = self.tableDataSourceDelegate.items[0];

    XCTAssertTrue(item.didSelectCalled);
}

- (void)testSectionHeaderFooterView
{
    UIView *header = [self.tableDataSourceDelegate tableView:self.tableView viewForHeaderInSection:0];
    UIView *footer = [self.tableDataSourceDelegate tableView:self.tableView viewForFooterInSection:0];

    XCTAssertNotNil(header);
    XCTAssertNotNil(footer);
}

- (void)testCellType
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];

    UITableViewCell *cell = [self.tableDataSourceDelegate tableView:self.tableView cellForRowAtIndexPath:indexPath];
    
    XCTAssertTrue([cell isKindOfClass:TestTableViewCell.class]);
}

- (void)testItemsCount
{
    XCTAssertEqual(self.tableDataSourceDelegate.items.count, 5);
}

- (void)testItemsSetBlankSection
{
    TestCellItem *item = [[TestCellItem alloc] init];
    
    self.tableDataSourceDelegate.items = [[NSArray alloc] initWithObjects:item, nil];
    
    NSArray *sections = self.tableDataSourceDelegate.sections;
    
    XCTAssertEqual(sections.count, 1);
    XCTAssertEqual([sections.firstObject items].count, 1);
    XCTAssertTrue([sections.firstObject isKindOfClass:BaseTableSection.class]);
}

- (void)testHeightWhenSectionsAreNil
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    self.tableDataSourceDelegate.sections = nil;
    
    XCTAssertEqual(self.tableDataSourceDelegate.sections.count, 0);
    XCTAssertEqual([self.tableDataSourceDelegate tableView:self.tableView numberOfRowsInSection:0], 0);
    XCTAssertEqual([self.tableDataSourceDelegate tableView:self.tableView heightForRowAtIndexPath:indexPath], 0);
    XCTAssertEqual([self.tableDataSourceDelegate tableView:self.tableView estimatedHeightForRowAtIndexPath:indexPath], 0);
    XCTAssertEqual([self.tableDataSourceDelegate tableView:self.tableView heightForFooterInSection:0], 0);
    XCTAssertEqual([self.tableDataSourceDelegate tableView:self.tableView estimatedHeightForFooterInSection:0], 0);

    XCTAssertEqual([self.tableDataSourceDelegate tableView:self.tableView heightForHeaderInSection:0], 0);
    XCTAssertEqual([self.tableDataSourceDelegate tableView:self.tableView estimatedHeightForHeaderInSection:0], 0);
}

- (NSArray<TestSection*> *)createSections
{
    TestCellItem *item1 = [[TestCellItem alloc] init];
    TestCellItem *item2 = [[TestCellItem alloc] init];
    
    TestSection *section1 = [[TestSection alloc] initWithItems:[[NSArray alloc] initWithObjects: item1, item2, item1, nil] ];
    section1.title = @"Section1";
    
    TestSection *section2= [[TestSection alloc] initWithItems:[[NSArray alloc] initWithObjects: item1, item2, nil] ];
    section2.title = @"Section2";
    
    return [[NSArray alloc] initWithObjects:section1, section2, nil];
}

@end
