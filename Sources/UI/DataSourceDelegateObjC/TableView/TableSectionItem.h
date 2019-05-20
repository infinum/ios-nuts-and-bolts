//
//  TableSectionItem.h
//  Catalog
//
//  Created by Ivana Mršić on 20/05/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SectionItem.h"
#import "TableCellItem.h"

/// Base interface for all table view section items - used in conjuction with
/// `TableDataSourceDelegate`
@protocol TableSectionItem <NSObject, SectionItem>

#pragma mark - Required methods and properties

@property (nonatomic, strong) NSArray<id<TableCellItem>> *items;

#pragma mark - Optional methods and properties

@property (nonatomic, assign, readonly) CGFloat headerHeight;
@property (nonatomic, assign, readonly) CGFloat estimatedHeaderHeight;
@property (nonatomic, assign, readonly) CGFloat footerHeight;
@property (nonatomic, assign, readonly) CGFloat estimatedFooterHeight;

- (UIView *)headerViewFromTableView:(UITableView *)tableView at:(NSInteger)index;
- (UIView *)footerViewFromTableView:(UITableView *)tableView at:(NSInteger)index;

- (NSString *)titleForHeaderFrom:(UITableView *)tableView at:(NSInteger)index;
- (NSString *)titleForFooterFrom:(UITableView *)tableView at:(NSInteger)index;

@end
