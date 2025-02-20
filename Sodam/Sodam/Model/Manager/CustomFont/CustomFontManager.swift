//
//  CustomFontManager.swift
//  Sodam
//
//  Created by EMILY on 18/02/2025.
//

import UIKit

enum CustomFontManager {
    /// 커스텀 폰트를 적용할 때 UIFont(name: )의 파라미터로 폰트의 고유 이름을 String 값으로 넘겨줘야 함. 기본값은 마포금빛나루
    static var fontName: String = CustomFont.mapoGoldenPier.sourceName
    
    /// AppDelegate에서 실행 될 메소드. UserDefaults에 저장되어 있는 설정 폰트의 이름을 가져와 static 변수에 할당한다.
    static func getFont() {
        let appFontName = UserDefaultsManager.shared.getFontName()
        CustomFontManager.fontName = appFontName
    }
    
    /// 설정 탭 > 폰트 설정에서 실행 될 메소드. 사용자가 선택한 폰트 값을 UserDefaults에 저장하고,
    /// 실시간으로 앱에 반영하기 위해 static 변수에 새로운 값을 할당한 뒤 view를 reload 시키기 위해 Notification을 post한다.
    /// NotificationCenter를 통한 reload는 UIKit으로 구성된 view에 영향을 끼친다.
    static func setFont(_ fontName: String) {
        UserDefaultsManager.shared.saveFontName(fontName)
        CustomFontManager.fontName = fontName
        NotificationCenter.default.post(name: Notification.fontChanged, object: nil)
    }
    
    /// 새로운 폰트 파일을 추가했을 때 CustomFont에 추가하기 위해 필요한 폰트 고유 이름 확인하는 메소드
    /// 사용법 : main 화면 viewDidLoad에서 호출한 뒤 콘솔에서 폰트 이름 일부 키워드를 검색하여 확인한다.
    static func printFontNames() {
        for family in UIFont.familyNames {
            print("family: \(family as String)")
            
            for name in UIFont.fontNames(forFamilyName: family) {
                print("name: \(name as String)")
            }
        }
    }
}
