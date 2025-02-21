//
//  FontSettingViewModel.swift
//  Sodam
//
//  Created by t2023-m0019 on 2/20/25.
//

import Foundation

final class FontSettingViewModel {
    private let userDefaultsManager = UserDefaultsManager.shared

    // 폰트 목록
    let customFontTypes: [CustomFont] = CustomFont.allcases
    var selectedIndexPath: IndexPath?  // 현재 선택된 폰트의 위치(indexPath)를 저장
    var updateFontSelectionUI: ((IndexPath?) -> Void)?  // 선택된 폰트가 변경되면 UI 업데이트

    init() {
        // 초기 폰트 설정
        let initialFontName = userDefaultsManager.getFontName()
        if let index = customFontTypes.firstIndex(where: { $0.sourceName == initialFontName }) {
            selectedIndexPath = IndexPath(row: index, section: 0)
        }
    }
    
    func selectedFont(indexPath: IndexPath) {
        // 현재 선택된 IndexPath와 다르면 fontSelectionChanged를 호출하여 UI를 갱신
        if selectedIndexPath != indexPath {
            selectedIndexPath = indexPath
            updateFontSelectionUI?(selectedIndexPath)
            NotificationCenter.default.post(name: Notification.fontChanged, object: nil)
        }
    }
}
