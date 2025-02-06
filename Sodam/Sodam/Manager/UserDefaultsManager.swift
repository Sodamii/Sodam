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
        static let notificationTime = "time"  // 앱 알림 시간
        static let notificationToggleState = "notificationToggleState"  // 앱 알림 토글 상태
        static let content = "content"  // 작성 내용
        static let imagePath = "imagePath"  // 작성시 등록 이미지
        static let notificationAuthorizationStatus = "notificationAuthorizationStatus"  // 앱 첫 진입시 알림 권한 허용 여부 상태
    }
    
    // MARK: - UserDefaults에 저장
    
    func saveNotificationTime(_ time: Date) {
        userDefaults.set(time, forKey: Keys.notificationTime)
    }
    
    func saveNotificationToggleState(_ isOn: Bool) {
        userDefaults.set(isOn, forKey: Keys.notificationToggleState)
    }
    
    func saveContent(_ content: String) {
        userDefaults.set(content, forKey: Keys.content)
    }
    
    func saveImagePath(_ imagePath: [String]) {
        userDefaults.set(imagePath, forKey: Keys.imagePath)
    }
    
    func saveNotificaionAuthorizationStatus(_ isAuthorized: Bool) {
        userDefaults.set(isAuthorized, forKey: Keys.notificationAuthorizationStatus)
    }

    // MARK: - UserDefaults에 저장된 값 얻어오기
    
    func getNotificationTime() -> Date? {
        userDefaults.object(forKey: Keys.notificationTime) as? Date
    }
    
    func getNotificationToggleState() -> Bool {
        userDefaults.bool(forKey: Keys.notificationToggleState)
    }
    
    func getContent() -> String? {
        userDefaults.string(forKey: Keys.content)
    }
    
    func getImagePath() -> [String]? {
        userDefaults.stringArray(forKey: Keys.imagePath)
    }
    
    func deleteTemporaryPost() {
        print("[WriteView] 임시저장 됐던 content와 imagePath 삭제")
        userDefaults.removeObject(forKey: Keys.content)
        userDefaults.removeObject(forKey: Keys.imagePath)
    }
    
    func getNotificaionAuthorizationStatus() -> Bool {
        return userDefaults.bool(forKey: Keys.notificationAuthorizationStatus)
    }
}
