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
    private let notificationCenter = UNUserNotificationCenter.current()   // 앱의 로컬 및 푸시 알림을 관리하는 중심 객체로 알림 센터 객체를 가져옵
    
    private override init() {
        super.init()
        notificationCenter.delegate = self
    }

    // MARK: - LocalNotification
    func checkAuthorization(completion: @escaping (Bool) -> Void) {
        notificationCenter.getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.handleNotificationAuthorizationStatus(settings.authorizationStatus, completion: completion)
            }
        }
    }

    // 알림 권한 여부 체크 확인 후 실행
    private func handleNotificationAuthorizationStatus(_ status: UNAuthorizationStatus, completion: @escaping (Bool) -> Void) {
        switch status {
        // 권한 설정 한적이 없는 경우
        case .notDetermined:
            print("권한 설정 한적이 없는 경우")
            requestAuthorization { [weak self] granted in
                guard let self = self else {
                    return
                }
                self.updateNotificationPermissionStatus(granted)
                completion(granted)
            }
            
        // 거부 인 경우
        case .denied:
            print("거부인 경우")
            showNotificationDeniedAlert()
            completion(false)
            
        // 허용 인 경우
        case .authorized:
            print("허용인 경우")
            updateNotificationPermissionStatus(true)
            completion(true)
            
        // 임시 또는 제한적 권한 상태에서의 처리
        case .provisional, .ephemeral:
            updateNotificationPermissionStatus(true)
            completion(true)
            
        @unknown default:
            completion(false)
        }
    }

    // 알림 권한 설정 (팝업 자체는 자동적으로 앱 첫 진입시에만 노출)
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]   //
        
        // 앱의 로컬 및 푸시 알림을 관리하는 중심 객체로 알림 센터 객체를 가져옵
        notificationCenter.requestAuthorization(options: options) { granted, error in
            if let error = error {
                print("Notification Authorization Error: \(error.localizedDescription)")
            }
            // 허용을 누르면 granted == true, 거부하면 granted == false
            completion(granted)
        }
    }

    // 알림 권한 체크
    func updateNotificationPermissionStatus(_ isGranted: Bool) {
        // 이미 알림 권한이 설정된 경우, false 일때 return
        guard !UserDefaultsManager.shared.isNotificationSetupComplete() else {
            print("!UserDefaultsManager.shared.isNotificationSetupComplete() \(!UserDefaultsManager.shared.isNotificationSetupComplete())")
            return
        }

        // 허용인 경우
        if isGranted {
            print("알림이 허용되었습니다.\(isGranted)")
            // 허용한 경우 UserDefault에 시스템 상태 true, 앱 토글 true로 저장
            UserDefaultsManager.shared.saveNotificaionAuthorizationStatus(isGranted)
            UserDefaultsManager.shared.saveAppToggleState(isGranted)
            
            // 알림 초기 설정을 완료
            UserDefaultsManager.shared.markNotificationSetupAsComplete()
            
            // 처음 시스템 허용한 경우 오후 9시 기본 알림 시간 설정
            let calendar = Calendar.current
            let defaultTime = calendar.date(bySettingHour: 21, minute: 0, second: 0, of: Date())!
            //setReservedNotification(defaultTime)
            UserDefaultsManager.shared.saveNotificationTime(defaultTime)
            
            // 알림 권한 거부 메시지 표시
            DispatchQueue.main.async {
                ToastManager.shared.showToastMessage(message: "알림 권한이 허용되었습니다")
            }

            // 거부인 경우
        } else {
            print("알림이 거부되었습니다.")
            showNotificationDeniedAlert()
        }
    }

    // 거부 인 경우
    func showNotificationDeniedAlert() {
        // 이미 알림 권한이 설정된 경우 return
        guard !UserDefaultsManager.shared.isNotificationSetupComplete() else {
            return
        }

        // UserDefault에 시스템 상태 false, 앱 토글 false로 저장
        UserDefaultsManager.shared.saveNotificaionAuthorizationStatus(false)
        UserDefaultsManager.shared.saveAppToggleState(false)
        // 알림 초기 설정을 완료
        UserDefaultsManager.shared.markNotificationSetupAsComplete()
        
        // 알림 권한 거부 메시지 표시
        DispatchQueue.main.async {
            ToastManager.shared.showToastMessage(message: "알림 권한이 거부되었습니다")
        }
    }
}

    // MARK: - 알림 예약 관련 시간/내용/트리거 설정

extension LocalNotificationManager {
    // 알림 시간 설정
    func setReservedNotification(_ time: Date) {
        let identifier = "SelectedTimeNotification"

        // 일기 작성 상태 확인
        if UserDefaultsManager.shared.getDiaryWrittenStatus() {
            // 일기 작성 시간이 현재 시간 이후인 경우 알림을 울리지 않음
            if let diaryWrittenTime = UserDefaultsManager.shared.markDiaryAsWritten() as? Date {
                if Calendar.current.isDateInToday(diaryWrittenTime) && diaryWrittenTime > time {
                    return // 일기 작성 시간이 알림 시간 이후면 알림 예약하지 않음
                }
            }
        }

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
            self.notificationCenter.add(request) { [weak self] error in
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
            // 알림 권한이 처음 허용되었을 때만 메시지 표시
            ToastManager.shared.showToastMessage(message: "알림 시간이 \(self.timeFormatted(time))로 설정되었습니다")
        }
    }

    // MARK: - 시간을 "HH:mm" 형식으로 변환

    private func timeFormatted(_ time: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: time)
    }
}

// MARK: - UNUserNotificationCenterDelegate

extension LocalNotificationManager: UNUserNotificationCenterDelegate {
    // Foreground 상태에서 알림을 수신할 때 호출
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        UIApplication.shared.applicationIconBadgeNumber += 1  // 배지 번호를 증가시켜 앱 아이콘에 표시
        completionHandler([.banner, .badge, .sound, .list])
    }

    // Background에서 알림을 클릭했을 때 호출
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler() // 응답 처리 완료
    }
}
