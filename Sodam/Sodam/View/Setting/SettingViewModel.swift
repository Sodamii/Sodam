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
    
    var isToggleOn: Bool = false  // 알림 토글 상태를 나타내는 변수
    let sectionType: [Setting.SetSection] = [.appSetting, .develop]  // 섹션 타입 설정
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
        // 초기화 시, 알림 권한 상태를 가져오고, 권한 확인 메서드를 호출
        self.isToggleOn = userDefaultsManager.getNotificaionAuthorizationStatus()
        self.checkNotificationAuthorization()
    }
    
    // 알림 시간 저장
    func saveNotificationTime(_ sender: Date) {
        userDefaultsManager.saveNotificationTime(sender)
    }
    
    // 알림 토글 상태 저장
    func saveIsToggleNotification(_ sender: Bool) {
        userDefaultsManager.saveNotificationToggleState(sender)
    }
    
    // 저장된 알림 시간 가져오기
    func getNotificationTime() -> Date? {
        userDefaultsManager.getNotificationTime()
    }
    
    // 알림 토글 상태 가져오기
    func getNotificationToggleState() -> Bool {
        userDefaultsManager.getNotificationToggleState()
    }
    
    // 사용자가 설정한 예약된 알림 설정
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

// MARK: - Private Methods

private extension SettingViewModel {
    // 알림 권한 상태 확인 및 초기 설정
    func checkNotificationAuthorization() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                // 알림이 허용된 경우
                if settings.authorizationStatus == .authorized {
                    self.handleAuthorizedState()
                } else {
                    // 알림 허용되지 않은 경우, 기본 토글은 false로 설정
                    self.isToggleOn = false
                    self.saveIsToggleNotification(false)
                }
            }
        }
    }
    
    // 알람이 허용된 경우 기본시간 설정(오후 9시)
    // TODO: 만약 작성이 된 경우 오후 9시에 알람울리지않게 추가필요
    func handleAuthorizedState() {
        // 최초로 알림 권한이 허용되었을 때, 사용자가 기본 시간 설정을 하지 않았다면 설정
        if !UserDefaultsManager.shared.isNotificationSetupComplete() {
            if let defaultTime = Calendar.current.date(
                bySettingHour: 21,
                minute: 0,
                second: 0,
                of: Date()
            ) {
                self.saveNotificationTime(defaultTime)  // 기본 시간 저장
                UserDefaultsManager.shared.markNotificationSetupAsComplete() // 기본 시간 설정 완료 플래그 저장
            } else {
                print("기본시간을 설정할 수 없습니다.")
            }
        }
        
        // 알림 토글을 true로 설정하고, 저장
        self.isToggleOn = true
        self.saveIsToggleNotification(true)
    }
}
