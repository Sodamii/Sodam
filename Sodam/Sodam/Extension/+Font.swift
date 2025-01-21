//
//  +Font.swift
//  Sodam
//
//  Created by EMILY on 21/01/2025.
//

import SwiftUI

extension Font {
    static let mapoGoldenPier: (CGFloat) -> Font = { size in
        return .custom(CustomFont.MapoGoldenPier.rawValue, size: size)
    }
    
    static let sejongGeulggot: (CGFloat) -> Font = { size in
        return .custom(CustomFont.SejongGeulggot.rawValue, size: size)
    }
}
