//
//  UserDefaultsManager.swift
//  Sodam
//
//  Created by 박시연 on 1/22/25.
//

import Foundation

final class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    private let userDefaults = UserDefaults.standard
    
    private init() {}
    
    // 이름 충돌 방지 및 재사용성 증가
    private enum Keys {
        static let id = "id"
        static let notificationTime = "Date"
        static let isToggleNotification = "isToggleNotification"
        static let content = "content"
        static let imagePath = "imagePath"
    }
    
    // MARK: - UserDefaults에 저장
    
    func saveNotificationTime(_ date: Date) {
        userDefaults.set(date, forKey: Keys.notificationTime)
    }
    
    func saveIsToggleNotification(_ isOn: Bool) {
        userDefaults.set(isOn, forKey: Keys.isToggleNotification)
    }
    
    func saveContent(_ content: String) {
        userDefaults.set(content, forKey: Keys.content)
    }
    
    // MARK: - UserDefaults에 저장된 값 얻어오기
    
    func getNotificationTime() -> Date? {
        userDefaults.object(forKey: Keys.notificationTime) as? Date
    }
    
    func getIsToggleNotification() -> Bool {
        userDefaults.bool(forKey: Keys.isToggleNotification)
    }
    
    func getContent() -> String? {
        userDefaults.string(forKey: Keys.content)
    }
}
