//
//  TableViewReloader.m
//  Catalog
//
//  Created by Ivana Mršić on 20/05/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewReloader.h"
#import "TableSectionItem.h"

@implementation DefaultTableViewReloader

- (void)reloadTableView:(UITableView *)tableView oldSections:(NSArray<id<TableSectionItem>> *)oldSections newSections:(NSArray<id<TableSectionItem>> *)newSections
{
    [tableView reloadData];
}

@end

