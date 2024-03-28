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
