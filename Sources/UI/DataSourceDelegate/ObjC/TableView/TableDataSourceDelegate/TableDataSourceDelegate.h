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

/**
 Indicates a mode of a tableView which `TableDataSourceDelegate` will manage.
 
 TableViewModeClassic - use it if you don't need to display title or custom view in your header/footer view.
 
 TableViewModeTitledHeaderFooter - use it if you need to display a title in your header/footer view.
 It offers a possibility of using a title in header/footer view, but you don't need to implement it.
 
 TableViewModeCustomHeaderFooter - use it if you need to display a custom view in your header/footer view.
 It offers a possibility of using custom view in header/footer view, but you don't need to implement it.
 */
typedef NS_ENUM(NSUInteger, TableViewMode) {
    
    /// Classic tableView without titles or views in table headers or footers
    TableViewModeClassic,
    
    /// TableView with optional title at header or footer.
    TableViewModeTitledHeaderFooter,
    
    /// TableView with optional view at header or footer.
    TableViewModeCustomHeaderFooter,
};

/// Object serving as a data source and delegate for a table view.
/// Main purpose is to reduce a boilerplate when dealing with simple
/// table view data displaying.
///
/// It can handle both - sections and items
@interface TableDataSourceDelegate : NSObject <UITableViewDelegate, UITableViewDataSource>

/// Setting a sections will invoke internal reloader causing table view to refresh.
@property (nonatomic, strong, nullable) NSArray<id<TableSectionItem>> *sections;

/// Setting an items will invoke internal reloader causing table view to refresh.
///
/// If there are multiple sections - then data is flattened to single array
@property (nonatomic, strong, nullable) NSArray<id<TableCellItem>> *items;

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
/// @param tableView Table view to control
/// @param mode Mode that indicates how table will be used
- (instancetype)initWithTableView:(UITableView *)tableView
                          forMode:(TableViewMode)mode;

/// Creates a new data source delegate object responsible for handling
/// table view data source and delegate logic.
///
/// **If using the data source delegate object do not change the table view
/// dataSource property since this object depends on it**
///
/// Freely use `delegate` property since internally data source delegate will
/// use pass through delegate.
///
/// @param tableView Table view to control
/// @param mode Mode that indicates how table will be used
/// @param reloader Data reloader
- (instancetype)initWithTableView:(UITableView *)tableView
                          forMode:(TableViewMode)mode
                         reloader:(id<TableViewReloader>)reloader;

@end

NS_ASSUME_NONNULL_END
