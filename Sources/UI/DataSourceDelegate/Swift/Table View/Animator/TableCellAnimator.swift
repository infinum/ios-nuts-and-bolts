//
//  TableCellAnimator.swift
//  Catalog
//
//  Created by Zvonimir Medak on 15.09.2022..
//  Copyright © 2022 Infinum. All rights reserved.
//
// Inspiration from: https://www.vadimbulavin.com/tableviewcell-display-animation/

import UIKit

public final class TableCellAnimator {

    public typealias Animation = (UITableViewCell, IndexPath, UITableView) -> Void

    // MARK: - Private properties -

    private var hasAnimatedAllCells = false
    private var animatedCellIndexPaths: [IndexPath] = []

    private let animation: Animation

    // MARK: - Init -

    init(animation: @escaping Animation) {
        self.animation = animation
    }
}

// MARK: - Extensions -

// MARK: - Animationg & resetting

public extension TableCellAnimator {

    /// Animates a cell at the selected index path inside the specified tableView
    func animate(cell: UITableViewCell, at indexPath: IndexPath, in tableView: UITableView) {
        guard !animatedCellIndexPaths.contains(indexPath) else { return }
        animation(cell, indexPath, tableView)
        animatedCellIndexPaths.append(indexPath)
    }

    /// Resets all of the animted cell index paths
    func reset() {
        animatedCellIndexPaths = []
    }
}

public extension TableCellAnimator {

    // Used for the example animation
    enum SlideInPosition {
        case left
        case right
    }
}

// MARK: - Animation factory -

public enum TableCellAnimationFactory {

    static func makeSlideInWithFadeAnimation(
        duration: TimeInterval,
        delay: Double,
        from position: TableCellAnimator.SlideInPosition
    ) -> TableCellAnimator.Animation {
        return { cell, _, _ in
            let translationX = position == .left ? -(cell.frame.width / 4) : cell.frame.width / 4
            cell.transform = .init(translationX: translationX, y: 0)
            cell.alpha = 0

            UIView.animate(
                withDuration: duration,
                delay: delay,
                options: [.curveEaseInOut, .allowUserInteraction],
                animations: {
                    cell.transform = .identity
                    cell.alpha = 1
                }
            )
        }
    }
}
