//
//  SettingViewModel.swift
//  Sodam
//
//  Created by t2023-m0019 on 1/24/25.
//

import UIKit

final class SettingViewModel {
    private let userDefaultsManager = UserDefaultsManager.shared
    private let localNotificationManager = LocalNotificationManager.shared
    
    var isSwitchOn: Bool = false
    let sectionType: [Setting.SetSection] = [.appSetting, .develop]
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
        // 앱 시작 시 UserDefaults에서 값 로드
        self.isSwitchOn = userDefaultsManager.getNotificaionAuthorizationStatus()
    }
    
    func saveNotificationTime(_ sender: Date) {
        userDefaultsManager.saveNotificationTime(sender)
    }
    
    func saveIsToggleNotification(_ sender: Bool) {
        userDefaultsManager.saveNotificationToggleState(sender)
    }
    
    func getIsToggle() -> Bool {
        userDefaultsManager.getNotificationToggleState()
    }
    
    func getNotificationTime() -> Date? {
        userDefaultsManager.getNotificationTime()
    }
        
    func setReservedNotificaion(_ sender: Date) {
        localNotificationManager.setReservedNotification(sender)
    }
    
    // URL 열기 메서드
    func openURL(_ urlString: String) {
        guard let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) else {
            print("유효하지 않은 URL입니다: \(urlString)")
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
