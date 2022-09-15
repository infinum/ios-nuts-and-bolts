//
//  TableDiffableDataSourceDelegate.swift
//  Catalog
//
//  Created by Zvonimir Medak on 15.09.2022..
//  Copyright © 2022 Infinum. All rights reserved.
//

import UIKit
import Combine
import CombineExt

/// This objects serves as a wrapper for the `UITableViewDiffableDataSource` and
/// the `UITableViewDelegate`. Delegate methods are also forwarded with Publishers.
///
/// The Table View data is controller with the `TableSectionItem` section objects, and the
/// table view is reloaded with Diffable snapshots.
///
/// **NOTE**: All `TableSectionItem` objects **must** conform to `Hashable`
/// and all `TableCelItem` objects (in the `TableSectionItem`) **must** conform to `CellItemIdentifiable`
///
@available(iOS 13.0, *)
public final class TableDiffableDataSourceDelegate: UITableViewDiffableDataSource<AnyHashable, AnyHashable>, UITableViewDelegate {

    // MARK: - Private properties -

    private let tableView: UITableView
    private var diffableSections: [AnyHashable] = []

    // MARK: - Public properties -

    /// Array of sections to be displayed.
    /// All sections must conform to `CellItemIdentifiable`
    public var sections: [TableSectionItem]? {
        didSet {
            set(sections: sections, oldSections: oldValue)
        }
    }

    /// Creates a new data source delegate object responsible for handling
    /// table view data source and delegate logic.
    ///
    /// Do **not** change the delegate of the tableView, instead, use the
    /// provided publishers that map the delegate methods.
    ///
    /// - Parameters:
    ///   - tableView: Table view to control
    public init(tableView: UITableView, rowAnimation: UITableView.RowAnimation = .fade) {
        self.tableView = tableView

        super.init(tableView: tableView, cellProvider: { tableView, indexPath, itemIdentifier in
            guard let item = itemIdentifier as? TableCellItem else { return nil }
            return item.cell(from: tableView, at: indexPath)
        })
        tableView.delegate = self

        defaultRowAnimation = rowAnimation

        // On iOS 14.0, if datasource ends up being configured before a layout pass, diffable datasource would end up crashing if differences need to be animated.
        // To circumvent the issue, we're first populating the datasource with an empty snapshot.
        // This was fixed on iOS 15.0, therefore we don't really want to do any additional work when it's not needed.
        if #available(iOS 15.0, *) { return }
        let snapshot = NSDiffableDataSourceSnapshot<AnyHashable, AnyHashable>()
        apply(snapshot, animatingDifferences: false)
    }

    /// Sets the sections by creating a new snapshot
    private func set(sections: [TableSectionItem]?, oldSections: [TableSectionItem]?) {
        guard let sections = sections else { return }
        guard let hashableSections = sections as? [AnyHashable] else {
            fatalError("Not all sections conform to Hashable!")
        }
        diffableSections = hashableSections

        var snapshot = NSDiffableDataSourceSnapshot<AnyHashable, AnyHashable>()
        snapshot.appendSections(diffableSections)

        for section in sections.enumerated() {
            guard let items = section.element.items as? [AnyHashable] else {
                fatalError("Not all items conform to Hashable!")
            }
            snapshot.appendItems(items, toSection: diffableSections[section.offset])
        }

        let shouldAnimateDifferences = oldSections != nil && defaultRowAnimation != .none
        DispatchQueue.main.async { self.apply(snapshot, animatingDifferences: shouldAnimateDifferences) }
    }

