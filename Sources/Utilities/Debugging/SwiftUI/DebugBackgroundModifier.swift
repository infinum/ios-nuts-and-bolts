//
//  DebugBackground.swift
//  Catalog
//
//  Created by Martin Čolja on 28.03.2024..
//  Copyright © 2024 Infinum. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, *)
public extension View {

    /// A convenience method that you can use to track when SwiftUI calls `body` on `View` types.
    /// - important: Only works in `DEBUG` builds, otherwise this does nothing.
    func debugBackground() -> some View {
        #if DEBUG
            self.background(Color.random())
        #else
            self
        #endif
    }
}

@available(iOS 13.0, *)
public extension Color {

    static func random() -> Color {
        Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
}

@available(iOS 13.0, *)
public extension ShapeStyle where Self == Color {

    static func random() -> Self {
        Color.random()
    }
}
