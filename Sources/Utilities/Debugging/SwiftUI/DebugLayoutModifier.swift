//
//  DebugLayoutModifier.swift
//  Catalog
//
//  Created by Martin Čolja on 28.03.2024..
//  Copyright © 2024 Infinum. All rights reserved.
//

#if DEBUG
import SwiftUI

@available(iOS 13.0, *)
public extension View {

    /// Use this modifier to gain insight into what is being proposed to a `View` and what it returns as it's desired size.
    /// - Parameter label: A label used to represent this View in the console output
    ///
    /// This example shows how the layout exchange between a `Color` and a `frame` modifier looks like
    /// ```swift
    /// struct ContentView: View {
    ///     var body: some View {
    ///         Color.red
    ///             .debugLayout("Color")
    ///             .frame(width: 100)
    ///             .debugLayout("width: 100")
    ///     }
    /// }
    /// ```
    ///
    /// The following is outputed to the console:
    /// ```
    /// 🔵  -> | width: 100 | w:393.0 h:759.0
    ///     🔵 -> | Color | w:100.0 h:759.0
    ///     🔶 <- | Color | w:100.0 h:759.0
    /// 🔶 <- | width: 100 | w:100.0 h:759.0
    /// ```
    @ViewBuilder
    func debugLayout(_ label: String) -> some View {
        if #available(iOS 16.0, *) {
            self.modifier(DebugLayoutModifier(label: label))
        } else {
            self
        }
    }
}

private enum LayoutDepthKey: EnvironmentKey {
    static let defaultValue: Int = .zero
}

@available(iOS 13.0, *)
private extension EnvironmentValues {

    var layoutDepth: Int {
        get { self[LayoutDepthKey.self] }
        set { self[LayoutDepthKey.self] = newValue }
    }
}

@available(iOS 16.0, *)
private struct DebugLayoutModifier: ViewModifier {
    @Environment(\.layoutDepth) private var layoutDepth
    let label: String

    func body(content: Content) -> some View {
        content
            .layoutInterceptor(label: label, depth: layoutDepth)
            .environment(\.layoutDepth, layoutDepth + 1)
    }
}

@available(iOS 16.0, *)
private extension View {

    func layoutInterceptor(label: String, depth: Int) -> some View {
        LayoutInterceptor(label: label, depth: depth) {
            self
        }
    }
}

@available(iOS 16.0, *)
private struct LayoutInterceptor: Layout {
    let label: String
    let depth: Int

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let printLayout = PrintLayout(depth: depth, label: label)

        printLayout(direction: .input, width: proposal.width, height: proposal.height)

        // subviews will always have exactly one element
        let sizeThatFits = subviews.first!.sizeThatFits(proposal)
        printLayout(direction: .output, width: sizeThatFits.width, height: sizeThatFits.height)

        return sizeThatFits
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        // Use default subviews plecement
    }
}

private struct PrintLayout {
    private let padding: String
    private let label: String

    init(depth: Int, label: String) {
        self.padding = String(repeating: "\t", count: depth)
        self.label = label
    }
}

private extension PrintLayout {

    enum Direction {
        case input
        case output
    }

    func callAsFunction(direction: Direction, width: CGFloat?, height: CGFloat?) {
        let width = "w:\(width.map(String.init) ?? "nil")"
        let height = "h:\(height.map(String.init) ?? "nil")"
        print("\(padding)\(direction.color) \(direction.arrow) | \(label) | \(width) \(height)")
    }
}

private extension PrintLayout.Direction {

    var color: String {
        switch self {
        case .input: "🔵"
        case .output: "🔶"
        }
    }

    var arrow: String {
        switch self {
        case .input: "->"
        case .output: "<-"
        }
    }
}
#endif
