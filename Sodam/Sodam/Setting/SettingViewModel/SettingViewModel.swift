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
    
    var isToggleOn: Bool = false
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
        self.isToggleOn = userDefaultsManager.getNotificaionAuthorizationStatus()
        self.checkNotificationAuthorization()
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

private extension SettingViewModel {
    // 알림 권한을 확인하고 초기 설정
    func checkNotificationAuthorization() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                if settings.authorizationStatus == .authorized {
                    // ✅ 권한 허용 시 항상 실행되는 로직
                    self.handleAuthorizedState()
                } else {
                    self.isToggleOn = false
                    self.saveIsToggleNotification(false)
                }
            }
        }
    }
    
    func handleAuthorizedState() {
        // ✅ 최초 권한 허용인 경우에만 기본 시간 설정
        if !UserDefaultsManager.shared.isNotificationSetupComplete() {
            let defaultTime = Calendar.current.date(
                bySettingHour: 21,
                minute: 0,
                second: 0,
                of: Date()
            )!
            self.saveNotificationTime(defaultTime)
            UserDefaultsManager.shared.markNotificationSetupAsComplete()
        }
        
        self.isToggleOn = true
        self.saveIsToggleNotification(true)
    }
}
