//
//  DebugBorderModifier.swift
//  Catalog
//
//  Created by Martin Čolja on 28.03.2024..
//  Copyright © 2024 Infinum. All rights reserved.
//

#if DEBUG
import SwiftUI

@available(iOS 13.0, *)
public extension View {

    /// Adds a border to this view with the specified style and visible width.
    /// - Parameter content: A value that conforms to the ShapeStyle protocol, like a Color
    ///  or HierarchicalShapeStyle, that SwiftUI uses to fill the border.
    /// - Parameter width: The visible thickness of the border, the default is 3 points.
    ///  The actual thickness depends on combined thicknesses of parent Views with `.debugBorder()` modifier.
    /// - Returns: A view that adds a border with the specified style and width that is larger than the border of the parent View.
    ///
    /// This modifier makes sure that a border will remain visible even if it's parent has a border of the same size.
    func debugBorder<S: ShapeStyle>(_ content: S, width: CGFloat = 3) -> some View {
        modifier(DebugBorderModifier(shapeStyle: content, visualWidth: width))
    }
}

@available(iOS 13.0, *)
private struct DebugBorderModifier<S: ShapeStyle>: ViewModifier {
    @Environment(\.totalWidth) private var totalWidth

    let shapeStyle: S
    let visualWidth: CGFloat

    func body(content: Content) -> some View {
        let width = totalWidth + visualWidth
        return content
            .environment(\.totalWidth, width)
            .border(shapeStyle, width: width)
    }
}

private enum TotalWidthKey: EnvironmentKey {
    static var defaultValue: CGFloat = .zero
}

@available(iOS 13.0, *)
private extension EnvironmentValues {

    var totalWidth: CGFloat {
        get { self[TotalWidthKey.self] }
        set { self[TotalWidthKey.self] = newValue }
    }
}
#endif