    // MARK: - UITableViewDelegate

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return sections?[section].headerView(from: tableView, at: section)
    }

    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return sections?[section].footerView(from: tableView, at: section)
    }

    public func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return sections?[section].estimatedHeaderHeight ?? .leastNonzeroMagnitude
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sections?[section].headerHeight ?? .leastNonzeroMagnitude
    }

    public func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return sections?[section].estimatedFooterHeight ?? .leastNonzeroMagnitude
    }

    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return sections?[section].footerHeight ?? .leastNonzeroMagnitude
    }

    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return sections?[indexPath.section].items[indexPath.row].estimatedHeight ?? .leastNonzeroMagnitude
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return sections?[indexPath.section].items[indexPath.row].height ?? .leastNonzeroMagnitude
    }

    // MARK: - UITableViewDelegate publishers -

    // ***************************************************************
    // *                                                             *
    // *    UITableViewDelegate forwarding publishers                *
    // *    All publishers and naming correspond with the given      *
    // *    delegate method.                                         *
    // *                                                             *
    // ***************************************************************

    /// Forwarding publisher from `UITableViewDelegate`
    public var willDisplayCell = PassthroughRelay<(cell: UITableViewCell, indexPath: IndexPath)>()

    /// Forwarding publisher from `UITableViewDelegate`
    public var willDisplayHeaderView = PassthroughRelay<UIView>()

    /// Forwarding publisher from `UITableViewDelegate`
    public var willDisplayFooterView = PassthroughRelay<UIView>()

    /// Forwarding publisher from `UITableViewDelegate`
    public var didEndDisplaying = PassthroughRelay<UITableViewCell>()

    /// Forwarding publisher from `UITableViewDelegate`
    public var didEndDisplayingHeaderView = PassthroughRelay<UIView>()

    /// Forwarding publisher from `UITableViewDelegate`
    public var didEndDisplayingFooterView = PassthroughRelay<UIView>()

    /// Forwarding publisher from `UITableViewDelegate`
    public var accessoryButtonTappedForRowWith = PassthroughRelay<IndexPath>()

    /// Forwarding publisher from `UITableViewDelegate`
    public var didHighlightRowAt = PassthroughRelay<IndexPath>()

    /// Forwarding publisher from `UITableViewDelegate`
    public var didUnhighlightRowAt = PassthroughRelay<IndexPath>()

    /// Forwarding publisher from `UITableViewDelegate`
    public var didSelectRowAt = PassthroughRelay<IndexPath>()

    /// Forwarding publisher from `UITableViewDelegate`
    public var didDeselectRowAt = PassthroughRelay<IndexPath>()

    /// Forwarding publisher from `UITableViewDelegate`
    public var willBeginEditingRowAt = PassthroughRelay<IndexPath>()

    /// Forwarding publisher from `UITableViewDelegate`
    public var didEndEditingRowAt = PassthroughRelay<IndexPath?>()

    /// Forwarding publisher from `UITableViewDelegate`
    public var didUpdateFocusIn = PassthroughRelay<UITableViewFocusUpdateContext>()

    /// Forwarding publisher from `UITableViewDelegate`
    public var didBeginMultipleSelectionInteractionAt = PassthroughRelay<IndexPath>()

    /// Forwarding publisher from `UITableViewDelegate`
    public var willPerformPreviewActionForMenuWith = PassthroughRelay<UIContextMenuConfiguration>()

    /// Forwarding publisher from `UITableViewDelegate`
    public var willDisplayContextMenu = PassthroughRelay<(UIContextMenuConfiguration, UIContextMenuInteractionAnimating?)>()

    /// Forwarding publisher from `UITableViewDelegate`
    public var willEndContextMenuInteraction = PassthroughRelay<(UIContextMenuConfiguration, UIContextMenuInteractionAnimating?)>()

    // MARK: - UITableViewDelegate -

    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        willDisplayCell.accept((cell, indexPath))
    }

    public func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        willDisplayHeaderView.accept(view)
    }

    public func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        willDisplayFooterView.accept(view)
    }

    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        didEndDisplaying.accept(cell)
    }

    public func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        didEndDisplayingHeaderView.accept(view)
    }

    public func tableView(_ tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) {
        didEndDisplayingFooterView.accept(view)
    }

    public func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        accessoryButtonTappedForRowWith.accept(indexPath)
    }

    public func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        didHighlightRowAt.accept(indexPath)
    }

    public func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        didUnhighlightRowAt.accept(indexPath)
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        sections?[indexPath.section].items[indexPath.row].didSelect(at: indexPath, tableView: tableView)

        didSelectRowAt.accept(indexPath)
    }

    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        didDeselectRowAt.accept(indexPath)
    }

    public func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        willBeginEditingRowAt.accept(indexPath)
    }

    public func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        didEndEditingRowAt.accept(indexPath)
    }

    public func tableView(
        _ tableView: UITableView,
        didUpdateFocusIn context: UITableViewFocusUpdateContext,
        with coordinator: UIFocusAnimationCoordinator
    ) {
        didUpdateFocusIn.accept(context)
    }

    public func tableView(_ tableView: UITableView, didBeginMultipleSelectionInteractionAt indexPath: IndexPath) {
        didBeginMultipleSelectionInteractionAt.accept(indexPath)
    }

    public func tableView(
        _ tableView: UITableView,
        willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration,
        animator: UIContextMenuInteractionCommitAnimating
    ) {
        willPerformPreviewActionForMenuWith.accept(configuration)
    }

    public func tableView(
        _ tableView: UITableView,
        willDisplayContextMenu configuration: UIContextMenuConfiguration,
        animator: UIContextMenuInteractionAnimating?
    ) {
        willDisplayContextMenu.accept((configuration, animator))
    }

    public func tableView(
        _ tableView: UITableView,
        willEndContextMenuInteraction configuration: UIContextMenuConfiguration,
        animator: UIContextMenuInteractionAnimating?
    ) {
        willEndContextMenuInteraction.accept((configuration, animator))
    }
}
