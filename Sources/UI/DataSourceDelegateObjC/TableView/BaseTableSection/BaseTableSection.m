//
//  BaseTableSection.m
//  Catalog
//
//  Created by Ivana Mršić on 20/05/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

#import "BaseTableSection.h"
#import "TableCellItem.h"

@implementation BaseTableSection

#pragma mark - inits

- (instancetype)initWithItems:(NSArray<id<TableCellItem>> *)items
{
    self = [super init];
    if (self) {
        _items = items;
    }
    return self;
}

#pragma mark - getters

- (CGFloat)estimatedFooterHeight
{
    return self.footerHeight;
}

- (CGFloat)estimatedHeaderHeight
{
    return self.headerHeight;
}

- (CGFloat)footerHeight
{
    return 0;
}

- (CGFloat)headerHeight
{
    return 0;
}

- (UIView *)footerViewFromTableView:(UITableView *)tableView at:(NSInteger)index
{
    return nil;
}

- (UIView *)headerViewFromTableView:(UITableView *)tableView at:(NSInteger)index
{
    return nil;
}

- (NSString *)titleForFooterFrom:(UITableView *)tableView at:(NSInteger)index
{
    return nil;
}

- (NSString *)titleForHeaderFrom:(UITableView *)tableView at:(NSInteger)index
{
    return nil;
}

@end
