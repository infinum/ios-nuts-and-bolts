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
