//
//  AppDelegate.swift
//  Sodam
//
//  Created by 손겸 on 1/20/25.
//

import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let center = UNUserNotificationCenter.current() // 알림센터 가져오기
        center.delegate = self // 앱 실행 시 사용자에게 알림 허용 권한을 받음
        
        // 현재 알림 권한 상태를 먼저 확인
        center.getNotificationSettings { settings in
            DispatchQueue.main.async { // UI 변경은 반드시 메인 스레드에서 실행
                switch settings.authorizationStatus {
                case .notDetermined:
                    // 권한 요청 (사용자가 한 번도 응답하지 않은 상태)
                    self.requestNotificationAuthorization()
                case .denied:
                    // 권한 허용 거부된 경우 → UserDefaultsManager로 중복 표시 방지
                    if !UserDefaultsManager.shared.getIsAuthorization() {
                        self.showToast(message: "알림 권한이 거부되었습니다.")
                        UserDefaultsManager.shared.saveIsAuthorization(true) // 최초 한 번만 저장
                    }
                case .authorized, .provisional, .ephemeral:
                    // 권한이 이미 허용된 경우 (다시 요청할 필요 없음)
                    if !UserDefaultsManager.shared.getIsAuthorization() {
                        UserDefaultsManager.shared.saveIsAuthorization(true)
                    }
                @unknown default:
                    break
                }
            }
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    // 앱 첫 진입시 권한 허용 여부에 따른 토스트 알림
    private func requestNotificationAuthorization() {
        let center = UNUserNotificationCenter.current()
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]  // 필요한 알림 권한을 설정
        
        center.requestAuthorization(options: authOptions) { success, error in
            DispatchQueue.main.async { // UI 변경은 반드시 메인 스레드에서 실행
                if let error = error {
                    print("알림 권한 요청 중 에러 발생: \(error.localizedDescription)")
                    return
                }
                
                if success {
                    print("알림 권한이 허용되었습니다.")
                    // 1초 후에 토스트 메시지 띄우기
                    self.showToast(message: "알림 시간 설정이 가능합니다.")
                    UserDefaultsManager.shared.saveIsAuthorization(true)
                } else {
                    print("알림 권한이 거부되었습니다.")
                    // 1초 후에 토스트 메시지 띄우기
                    self.showToast(message: "알림 권한이 거부되었습니다.")
                    UserDefaultsManager.shared.saveIsAuthorization(true)
                }
            }
        }
    }
    
    // 안전하게 토스트 메시지를 표시하는 함수
    private func showToast(message: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // 현재 최상위 윈도우의 rootViewController의 view에서 토스트 표시(화면전환될때도 토스트 유지)
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
                keyWindow.rootViewController?.view.showToast(message: message)
            }
        }
    }
}

// MARK: - UNUserNotificationCenterDelegate Setting Method

extension AppDelegate: UNUserNotificationCenterDelegate {
    // Foreground 상태인 경우(앱 실행중인상태) 알림이 오면 해당 메서드 호출
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("🔔 Foreground에서 알림 수신: \(notification.request.identifier)") // 로그 추가
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
