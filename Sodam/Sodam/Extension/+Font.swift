//
//  +Font.swift
//  Sodam
//
//  Created by EMILY on 21/01/2025.
//

import SwiftUI

extension Font {
    // 개별적으로 커스텀 폰트를 적용하고 싶을 때 사용
    static func customFont(font: CustomFont, size: CustomFontSize) -> Font {
        let fontName = font.name
        return .custom(fontName, size: size.rawValue)
    }
    
    // 앱 설정 폰트 적용할 때 사용
    static func appFont(size: CustomFontSize) -> Font {
        return .custom(CustomFontManager.fontName, size: size.rawValue)
    }
}
