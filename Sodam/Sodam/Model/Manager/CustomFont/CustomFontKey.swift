//
//  CustomFontKey.swift
//  Sodam
//
//  Created by EMILY on 20/02/2025.
//

import SwiftUI

/// SwiftUI로 만든 view들에 폰트를 적용하기 위한 구현

/// 커스텀 폰트를 위해 EnvironmentKey를 만든다.
private struct CustomFontKey: EnvironmentKey {
    static var defaultValue: String {
        CustomFontManager.fontName
    }
}

/// EnvironmentKey 이름 : appFontName
extension EnvironmentValues {
    var appFontName: String {
        get { self[CustomFontKey.self] }
        set { self[CustomFontKey.self] = newValue }
    }
}

/// appFontName 키를 활용하여 커스텀 modifier를 만든다.
struct CustomFontModifier: ViewModifier {
    @Environment(\.appFontName) var appFontName
    let size: CustomFontSize
    
    func body(content: Content) -> some View {
        content
            .font(.custom(appFontName, size: size.rawValue))
    }
}

/// .appFont로 modifier를 사용할 수 있도록 extension
extension View {
    func appFont(size: CustomFontSize) -> some View {
        modifier(CustomFontModifier(size: size))
    }
}
