//
//  TableCellItem.h
//  Catalog
//
//  Created by Ivana Mršić on 20/05/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

#import <UIKit/UIKit.h>

/// Base interface for all table view cell items - used in conjuction with
/// `TableDataSourceDelegate`
@protocol TableCellItem <NSObject>

/// Estimatated cell height
///
/// If using auto layout - `height` property needs to return
/// `UITableView.automaticDimension` in order to use estimated height
@property (nonatomic, assign, readonly) CGFloat estimatedHeight;

/// Fixed cell height
@property (nonatomic, assign, readonly) CGFloat height;

#pragma mark - Required methods and properties

/// Dequeue and configure reusable cell at given index path
/// from given table view
///
/// Dequeued cell should be configured with current item before
/// returning it.
///
/// - Parameters:
///   - tableView: parent table view
///   - indexPath: index path of cell to configure
/// - Returns: Dequeued, configured and reused cell
- (UITableViewCell *)cellFromTableView:(UITableView*)tableView at:(NSIndexPath*)indexPath;

#pragma mark - Optional methods and properties

/// Notifies cell item when user selects table view cell.
///
/// - Parameter indexPath: index path of a selected cell
- (void)didSelectAt:(NSIndexPath *)indexPath;

@end
