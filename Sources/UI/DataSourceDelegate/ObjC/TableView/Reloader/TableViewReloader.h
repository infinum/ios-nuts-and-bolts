//
//  TableViewReloader.h
//
//  Created by Ivana Mršić on 20/05/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableSectionItem.h"

/// Used in conjuction with TableDataSourceDelegate to provide a way
/// to control table view reloading behavior
@protocol TableViewReloader <NSObject>

/// Called when new data arrives and reload is necessary
///
/// - Parameters:
///   - tableView: Current table view
///   - oldSections: Previous sections/items
///   - newSections: New sections/items
- (void)reloadTableView:(UITableView *)tableView
            oldSections:(NSArray<id<TableSectionItem>> *)oldSections
            newSections:(NSArray<id<TableSectionItem>> *)newSections;

@end

/// Reloads table view data simply calling table view reloadData method
@interface DefaultTableViewReloader : NSObject <TableViewReloader>

@end
