//
//  SettingViewModel.swift
//  Sodam
//
//  Created by 박시연 on 1/24/25.
//

import UIKit

final class SettingViewModel {
    private let userDefaultsManager = UserDefaultsManager.shared
    private let localNotificationManager = LocalNotificationManager.shared

    var isToggleOn: Bool   // 앱 설정 토글 상태
    let sectionType: [Setting.SetSection] = [.appSetting, .fontSetting, .develop]   // 섹션 타입 설정
    
    // 앱 버전을 가져오는 computed property
    var version: String? {
        guard let dictionary = Bundle.main.infoDictionary,
              let version = dictionary["CFBundleShortVersionString"] as? String else {
            return nil
        }
        
        let versionString: String = "\(version)"
        return versionString
    }
    
    // MARK: - Initializer
    
    init() {
        self.isToggleOn = userDefaultsManager.getAppToggleState()  // 앱 토글 상태 가져와서 isTogglOn 초기화
    }
}

// MARK: - SettingViewController Methods

extension SettingViewModel {
    // URL 새창에서 메서드
    func openURL(_ urlString: String) {
        guard let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

// MARK: - UserDefaultsManager Methods

extension SettingViewModel {
    
    // MARK: - Save Methods
    
    // 알림 시간 저장
    func saveNotificationTime(_ time: Date) {
        userDefaultsManager.saveNotificationTime(time)
    }
    
    // 앱 설정 알림 토글 상태 저장
    func saveAppToggleState(_ isOn: Bool) {
        userDefaultsManager.saveAppToggleState(isOn)
    }
    
    // MARK: - Get Methods
    
    // 저장된 알림 시간 가져오기
    func getNotificationTime() -> Date {
        userDefaultsManager.getNotificationTime()
    }
    
    // 앱 토글 상태 가져오기
    func getToggleState() -> Bool {
        userDefaultsManager.getAppToggleState()
    }
    
    // 사용자가 설정한 예약된 알림 설정
    func setUserNotification() {
        localNotificationManager.setUserNotification()
    }
}

// MARK: - LocalNotificationManger Methods

extension SettingViewModel {
    // 요청한 알림 권한 상태 가져오기
    func checkNotificationStatus(completion: @escaping (Bool) -> Void) {
        localNotificationManager.checkAuthorization { status in
            completion(status)
        }
    }
}
