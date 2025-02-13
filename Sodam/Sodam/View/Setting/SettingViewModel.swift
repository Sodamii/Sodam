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
    
    var isToggleOn: Bool  // 앱 설정 알림 토글 상ㅌ

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
        self.isToggleOn = userDefaultsManager.getAppNotificationToggleState()
        print("self.isToggleOn =>\(self.isToggleOn)")
    }
    
    // 알림 시간 저장
    func saveNotificationTime(_ sender: Date) {
        userDefaultsManager.saveNotificationTime(sender)
    }
    
    // 앱 설정 알림 토글 상태 저장
    func saveIsAppToggleNotification(_ sender: Bool) {
        print("sender =>\(sender)")
        userDefaultsManager.saveAppNotificationToggleState(sender)
    }
    
    // 저장된 알림 시간 가져오기
    func getNotificationTime() -> Date? {
        userDefaultsManager.getNotificationTime()
    }
    
    // 알림 토글 상태 가져오기
    func getAppNotificationToggleState() -> Bool {
        userDefaultsManager.getAppNotificationToggleState()
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
