//
//  BaseTableSection.h
//
//  Created by Ivana Mršić on 20/05/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TableCellItem.h"
#import "TableSectionItem.h"

NS_ASSUME_NONNULL_BEGIN

/// Represents blank section - without header or footer
/// Used in conjuction with table view data source delegate
/// for easy mapping items to single section without footer
/// or header - just like you didn't use section at all.
@interface BaseTableSection : NSObject <TableSectionItem>

@property (nonatomic, strong) NSArray<id<TableCellItem>> *items;

- (instancetype)initWithItems:(NSArray<id<TableCellItem>> *)items;

@end

NS_ASSUME_NONNULL_END
