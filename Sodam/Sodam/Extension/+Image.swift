//
//  +Image.swift
//  Sodam
//
//  Created by EMILY on 31/01/2025.
//

import SwiftUI

extension Image {
    static func hangdamImage(level: Int) -> Image {
        switch level {
        case 1: .init(.level1)
        case 2: .init(.level2)
        case 3: .init(.level3)
        case 4, 5: .init(.level4)
        default: .init(.level0)
        }
    }
}
