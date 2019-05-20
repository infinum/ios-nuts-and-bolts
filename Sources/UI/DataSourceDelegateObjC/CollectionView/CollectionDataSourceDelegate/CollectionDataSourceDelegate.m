//
//  CollectionDataSourceDelegate.m
//  Catalog
//
//  Created by Ivana Mršić on 20/05/2019.
//  Copyright © 2019 Infinum. All rights reserved.
//

#import "CollectionDataSourceDelegate.h"
#import "BaseCollectionSection.h"

@interface CollectionDataSourceDelegate ()

#pragma mark - Private properties

@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic) id<CollectionViewReloader> reloader;

@end

@implementation CollectionDataSourceDelegate

#pragma mark - Inits

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView
{
    return [self initWithCollectionView:collectionView reloader:[DefaultCollectionViewReloader new]];
}

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView reloader:(nonnull id<CollectionViewReloader>)reloader
{
    self = [super init];
    if (self) {
        _collectionView = collectionView;
        _reloader = reloader;
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return self;
}

#pragma mark - Setters

- (void)setSections:(NSArray<id<CollectionSectionItem>> *)sections
{
    NSArray *oldSections = _sections;
    
    _sections = sections;
    
    [self.reloader reloadCollectionView:self.collectionView oldSections:oldSections newSections:sections];
}

- (void)setItems:(NSArray<id<CollectionCellItem>> *)items
{
    self.sections = @[[[BaseCollectionSection alloc] initWithItems:items]];
}

#pragma mark - Getters

- (NSArray<id<CollectionCellItem>> *)items
{
    NSMutableArray<id<CollectionCellItem>> *items = [NSMutableArray new];
    
    for (id<CollectionSectionItem> section in self.sections) {
        if (!section.items) { break; }
        
        [items addObjectsFromArray:section.items];
    }
    
    return items;
}

#pragma mark - UICollectionViewDataSource methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.sections.count;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.sections[section] items].count;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return [self.sections[indexPath.section].items[indexPath.row] cellFromCollectionView:collectionView at:indexPath];
}

#pragma mark - UICollectionViewDelegate methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
    [self.sections[indexPath.section].items[indexPath.row] didSelectAt:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.sections[indexPath.section].items[indexPath.row] willDisplayCell:cell at:indexPath];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger sectionsCount = self.sections[indexPath.section].items.count;
    
    return [self.sections[indexPath.section].items[indexPath.row] itemSizeForCollectionViewSize:collectionView.bounds.size layout:collectionViewLayout at:indexPath numberOfItemsInSection:sectionsCount];
}

@end
