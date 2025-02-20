//
//  +UIFont.swift
//  Sodam
//
//  Created by EMILY on 21/01/2025.
//

import UIKit

extension UIFont {
    // 개별적으로 커스텀 폰트를 적용하고 싶을 때 사용
    static func customFont(font: CustomFont, size: CustomFontSize) -> UIFont {
        guard let customFont = UIFont(name: font.name, size: size.rawValue) else {
            return .systemFont(ofSize: size.rawValue)
        }
        return customFont
    }
    
    // 앱 설정 폰트 적용할 때 사용
    static func appFont(size: CustomFontSize) -> UIFont {
        return UIFont(name: CustomFontManager.fontName, size: size.rawValue) ?? .systemFont(ofSize: size.rawValue)
    }
}
