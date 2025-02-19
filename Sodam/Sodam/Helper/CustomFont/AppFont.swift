//
//  AppFont.swift
//  Sodam
//
//  Created by EMILY on 18/02/2025.
//

import UIKit

/// AppDelegate에서 AppFont.fontName에 UserDefaults에서 불러온 설정 폰트 이름을 할당해준다.
enum AppFont {
    static var fontName: String = CustomFont.mapoGoldenPier.name
    
    /// 새로운 폰트 파일을 추가했을 때 CustomFont에 추가하기 위해 필요한 폰트 고유 이름 확인하는 메소드
    /// 사용법 : main 화면 viewDidLoad에서 호출한 뒤 콘솔에서 폰트 이름 일부 키워드를 검색하여 확인한다.
    static func getFontName() {
        for family in UIFont.familyNames {
            print("family: \(family as String)")
            
            for name in UIFont.fontNames(forFamilyName: family) {
                print("name: \(name as String)")
            }
        }
    }
}
