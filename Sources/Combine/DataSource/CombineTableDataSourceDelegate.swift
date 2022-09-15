//
//  CombineTableDataSourceDelegate.swift
//  Catalog
//
//  Created by Zvonimir Medak on 15.09.2022..
//  Copyright © 2022 Infinum. All rights reserved.
//

import UIKit
import Combine
import CombineExt
import CombineCocoa

/// Object serving as a data source and delegate for a table view.
/// Main purpose is to reduce a boilerplate when dealing with simple
/// table view data displaying.
///
/// It can handle both - sections and items
@available(iOS 13.0, *)
public class CombineTableDataSourceDelegate: NSObject {

    // MARK: - Public properties

    /// Setting a sections will invoke internal reloader causing table view to refresh.
    public var sections: [TableSectionItem]? {
        didSet(oldValue) {
            reloader.reload(tableView, oldSections: oldValue, newSections: sections)
        }
    }

    /// Setting an items will invoke internal reloader causing table view to refresh.
    ///
    /// If there are multiple sections - then data is flattened to single array
    public var items: [TableCellItem]? {
        get {
            return sections?
                .map(\.items)
                .reduce(into: [TableCellItem]()) { $0 = $0 + $1 }
        }
        set {
            let section: TableSectionItem? = BlankTableSection(items: newValue)
            sections = [section].compactMap { $0 }
        }
    }

    // MARK: - Private properties

    fileprivate let tableView: UITableView
    private let reloader: TableViewReloader
    private var animator: TableCellAnimator?

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
    init(
        tableView: UITableView,
        reloader: TableViewReloader = DefaultTableViewReloader(),
        animation: TableCellAnimator.Animation? = nil
    ) {
        self.tableView = tableView
        self.reloader = reloader

        super.init()

        tableView.dataSource = self
        tableView.delegate = self

        guard let animation = animation else { return }
        animator = .init(animation: animation)
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
    var didScroll = PassthroughRelay<UIScrollView>()

    /// Forwarding publisher from `UITableViewDelegate`
    var willDisplayCell = PassthroughRelay<(cell: UITableViewCell, indexPath: IndexPath)>()

    /// Forwarding publisher from `UITableViewDelegate`
    var willDisplayHeaderView = PassthroughRelay<UIView>()

    /// Forwarding publisher from `UITableViewDelegate`
    var willDisplayFooterView = PassthroughRelay<UIView>()

    /// Forwarding publisher from `UITableViewDelegate`
    var didEndDisplaying = PassthroughRelay<UITableViewCell>()

    /// Forwarding publisher from `UITableViewDelegate`
    var didEndDisplayingHeaderView = PassthroughRelay<UIView>()

    /// Forwarding publisher from `UITableViewDelegate`
    var didEndDisplayingFooterView = PassthroughRelay<UIView>()

    /// Forwarding publisher from `UITableViewDelegate`
    var accessoryButtonTappedForRowWith = PassthroughRelay<IndexPath>()

    /// Forwarding publisher from `UITableViewDelegate`
    var didHighlightRowAt = PassthroughRelay<IndexPath>()

    /// Forwarding publisher from `UITableViewDelegate`
    var didUnhighlightRowAt = PassthroughRelay<IndexPath>()

    /// Forwarding publisher from `UITableViewDelegate`
    var didSelectRowAt = PassthroughRelay<IndexPath>()

    /// Forwarding publisher from `UITableViewDelegate`
    var didDeselectRowAt = PassthroughRelay<IndexPath>()

    /// Forwarding publisher from `UITableViewDelegate`
    var willBeginEditingRowAt = PassthroughRelay<IndexPath>()

    /// Forwarding publisher from `UITableViewDelegate`
    var didEndEditingRowAt = PassthroughRelay<IndexPath?>()

    /// Forwarding publisher from `UITableViewDelegate`
    var didUpdateFocusIn = PassthroughRelay<UITableViewFocusUpdateContext>()

    /// Forwarding publisher from `UITableViewDelegate`
    var didBeginMultipleSelectionInteractionAt = PassthroughRelay<IndexPath>()

    /// Forwarding publisher from `UITableViewDelegate`
    var willPerformPreviewActionForMenuWith = PassthroughRelay<UIContextMenuConfiguration>()

    /// Forwarding publisher from `UITableViewDelegate`
    var willDisplayContextMenu = PassthroughRelay<(UIContextMenuConfiguration, UIContextMenuInteractionAnimating?)>()

    /// Forwarding publisher from `UITableViewDelegate`
    var willEndContextMenuInteraction = PassthroughRelay<(UIContextMenuConfiguration, UIContextMenuInteractionAnimating?)>()

    // MARK: - UITableViewDelegate -

    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        willDisplayCell.accept((cell, indexPath))
        animator?.animate(cell: cell, at: indexPath, in: tableView)
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
        sections?[indexPath].didSelect(at: indexPath, tableView: tableView)

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

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        didScroll.accept(scrollView)
    }
}

// MARK: - UITableView datasource conformance

@available(iOS 13.0, *)
extension CombineTableDataSourceDelegate: UITableViewDataSource {

    public func numberOfSections(in tableView: UITableView) -> Int {
        return sections?.count ?? 0
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections?[section].items.count ?? 0
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return sections![indexPath].cell(from: tableView, at: indexPath)
    }

    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections?[section].titleForHeader(from: tableView, at: section)
    }

    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return sections?[section].titleForFooter(from: tableView, at: section)
    }
}

// MARK: - UITableView delegate conformance

@available(iOS 13.0, *)
extension CombineTableDataSourceDelegate: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return sections?[section].estimatedHeaderHeight ?? 0
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sections?[section].headerHeight ?? 0
    }

    public func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return sections?[section].estimatedFooterHeight ?? 0
    }

    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return sections?[section].footerHeight ?? 0
    }

    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return sections?[indexPath].estimatedHeight ?? 0
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return sections?[indexPath].height ?? 0
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return sections?[section].headerView(from:tableView, at:section)
    }

    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return sections?[section].footerView(from:tableView, at:section)
    }

    public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return (sections?[indexPath].canDelete ?? false) ? .delete : .none
    }

    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let item = sections?[indexPath],
              editingStyle == .delete,
              item.canDelete
        else { return }

        item.didDelete(at: indexPath)
    }
}

// MARK: - Utility -

@available(iOS 13.0, *)
public extension CombineTableDataSourceDelegate {

    func resetAnimatorIfNeeded() {
        animator?.reset()
    }
}
