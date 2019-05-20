//
//  BaseTableCellItem.m
//  Catalog
//
//  Created by Ivana Mršić on 20/05/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

#import "BaseTableCellItem.h"

@implementation BaseTableCellItem

- (nonnull UITableViewCell *)cellFromTableView:(nonnull UITableView *)tableView at:(nonnull NSIndexPath *)indexPath
{
    return nil;
}

- (void)didSelectAt:(nonnull NSIndexPath *)indexPath
{
    // empty implementation
}

- (CGFloat)height
{
    return UITableViewAutomaticDimension;
}

- (CGFloat)estimatedHeight
{
    return 44;
}

@end
