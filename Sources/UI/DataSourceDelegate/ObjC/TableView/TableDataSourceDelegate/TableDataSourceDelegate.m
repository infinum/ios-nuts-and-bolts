//
//  TableDataSourceDelegate.m
//
//  Created by Ivana Mršić on 20/05/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

#import "TableDataSourceDelegate.h"
#import "TableSectionItem.h"
#import "TableCellItem.h"
#import "BaseTableSection.h"
#import "BaseTableCellItem.h"

#pragma mark - Table mode classes

// TableViewModeClassic
@interface TableDataSourceDelegate ()

@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, strong, readonly) id<TableViewReloader> reloader;

@end

// TableViewModeTitledHeaderFooter
@interface TitledTableDataSourceDelegate : TableDataSourceDelegate
@end

// TableViewModeCustomHeaderFooter
@interface CustomHeaderTableDataSourceDelegate : TableDataSourceDelegate
@end

@implementation TableDataSourceDelegate

#pragma mark - Inits

- (instancetype)initWithTableView:(UITableView *)tableView
                          forMode:(TableViewMode)mode
                         reloader:(id<TableViewReloader>)reloader
{
    switch (mode) {
        case TableViewModeClassic:
            self = [super init];
            break;
            
        case TableViewModeTitledHeaderFooter:
            self = [[TitledTableDataSourceDelegate alloc] init];
            break;
            
        case TableViewModeCustomHeaderFooter:
            self = [[CustomHeaderTableDataSourceDelegate alloc] init];
            break;
    }
    
    if (self) {
        _tableView = tableView;
        _reloader = reloader;
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return self;
}

- (instancetype)initWithTableView:(UITableView *)tableView
                          forMode:(TableViewMode)mode
{
    return [self initWithTableView:tableView forMode:mode reloader:[DefaultTableViewReloader new]];
}

#pragma mark - Setters

- (void)setSections:(NSArray<id<TableSectionItem>> *)sections
{
    NSArray *oldSections = _sections;
    _sections = sections;
    [self.reloader reloadTableView:self.tableView oldSections:oldSections newSections:sections];
}

- (void)setItems:(NSArray<id<TableCellItem>> *)items
{
    self.sections = @[[[BaseTableSection alloc] initWithItems:items]];
}

#pragma mark - Getters

- (NSArray<id<TableCellItem>> *)items
{
    NSMutableArray<id<TableCellItem>> *items = [NSMutableArray new];
    for (id<TableSectionItem> section in self.sections) {
        if (section.items) {
            [items addObjectsFromArray:section.items];
        }
    }
    return items;
}

#pragma mark - UITableViewDataSource -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sections[section].items.count;
}

- (__kindof UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.sections[indexPath.section].items[indexPath.row] cellFromTableView:tableView at:indexPath];
}

#pragma mark - UITableViewDelegate -

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.sections[indexPath.section].items[indexPath.row].estimatedHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.sections[indexPath.section].items[indexPath.row].height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.sections[indexPath.section].items[indexPath.row] didSelectAt:indexPath];
}

@end

#pragma mark - TitledHeader-Mode

@implementation TitledTableDataSourceDelegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.sections[section] titleForHeaderFrom:tableView at:section];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return [self.sections[section] titleForFooterFrom:tableView at:section];
}

@end

#pragma mark - CustomHeader-Mode

@implementation CustomHeaderTableDataSourceDelegate

// header
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section
{
    return self.sections[section].estimatedHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.sections[section].headerHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self.sections[section] headerViewFromTableView:tableView at:section];
}

// footer
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section
{
    return self.sections[section].estimatedFooterHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return self.sections[section].footerHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [self.sections[section] footerViewFromTableView:tableView at:section];
}

@end
