//
//  BaseTableCellItem.m
//
//  Created by Ivana Mršić on 20/05/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

#import "BaseTableCellItem.h"

@implementation BaseTableCellItem

- (__kindof UITableViewCell *)cellFromTableView:(UITableView *)tableView at:(NSIndexPath *)indexPath
{
    return nil;
}

- (void)didSelectAt:(NSIndexPath *)indexPath
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
