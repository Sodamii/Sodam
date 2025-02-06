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
                // 권한 여부 체크
                if settings.authorizationStatus != .authorized {
                    // 권한 없으면 스위치 OFF로 설정
                    self.isToggleOn = false
                    self.saveIsToggleNotification(false)
                } else {
                    // 권한 있으면 스위치 ON으로 설정
                    self.isToggleOn = true
                    self.saveIsToggleNotification(true)
                    
                    // 만약 앱 첫 진입 시 알림 허용, 사용자가 알림 설정은 안한상태일때 기본 시간 설정 (저녁 9시)
                    if self.getNotificationTime() == nil {
                        let defaultTime = Calendar.current.date(bySettingHour: 21, minute: 0, second: 0, of: Date())!
                        self.saveNotificationTime(defaultTime)
                        self.setReservedNotificaion(defaultTime)
                    }
                }
            }
        }
    }
}
