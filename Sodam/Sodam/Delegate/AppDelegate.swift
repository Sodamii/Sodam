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
        center.delegate = self //앱 실행 시 사용자에게 알림 허용 권한을 받음
        
        // 권한 요청 메서드(꼭 이곳이 아니어도 원할때 권한을 받을 수 있다.)
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound] // 필요한 알림 권한을 설정
        center.requestAuthorization(options: authOptions) { success, error in
            if let error = error {
                print("알림 권한 요청 중 에러 발생: \(error.localizedDescription)")
                return
            }
            
            if success {
                // TODO: - 권한이 허용되었을 경우
                print("알림 권한이 허용되었습니다.")
            } else {
                // TODO: - 권한이 거부되었을 경우
                print("알림 권한이 거부되었습니다.")
                // 사용자에게 알림 권한을 요청할 수 있는 방법 안내 혹은 UI 처리
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
