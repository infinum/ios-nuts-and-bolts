//
//  TableDataSourceDelegate.h
//
//  Created by Ivana Mršić on 20/05/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableSectionItem.h"
#import "TableCellItem.h"
#import "TableViewReloader.h"

NS_ASSUME_NONNULL_BEGIN

/// Object serving as a data source and delegate for a table view.
/// Main purpose is to reduce a boilerplate when dealing with simple
/// table view data displaying.
///
/// It can handle both - sections and items
@interface TableDataSourceDelegate : NSObject <UITableViewDelegate, UITableViewDataSource>

/// Setting a sections will invoke internal reloader causing table view to refresh.
@property (nonatomic, strong) NSArray<id<TableSectionItem>> *sections;

/// Setting an items will invoke internal reloader causing table view to refresh.
///
/// If there are multiple sections - then data is flattened to single array
@property (nonatomic, strong) NSArray<id<TableCellItem>> *items;

/// Creates a new data source delegate object responsible for handling
/// table view data source and delegate logic.
///
/// **If using the data source delegate object do not change the table view
/// dataSource property since this object depends on it**
///
/// Freely use `delegate` property since internally data source delegate will
/// use pass through delegate.
///
/// Object will have DefaultTableViewReloader as reloader.
///
/// - Parameters:
///   - tableView: Table view to control
- (instancetype)initWithTableView:(UITableView *)tableView;

/// Creates a new data source delegate object responsible for handling
/// table view data source and delegate logic.
///
/// **If using the data source delegate object do not change the table view
/// dataSource property since this object depends on it**
///
/// Freely use `delegate` property since internally data source delegate will
/// use pass through delegate.
///
/// - Parameters:
///   - tableView: Table view to control
///   - reloader: Data reloader
- (instancetype)initWithTableView:(UITableView *)tableView reloader:(id<TableViewReloader>)reloader;

@end

NS_ASSUME_NONNULL_END
