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
    
    private override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
    // 초기 설정 체크
    func checkInitialSetup() {
        let center = UNUserNotificationCenter.current()
        // 알림 권한 설정을 비동기로 확인(center.getNotificationSettings)하고 그 결과에 따라 처리
        center.getNotificationSettings { [weak self] settings in
            self?.handleNotificationAuthorizationStatus(settings.authorizationStatus)
        }
    }
    
    // 알림 권한 상태 처리
    private func handleNotificationAuthorizationStatus(_ status: UNAuthorizationStatus) {
        switch status {
        // 권한이 아직 결정되지 않은 경우 권한 요청
        case .notDetermined:
            // 권한 요청
            requestNotificationAuthorization { [weak self] granted in
                if granted {
                    // 권한이 허가되면 기본 알림 설정
                    self?.setNotificationState(granted)
                }
            }
        // 권한이 거부된 경우 안내 메시지 표시
        case .denied:
            showDeniedToastOnce()
            
        // 권한이 이미 허가되었거나 임시 허가된 경우 기본 알림 설정
        case .authorized, .provisional, .ephemeral:
            let appToggle = UserDefaultsManager.shared.getAppNotificationToggleState()
            setNotificationState(appToggle)
            
        @unknown default:
            break
        }
    }
    
    // 알림 권한 요청 (최초 1회만 실행)
    private func requestNotificationAuthorization(completion: @escaping (Bool) -> Void) {
        // 이미 권한이 설정되어 있는 경우 요청하지 않음
        guard !UserDefaultsManager.shared.getNotificaionAuthorizationStatus() else {
            completion(true)
            return
        }
        
        let center = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        
        center.requestAuthorization(options: options) { [weak self] granted, error in
            UserDefaultsManager.shared.saveNotificaionAuthorizationStatus(true)
            
            if granted {
                // 권한이 허가여부를 UserDefaults에 저장(true가 허용)
                completion(true)
            } else {
                // 권한이 거부된 경우 안내 메시지 표시(false가 거부)
                self?.showDeniedToastOnce()
                completion(false)
            }
        }
    }
    
    func checkNotificationAuthorizationStatus(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                let isAuthorized = settings.authorizationStatus == .authorized
                UserDefaultsManager.shared.saveNotificaionAuthorizationStatus(isAuthorized)
                completion(isAuthorized)
            }
        }
    }
    
    // 알림 시간 설정 (사용자가 설정한 시간)
    func setReservedNotification(_ time: Date) {
        let identifier = "SelectedTimeNotification"
        
        // 현재 대기 중인 알림 요청을 가져와서 새로운 알림 예약
        UNUserNotificationCenter.current().getPendingNotificationRequests { [weak self] requests in
            self?.scheduleNotification(time: time, identifier: identifier, existingRequests: requests)
        }
    }
    
    // 알림 예약
    private func scheduleNotification(time: Date, identifier: String, existingRequests: [UNNotificationRequest]) {
        createNotificationContent { content in
            // 알림을 트리거할 시간 설정
            let trigger = self.createNotificationTrigger(for: time)
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            
            // 알림을 UNUserNotificationCenter에 추가
            UNUserNotificationCenter.current().add(request) { [weak self] error in
                if let error = error {
                    // 알림 등록 실패 시 에러 메시지 표시
                    DispatchQueue.main.async {
                        ToastManager.shared.showToastMessage(message: "알림 등록 실패: \(error.localizedDescription)")
                    }
                } else {
                    // 알림이 성공적으로 등록된 후 후속 처리
                    self?.handleNotificationScheduling(identifier: identifier, time: time, existingRequests: existingRequests)
                }
            }
        }
    }
    
    // 알림 내용 생성
    private func createNotificationContent(completion: @escaping (UNMutableNotificationContent) -> Void) {
        DispatchQueue.main.async {
            let content = UNMutableNotificationContent()
            content.title = "Sodam"
            content.body = "소소한 행복을 적어 행담이를 키워주세요."
            content.sound = .default
            
            let currentBadgeNumber = UIApplication.shared.applicationIconBadgeNumber
            content.badge = NSNumber(value: currentBadgeNumber + 1)
            
            completion(content) // 비동기로 content를 반환
        }
    }
    
    // MARK: - 알림 트리거 생성
    
    // 알림 트리거를 생성하는 함수 (특정 시간에 알림이 발생하도록 설정)
    private func createNotificationTrigger(for time: Date) -> UNCalendarNotificationTrigger {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: time)
        return UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
    }
    
    // MARK: - 알림 예약 후 처리
    
    private func handleNotificationScheduling(identifier: String, time: Date, existingRequests: [UNNotificationRequest]) {
        // 이미 동일한 알림이 예약되어 있는지 확인
        let isAlreadyScheduled = existingRequests.contains { $0.identifier == identifier }
        DispatchQueue.main.async {
            // 알림이 새로 예약되었거나 시간이 변경되었음을 사용자에게 알림
            let message = isAlreadyScheduled ? "알림 시간이 \(self.timeFormatted(time))로 변경되었습니다." : "기본 알림 시간 \(self.timeFormatted(time))로 설정되었습니다."
            ToastManager.shared.showToastMessage(message: message)
        }
    }
    
    // MARK: - 시간을 "HH:mm" 형식으로 변환
    
    private func timeFormatted(_ time: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: time)
    }
}

// MARK: - Private Methods

private extension LocalNotificationManager {
    func setNotificationState(_ status: Bool) {
        guard !UserDefaultsManager.shared.isNotificationSetupComplete() else {
            return
        }

        let calendar = Calendar.current
        let defaultTime = calendar.date(bySettingHour: 21, minute: 0, second: 0, of: Date())!

        UserDefaultsManager.shared.saveNotificaionAuthorizationStatus(status)
        UserDefaultsManager.shared.saveAppNotificationToggleState(status)
        UserDefaultsManager.shared.saveNotificationTime(defaultTime)
        
        setReservedNotification(defaultTime)  // 기본 알림 설정을 예약
        
        // 알림 권한 허용 메시지 표시
//        DispatchQueue.main.async {
//            ToastManager.shared.showToastMessage(message: "알림 권한이 허용되었습니다.")
//        }
        UserDefaultsManager.shared.markNotificationSetupAsComplete()  // 기본 알림 설정 완료 상태를 저장
    }
    
    // 알림 권한이 거부된 경우 사용자에게 한 번만 안내 메시지 제공
    func showDeniedToastOnce() {
        // 알림 권한 설정 확인
        guard !UserDefaultsManager.shared.isNotificationSetupComplete() else {
            return
        }
        
        // 권한이 거부된 상태를 UserDefaults에 저장
        UserDefaultsManager.shared.saveNotificaionAuthorizationStatus(false)
        UserDefaultsManager.shared.saveAppNotificationToggleState(false)
        
        // 알림 권한 거부 메시지 표시
        DispatchQueue.main.async {
            ToastManager.shared.showToastMessage(message: "알림 권한이 거부되었습니다.")
        }
        UserDefaultsManager.shared.markNotificationSetupAsComplete()  // 기본 알림 설정 완료 상태를 저장
    }
}

// MARK: - UNUserNotificationCenterDelegate

extension LocalNotificationManager: UNUserNotificationCenterDelegate {
    // Foreground 상태에서 알림을 수신할 때 호출
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .badge, .sound, .list])
    }
    
    // Background에서 알림을 클릭했을 때 호출
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler() // 응답 처리 완료
    }
}
