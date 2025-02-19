//
//  +Font.swift
//  Sodam
//
//  Created by EMILY on 21/01/2025.
//

import SwiftUI

extension Font {
    static let mapoGoldenPier: (CGFloat) -> Font = { size in
        return .custom(CustomFont.mapoGoldenPier.rawValue, size: size)
    }

    static let sejongGeulggot: (CGFloat) -> Font = { size in
        return .custom(CustomFont.sejongGeulggot.rawValue, size: size)
    }

    static func gyeonggiBatang(type: FontType, size: CGFloat) -> Font {
        let fontName = "\(CustomFont.gyeonggiBatang)\(type.rawValue)" // rOTF, bOTF 중 사용가능
        print(fontName)
        return .custom(fontName, size: size)
    }

    static func maruburiot(type: FontType, size: CGFloat) -> Font {
        let fontName = "\(CustomFont.maruBuriot.rawValue)-\(type.rawValue)" // bold, semiBold, regular 중 사용가능
        return .custom(fontName, size: size)
    }

    static func gowunBatang(type: FontType, size: CGFloat) -> Font {
        let fontName = "\(CustomFont.gowunBatang.rawValue)-\(type.rawValue)" // bold, regular 중 사용가능
        return .custom(fontName, size: size)
    }
}
