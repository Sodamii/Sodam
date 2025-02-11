//
//  LocalNotificationManager.swift
//  Sodam
//
//  Created by 박시연 on 1/22/25.
//

import UserNotifications
import UIKit

final class LocalNotificationManager: NSObject {
    static let shared = LocalNotificationManager()
    
    private override init() {}
    
    // 초기 설정 체크 추가
    func checkInitialSetup() {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            // UI 변경은 반드시 메인 스레드에서 실행
            DispatchQueue.main.async {
                switch settings.authorizationStatus {
                
                // 권한 상태가 아직 결정되지 않은 경우
                case .notDetermined:
                    self.requestNotificationAuthorization { granted in
                        if granted {
                            self.setupDefaultNotificationIfNeeded()
                        }
                    }
                
                // 사용자가 알림 권한을 거부한 경우
                case .denied:
                    self.showDeniedToastOnce()
                    
                // 권한이 허용된 상태 (.authorized), 임시 권한 (.provisional), 임시적인 권한 (.ephemeral)인 경우
                case .authorized, .provisional, .ephemeral:
                    self.setupDefaultNotificationIfNeeded()
                    
                @unknown default:
                    break
                }
            }
        }
    }
    
    // 사용자에게 알림 권한을 요청하는 메서드 (최초 1회만 실행)
    func requestNotificationAuthorization(completion: @escaping (Bool) -> Void) {
        // 이미 권한이 설정되어 있는 경우 요청하지 않음
        guard !UserDefaultsManager.shared.getNotificaionAuthorizationStatus() else {
            completion(true)
            return
        }
        
        let center = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        
        center.requestAuthorization(options: options) { granted, error in
            DispatchQueue.main.async {
                if granted {
                    UserDefaultsManager.shared.saveNotificaionAuthorizationStatus(true)
                    completion(true)
                } else {
                    self.showDeniedToastOnce()
                    completion(false)
                }
            }
        }
    }
    
    /// 특정 시점에 알람 설정(매일, 사용자가 선택한 시간)
    /// - Parameters:
    ///   - time: 사용자가 설정한 알림 시간
    func setReservedNotification(_ time: Date) {
        let identifier = "SelectedTimeNotification"
        
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            
            let content = UNMutableNotificationContent()
            content.title = "Sodam"
            content.body = "소소한 행복을 적어 행담이를 키워주세요."
            content.sound = .default
            
            // 뱃지 숫자 증가를 메인 스레드에서 실행
            DispatchQueue.main.async {
                content.badge = NSNumber(value: UIApplication.shared.applicationIconBadgeNumber + 1)
                print("Content Badge: \(content.badge ?? 0)") // Badge 값 출력
            }
            
            let calendar = Calendar.current
            let components = calendar.dateComponents([.hour, .minute], from: time)
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
            
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                DispatchQueue.main.async {
                    if error != nil {
                        ToastManager.shared.showToastMessage(message: "알림 등록 실패")
                    } else {
                        let isAlreadyScheduled = requests.contains { $0.identifier == identifier }
                        guard !isAlreadyScheduled else {
                            ToastManager.shared.showToastMessage(message: "알림 시간이\(components.hour ?? 0):\(String(format: "%02d", components.minute ?? 0))로 변경되었습니다.")
                            return
                        }
                        ToastManager.shared.showToastMessage(message: "기본 알림 시간9시로 설정되었습니다.")
                    }
                }
            }
        }
    }
}

// MARK: - Private Methods

private extension LocalNotificationManager {
    // 앱 첫 실행 시 기본 알림 설정 (최초 1회만 실행)
    func setupDefaultNotificationIfNeeded() {
        // 기본 알림이 이미 설정되었는지 확인
        guard !UserDefaultsManager.shared.isNotificationSetupComplete() else { return }
        
        let calendar = Calendar.current
        let defaultTime = calendar.date(bySettingHour: 21, minute: 0, second: 0, of: Date())!
        UserDefaultsManager.shared.saveNotificationTime(defaultTime)
        
        // 기본 알림 예약 설정
        self.setReservedNotification(defaultTime)
        
        // 기본 알림 설정 완료 상태 저장
        UserDefaultsManager.shared.markNotificationSetupAsComplete()
    }
    
    // 알림 권한이 거부된 경우, 사용자에게 한 번만 알림을 제공하는 메서드
    func showDeniedToastOnce() {
        guard !UserDefaultsManager.shared.getNotificaionAuthorizationStatus() else { return }
        
        ToastManager.shared.showToastMessage(message: "알림 권한이 거부되었습니다.")
        UserDefaultsManager.shared.saveNotificaionAuthorizationStatus(true) // 사용자가 권한을 거부했을 때 "한 번만" 안내 메시지를 띄우도록 하는 목적(false면 메시지가 계속 뜨게 됨)
    }
}

// MARK: - UNUserNotificationCenterDelegate Setting Method

extension LocalNotificationManager: UNUserNotificationCenterDelegate {
    // Foreground 상태인 경우(앱 실행중인상태) 알림이 오면 해당 메서드 호출
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // 알림 수신 시 뱃지 수를 1씩 증가
        let currentBadgeCount = UIApplication.shared.applicationIconBadgeNumber
        UIApplication.shared.applicationIconBadgeNumber = currentBadgeCount + 1
        
        completionHandler([.banner, .badge, .sound, .list])
    }
    
    // Background에서 알림 클릭 시 처리사용자가 알림을 탭했을때 해당 메서드 호출
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()  // 응답 처리가 완료되었음을 시스템에 알림
    }
}
